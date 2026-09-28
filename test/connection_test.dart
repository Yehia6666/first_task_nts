import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_task_nts/core/constants/app_config.dart';
import 'package:first_task_nts/core/errors/app_failure.dart';
import 'package:first_task_nts/features/connection/data/datasources/database_validation_remote_data_source.dart';
import 'package:first_task_nts/features/connection/data/models/validated_database_model.dart';
import 'package:first_task_nts/features/connection/domain/entities/database_url.dart';
import 'package:first_task_nts/features/connection/domain/entities/validated_database.dart';
import 'package:first_task_nts/features/connection/domain/repository/connection_repository.dart';
import 'package:first_task_nts/features/connection/domain/usecases/get_saved_database_url.dart';
import 'package:first_task_nts/features/connection/domain/usecases/save_database_url.dart';
import 'package:first_task_nts/features/connection/domain/usecases/validate_database.dart';
import 'package:first_task_nts/features/connection/domain/usecases/validate_database_url.dart';
import 'package:first_task_nts/features/connection/presentation/cubit/database_setup_cubit.dart';
import 'package:first_task_nts/features/connection/presentation/states/database_setup_state.dart';

const String _successBody = '''
{
  "jsonrpc": "2.0",
  "id": null,
  "result": {
    "status": "success",
    "message": "Database is valid and ready for mobile authentication.",
    "code": "success",
    "data": {
      "database": "nts-almosa-staging-38592426",
      "base_url": "https://aalmosa-staging.odoo.com",
      "odoo_version": "18.0+e",
      "required_modules": ["nts_mobile_attendance_api"],
      "installed_modules": ["base", "nts_mobile_attendance_api"],
      "mobile_api_ready": true
    }
  }
}
''';

const String _rejectedBody = '''
{
  "jsonrpc": "2.0",
  "id": null,
  "result": {
    "status": "error",
    "message": "Database URL host does not match this Odoo server.",
    "code": "invalid_url",
    "data": {}
  }
}
''';

/// Serves Dio requests from a handler instead of the network, so the suite
/// needs neither a mock package nor a real server. A handler answers with a
/// ready [ResponseBody], or with a [String] that is served as JSON.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final FutureOr<Object?> Function(RequestOptions options) handler;

  final List<RequestOptions> calls = <RequestOptions>[];
  String lastBody = '';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options);
    lastBody = await _bodyOf(requestStream);

    final Future<Object?> answer = Future<Object?>.sync(() => handler(options));
    final Duration? limit = options.receiveTimeout;
    final Object? result = limit == null
        ? await answer
        : await answer.timeout(
            limit,
            onTimeout: () => throw DioException(
              requestOptions: options,
              type: DioExceptionType.receiveTimeout,
              message: 'The server did not answer in time.',
            ),
          );

    return switch (result) {
      ResponseBody body => body,
      final String text => _json(text),
      _ => throw StateError('unsupported fake response: $result'),
    };
  }

  @override
  void close({bool force = false}) {}

  static Future<String> _bodyOf(Stream<Uint8List>? stream) async {
    if (stream == null) return '';
    final List<Uint8List> chunks = await stream.toList();
    return utf8.decode(<int>[for (final Uint8List chunk in chunks) ...chunk]);
  }
}

/// A JSON body, the way the API answers.
ResponseBody _json(String body, {int status = 200}) => ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );

/// A non-JSON body, the way a proxy or a login page answers.
ResponseBody _page(String body, {int status = 200}) => ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: <String>['text/html; charset=utf-8'],
      },
    );

/// Builds a data source whose Dio calls are served by [handler].
({DatabaseValidationRemoteDataSource source, _FakeAdapter adapter}) _dataSource(
  FutureOr<Object?> Function(RequestOptions options) handler, {
  Duration timeout = const Duration(seconds: 5),
}) {
  final _FakeAdapter adapter = _FakeAdapter(handler);
  final Dio dio = Dio()..httpClientAdapter = adapter;
  return (
    source: DatabaseValidationRemoteDataSource(dio: dio, timeout: timeout),
    adapter: adapter,
  );
}

void main() {
  group('DatabaseUrl', () {
    test('normalizes the configured address and builds endpoints', () {
      final DatabaseUrl url = DatabaseUrl.parse('  ${AppConfig.defaultDatabaseUrl}/  ');

      expect(url.toString(), 'https://aalmosa-staging.odoo.com');
      expect(url.endpoint('api/v1/auth/validate-database'),
          'https://aalmosa-staging.odoo.com/api/v1/auth/validate-database');
    });

    test('keeps a path prefix so proxied servers keep working', () {
      expect(
        DatabaseUrl.parse('https://erp.example.com/odoo')
            .endpoint('api/v1/auth/validate-database'),
        'https://erp.example.com/odoo/api/v1/auth/validate-database',
      );
    });

    test('rejects empty, non-https and embedded-credential addresses', () {
      for (final String invalid in <String>[
        '   ',
        'http://aalmosa-staging.odoo.com',
        'https://',
        'https://admin:secret@odoo.com',
        'not a url',
      ]) {
        expect(
          () => DatabaseUrl.parse(invalid),
          throwsA(isA<InvalidDatabaseUrlException>()),
          reason: '"$invalid" must be rejected',
        );
      }
    });

    test('defaults a bare host to https', () {
      expect(DatabaseUrl.parse('odoo.example.com').toString(), 'https://odoo.example.com');
    });
  });

  group('DatabaseValidationRemoteDataSource', () {
    test('posts the entered address to the validation endpoint', () async {
      final (:source, :adapter) = _dataSource((_) => _successBody);

      await source.validateDatabase(
        DatabaseUrl.parse('https://erp.example.com/odoo'),
      );

      final RequestOptions call = adapter.calls.single;
      expect(call.method, 'POST');
      expect(call.uri.toString(),
          'https://erp.example.com/odoo/api/v1/auth/validate-database');
      expect(
        jsonDecode(adapter.lastBody),
        <String, dynamic>{'database_url': 'https://erp.example.com/odoo'},
      );
    });

    test('unwraps the JSON-RPC envelope of a successful validation', () async {
      final (:source, :adapter) = _dataSource((_) => _successBody);

      final ValidatedDatabaseModel model = await source.validateDatabase(
        DatabaseUrl.parse(AppConfig.defaultDatabaseUrl),
      );

      expect(model.database, 'nts-almosa-staging-38592426');
      expect(model.baseUrl.toString(), 'https://aalmosa-staging.odoo.com');
      expect(
        model.statusMessage,
        'Database is valid and ready for mobile authentication.',
      );
      expect(adapter.calls, hasLength(1));
    });

    test('also accepts a flat payload without the envelope', () async {
      final (:source, :adapter) = _dataSource(
        (_) => '{"status": "success", "message": "ok", "data": {"database": "prod", "base_url": "https://odoo.example.com"}}',
      );

      final ValidatedDatabaseModel model = await source.validateDatabase(
        DatabaseUrl.parse('https://odoo.example.com'),
      );

      expect(model.database, 'prod');
      expect(model.statusMessage, 'ok');
    });

    test('keeps the entered address when the server returns no base url', () async {
      final (:source, :adapter) = _dataSource(
        (_) => '{"status": "success", "data": {"database": "prod"}}',
      );

      final ValidatedDatabaseModel model = await source.validateDatabase(
        DatabaseUrl.parse('https://odoo.example.com/odoo'),
      );

      expect(model.baseUrl.toString(), 'https://odoo.example.com/odoo');
    });

    test('maps a rejected address to a server validation failure', () async {
      final (:source, :adapter) = _dataSource((_) => _rejectedBody);

      expect(
        () => source.validateDatabase(DatabaseUrl.parse(AppConfig.defaultDatabaseUrl)),
        throwsA(
          isA<ServerValidationFailure>()
              .having((ServerValidationFailure failure) => failure.code, 'code', 'invalid_url')
              .having(
                (ServerValidationFailure failure) => failure.message,
                'message',
                'Database URL host does not match this Odoo server.',
              ),
        ),
      );
    });

    test('maps a missing route to a server request failure', () async {
      final (:source, :adapter) = _dataSource((_) => _page('Not Found', status: 404));

      expect(
        () => source.validateDatabase(DatabaseUrl.parse(AppConfig.defaultDatabaseUrl)),
        throwsA(isA<ServerRequestFailure>().having(
          (ServerRequestFailure failure) => failure.statusCode,
          'statusCode',
          404,
        )),
      );
    });

    test('reports the message of an error body when the server sends one', () async {
      final (:source, :adapter) = _dataSource(
        (_) => _json(
          '{"result": {"message": "Invalid or missing JSON in request body"}}',
          status: 500,
        ),
      );

      expect(
        () => source.validateDatabase(DatabaseUrl.parse(AppConfig.defaultDatabaseUrl)),
        throwsA(isA<ServerRequestFailure>().having(
          (ServerRequestFailure failure) => failure.message,
          'message',
          'Invalid or missing JSON in request body',
        )),
      );
    });

    test('maps a proxy page to an unexpected response failure', () async {
      final (:source, :adapter) = _dataSource((_) => _page('<html>proxy error</html>'));

      expect(
        () => source.validateDatabase(DatabaseUrl.parse(AppConfig.defaultDatabaseUrl)),
        throwsA(isA<UnexpectedResponseFailure>()),
      );
    });

    test('maps a success without a database to an unexpected response failure', () async {
      final (:source, :adapter) = _dataSource(
        (_) => '{"result": {"status": "success", "data": {}}}',
      );

      expect(
        () => source.validateDatabase(DatabaseUrl.parse(AppConfig.defaultDatabaseUrl)),
        throwsA(isA<UnexpectedResponseFailure>()),
      );
    });

    test('maps a silent server to a timeout failure', () async {
      final (:source, :adapter) = _dataSource(
        (_) => Completer<ResponseBody>().future,
        timeout: const Duration(milliseconds: 50),
      );

      expect(
        () => source.validateDatabase(DatabaseUrl.parse(AppConfig.defaultDatabaseUrl)),
        throwsA(isA<TimeoutFailure>()),
      );
    });

    test('maps transport errors to a network failure', () async {
      final (:source, :adapter) = _dataSource(
        (_) => throw DioException(
          requestOptions: RequestOptions(path: 'api/v1/auth/validate-database'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => source.validateDatabase(DatabaseUrl.parse(AppConfig.defaultDatabaseUrl)),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('configures the timeouts it needs, and keeps ones already set', () {
      final Dio fresh = Dio();
      DatabaseValidationRemoteDataSource(dio: fresh);
      expect(fresh.options.connectTimeout, const Duration(seconds: 15));
      expect(fresh.options.sendTimeout, const Duration(seconds: 15));
      expect(fresh.options.receiveTimeout, const Duration(seconds: 15));

      final Dio custom = Dio()..options.receiveTimeout = const Duration(seconds: 2);
      DatabaseValidationRemoteDataSource(dio: custom);
      expect(custom.options.receiveTimeout, const Duration(seconds: 2));
    });
  });

  group('DatabaseSetupCubit', () {
    DatabaseSetupCubit buildCubit(_FakeConnectionRepository repository) =>
        DatabaseSetupCubit(
          validateDatabaseUrl: const ValidateDatabaseUrl(),
          validateDatabase: ValidateDatabase(repository),
          saveDatabaseUrl: SaveDatabaseUrl(repository),
          getSavedDatabaseUrl: GetSavedDatabaseUrl(repository),
        );

    /// The field starts empty, so a test that reaches the server types an
    /// address the way the user does.
    DatabaseSetupCubit buildTypedCubit(_FakeConnectionRepository repository) {
      final DatabaseSetupCubit cubit = buildCubit(repository);
      cubit.onUrlChanged(AppConfig.defaultDatabaseUrl);
      return cubit;
    }

    test('starts with an empty field, not the configured address', () async {
      final DatabaseSetupCubit cubit = buildCubit(_FakeConnectionRepository());
      addTearDown(cubit.close);

      expect(cubit.state, isA<DatabaseSetupInitial>());
      expect(cubit.state.url, isEmpty);
    });

    test('rejects an empty address before any request is made', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository();
      final DatabaseSetupCubit cubit = buildCubit(repository);
      addTearDown(cubit.close);

      await cubit.onContinuePressed();

      final DatabaseSetupFailure state = cubit.state as DatabaseSetupFailure;
      expect(state.message, 'Please enter the server URL.');
      expect(repository.validateDatabaseCalls, 0);
    });

    test('rejects a non-https address without calling the server', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository();
      final DatabaseSetupCubit cubit = buildCubit(repository);
      addTearDown(cubit.close);

      cubit.onUrlChanged('http://odoo.example.com');
      await cubit.onContinuePressed();

      final DatabaseSetupFailure state = cubit.state as DatabaseSetupFailure;
      expect(state.message, contains('https'));
      expect(repository.validateDatabaseCalls, 0);
    });

    test('defaults a bare host to https before validating', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository();
      final DatabaseSetupCubit cubit = buildCubit(repository);
      addTearDown(cubit.close);

      cubit.onUrlChanged('erp.example.com');
      await cubit.onContinuePressed();

      final DatabaseSetupReady state = cubit.state as DatabaseSetupReady;
      expect(state.database.baseUrl.toString(), 'https://erp.example.com');
      expect(repository.saved?.toString(), 'https://erp.example.com');
    });

    test('validates, saves and reports the hand-over in a single press', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository();
      final DatabaseSetupCubit cubit = buildTypedCubit(repository);
      addTearDown(cubit.close);

      await cubit.onContinuePressed();

      final DatabaseSetupReady state = cubit.state as DatabaseSetupReady;
      expect(state.database.database, 'nts-almosa-staging-38592426');
      expect(repository.saved?.toString(), AppConfig.defaultDatabaseUrl);
      expect(repository.validateDatabaseCalls, 1);
    });

    test('keeps a rejected address next to the field, with the server message', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository(
        failure: const ServerValidationFailure(
          'Database URL host does not match this Odoo server.',
          code: 'invalid_url',
        ),
      );
      final DatabaseSetupCubit cubit = buildTypedCubit(repository);
      addTearDown(cubit.close);

      await cubit.onContinuePressed();

      final DatabaseSetupFailure state = cubit.state as DatabaseSetupFailure;
      expect(state.message, 'Database URL host does not match this Odoo server.');
      expect(repository.saved, isNull);
    });

    test('surfaces a failed connection under the field', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository(
        failure: const NetworkFailure(),
      );
      final DatabaseSetupCubit cubit = buildTypedCubit(repository);
      addTearDown(cubit.close);

      await cubit.onContinuePressed();

      final DatabaseSetupFailure state = cubit.state as DatabaseSetupFailure;
      expect(state.message, 'No internet connection. Please try again.');
      expect(repository.saved, isNull);
      expect(state.canContinue, isTrue, reason: 'the button lets the user retry');
    });

    test('clears the failure as soon as the user edits the field', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository(
        failure: const NetworkFailure(),
      );
      final DatabaseSetupCubit cubit = buildTypedCubit(repository);
      addTearDown(cubit.close);

      await cubit.onContinuePressed();
      expect(cubit.state, isA<DatabaseSetupFailure>());

      cubit.onUrlChanged('https://other.example.com');
      expect(cubit.state, isA<DatabaseSetupInitial>());
    });

    test('re-verifies the address when the user edits it again', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository();
      final DatabaseSetupCubit cubit = buildTypedCubit(repository);
      addTearDown(cubit.close);

      await cubit.onContinuePressed();
      expect(cubit.state, isA<DatabaseSetupReady>());

      cubit.onUrlChanged('https://other.example.com');
      expect(cubit.state, isA<DatabaseSetupInitial>());

      await cubit.onContinuePressed();
      expect(cubit.state, isA<DatabaseSetupReady>());
      expect(repository.saved?.toString(), 'https://other.example.com');
      expect(repository.validateDatabaseCalls, 2);
    });

    test('ignores further attempts while a validation is in flight', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository(
        inFlight: Completer<ValidatedDatabase>(),
      );
      final DatabaseSetupCubit cubit = buildTypedCubit(repository);
      addTearDown(cubit.close);

      final Future<void> first = cubit.onContinuePressed();
      await cubit.onContinuePressed();
      await cubit.onContinuePressed();

      expect(repository.validateDatabaseCalls, 1);
      expect(cubit.state, isA<DatabaseSetupValidating>());

      repository.inFlight!.complete(
        ValidatedDatabase(
          database: 'prod',
          baseUrl: DatabaseUrl.parse(AppConfig.defaultDatabaseUrl),
        ),
      );
      await first;

      expect(cubit.state, isA<DatabaseSetupReady>());
    });

    test('prefills a previously saved address', () async {
      final _FakeConnectionRepository repository = _FakeConnectionRepository(
        initialUrl: DatabaseUrl.parse('https://saved.example.com'),
      );
      final DatabaseSetupCubit cubit = buildCubit(repository);
      addTearDown(cubit.close);

      await cubit.stream.firstWhere(
        (DatabaseSetupState state) => state.url == 'https://saved.example.com',
      );

      expect(cubit.state.url, 'https://saved.example.com');
    });
  });
}

/// In-memory stand-in for the Odoo backend.
class _FakeConnectionRepository implements ConnectionRepository {
  _FakeConnectionRepository({
    this.failure,
    this.inFlight,
    DatabaseUrl? initialUrl,
  }) : saved = initialUrl;

  final AppFailure? failure;
  final Completer<ValidatedDatabase>? inFlight;

  int validateDatabaseCalls = 0;
  DatabaseUrl? saved;

  @override
  Future<ValidatedDatabase> validateDatabase(DatabaseUrl url) async {
    validateDatabaseCalls++;
    final Completer<ValidatedDatabase>? inFlight = this.inFlight;
    if (inFlight != null) return inFlight.future;

    final AppFailure? failure = this.failure;
    if (failure != null) throw failure;

    return ValidatedDatabase(
      database: 'nts-almosa-staging-38592426',
      baseUrl: url,
      statusMessage: 'Database is valid and ready for mobile authentication.',
    );
  }

  @override
  Future<void> saveDatabaseUrl(DatabaseUrl url) async => saved = url;

  @override
  Future<DatabaseUrl?> loadSavedDatabaseUrl() async => saved;
}
