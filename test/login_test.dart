import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_task_nts/app_shell.dart';
import 'package:first_task_nts/core/errors/app_failure.dart';
import 'package:first_task_nts/core/navigation/app_nav_cubit.dart';
import 'package:first_task_nts/core/widgets/app_button.dart';
import 'package:first_task_nts/features/attendance/data/datasources/attendance_local_data_source.dart';
import 'package:first_task_nts/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/filter_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/get_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:first_task_nts/features/connection/domain/entities/database_url.dart';
import 'package:first_task_nts/features/connection/domain/entities/validated_database.dart';
import 'package:first_task_nts/features/connection/domain/repository/connection_repository.dart';
import 'package:first_task_nts/features/connection/domain/usecases/get_saved_database_url.dart';
import 'package:first_task_nts/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:first_task_nts/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/filter_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/get_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/summarize_expenses.dart';
import 'package:first_task_nts/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:first_task_nts/features/home/data/datasources/home_local_data_source.dart';
import 'package:first_task_nts/features/home/data/repositories/home_repository_impl.dart';
import 'package:first_task_nts/features/home/domain/usecases/check_in.dart';
import 'package:first_task_nts/features/home/domain/usecases/get_today_session.dart';
import 'package:first_task_nts/features/home/presentation/cubit/home_cubit.dart';
import 'package:first_task_nts/features/login/data/datasources/auth_remote_data_source.dart';
import 'package:first_task_nts/features/login/data/models/sign_in_response_model.dart';
import 'package:first_task_nts/features/login/domain/entities/auth_session.dart';
import 'package:first_task_nts/features/login/domain/repository/auth_repository.dart';
import 'package:first_task_nts/features/login/domain/usecases/request_password_reset.dart';
import 'package:first_task_nts/features/login/domain/usecases/save_auth_token.dart';
import 'package:first_task_nts/features/login/domain/usecases/sign_in.dart';
import 'package:first_task_nts/features/login/presentation/cubit/login_cubit.dart';
import 'package:first_task_nts/features/login/presentation/screens/login_screen.dart';
import 'package:first_task_nts/features/login/presentation/states/login_state.dart';
import 'package:first_task_nts/features/login/presentation/utils/login_form_validators.dart';

const String _signInBody = '''
{
  "jsonrpc": "2.0",
  "id": null,
  "result": {
    "status": "success",
    "message": "Signed in successfully.",
    "code": "success",
    "data": {
      "token": "session-token-123",
      "user": {"name": "Nour El-Sayed", "email": "nour@example.com"},
      "db": "nts-test"
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
    "message": "Invalid credentials.",
    "code": "invalid_credentials",
    "data": {}
  }
}
''';

const String _sessionActiveBody = '''
{
  "jsonrpc": "2.0",
  "id": null,
  "result": {
    "status": "error",
    "message": "User is already logged in on another device.",
    "code": "session_active",
    "data": {}
  }
}
''';

const String _forgotPasswordBody = '''
{
  "jsonrpc": "2.0",
  "id": null,
  "result": {
    "status": "success",
    "message": "A reset link has been sent to your email address.",
    "code": "success",
    "data": {}
  }
}
''';

/// Serves Dio requests from a handler instead of the network, so the suite needs
/// neither a mock package nor a real server.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final FutureOr<Object?> Function(RequestOptions options) handler;

  final List<RequestOptions> calls = <RequestOptions>[];
  final List<String> bodies = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options);
    bodies.add(await _bodyOf(requestStream));

    return switch (await handler(options)) {
      ResponseBody body => body,
      final String text => _json(text),
      final Object other => throw StateError('unsupported fake response: $other'),
      null => _json('{}'),
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

/// Builds a data source whose Dio calls are served by [handler].
({AuthRemoteDataSource source, _FakeAdapter adapter}) _dataSource(
  FutureOr<Object?> Function(RequestOptions options) handler,
) {
  final _FakeAdapter adapter = _FakeAdapter(handler);
  final Dio dio = Dio()..httpClientAdapter = adapter;
  return (source: AuthRemoteDataSource(dio: dio), adapter: adapter);
}

void main() {
  final DatabaseUrl url = DatabaseUrl.parse('https://odoo.example.com/odoo');

  group('AuthRemoteDataSource.signIn', () {
    test('posts the credentials to the entered address and reads the session', () async {
      final (:source, :adapter) = _dataSource((_) => _signInBody);

      final SignInResponseModel session = await source.signIn(
        email: 'nour@example.com',
        password: 'secret',
        databaseUrl: url,
      );

      expect(
        adapter.calls.single.uri.toString(),
        'https://odoo.example.com/odoo/api/v1/auth/signin',
      );
      expect(adapter.calls.single.method, 'POST');

      final Map<String, dynamic> body =
          jsonDecode(adapter.bodies.single) as Map<String, dynamic>;
      expect(body['email'], 'nour@example.com');
      expect(body['password'], 'secret');
      expect(body['database_url'], 'https://odoo.example.com/odoo');
      expect(body['device_platform'], isNotEmpty);
      expect(body['app_version'], isNotEmpty);

      expect(session.token, 'session-token-123');
      expect(session.userName, 'Nour El-Sayed');
      expect(session.database, 'nts-test');
    });

    test('also reads a flat payload without the envelope', () async {
      final (:source, :adapter) = _dataSource(
        (_) => '{"status": "success", "data": {"access_token": "flat-token"}}',
      );

      final SignInResponseModel session =
          await source.signIn(email: 'nour@example.com', password: 'secret', databaseUrl: url);

      expect(session.token, 'flat-token');
      expect(adapter.calls, hasLength(1));
    });

    test('maps rejected credentials to a server validation failure', () async {
      final (:source, :adapter) = _dataSource((_) => _rejectedBody);

      expect(
        () => source.signIn(email: 'nour@example.com', password: 'wrong', databaseUrl: url),
        throwsA(
          isA<ServerValidationFailure>()
              .having((ServerValidationFailure failure) => failure.code, 'code', 'invalid_credentials')
              .having(
                (ServerValidationFailure failure) => failure.message,
                'message',
                'Invalid credentials.',
              ),
        ),
      );
    });

    test('gives the single-session error its own wording', () async {
      final (:source, :adapter) = _dataSource((_) => _sessionActiveBody);

      expect(
        () => source.signIn(email: 'nour@example.com', password: 'secret', databaseUrl: url),
        throwsA(
          isA<ServerValidationFailure>()
              .having((ServerValidationFailure failure) => failure.code, 'code', 'session_active')
              .having(
                (ServerValidationFailure failure) => failure.message,
                'message',
                contains('already signed in on another device'),
              ),
        ),
      );
    });

    test('maps an unreachable server to a network failure', () async {
      final (:source, :adapter) = _dataSource(
        (_) => throw DioException(
          requestOptions: RequestOptions(path: 'api/v1/auth/signin'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => source.signIn(email: 'nour@example.com', password: 'secret', databaseUrl: url),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('maps a success without a token to a validation failure', () async {
      final (:source, :adapter) = _dataSource((_) => '{"status": "success", "data": {}}');

      expect(
        () => source.signIn(email: 'nour@example.com', password: 'secret', databaseUrl: url),
        throwsA(isA<ServerValidationFailure>()),
      );
    });
  });

  group('AuthRemoteDataSource.forgotPassword', () {
    test('posts the address and returns the message of the server', () async {
      final (:source, :adapter) = _dataSource((_) => _forgotPasswordBody);

      final String message = await source.forgotPassword(
        email: 'nour@example.com',
        databaseUrl: url,
      );

      expect(
        adapter.calls.single.uri.toString(),
        'https://odoo.example.com/odoo/api/v1/auth/forgot-password',
      );
      expect(
        jsonDecode(adapter.bodies.single),
        <String, dynamic>{'email': 'nour@example.com'},
      );
      expect(message, 'A reset link has been sent to your email address.');
    });

    test('reports a rejected reset request with the server message', () async {
      final (:source, :adapter) = _dataSource((_) => _rejectedBody);

      expect(
        () => source.forgotPassword(email: 'nour@example.com', databaseUrl: url),
        throwsA(
          isA<ServerValidationFailure>().having(
            (ServerValidationFailure failure) => failure.message,
            'message',
            'Invalid credentials.',
          ),
        ),
      );
    });
  });

  group('LoginFormValidators', () {
    test('accepts an address and a password, and rejects the rest', () {
      expect(LoginFormValidators.email('nour@example.com'), isNull);
      expect(LoginFormValidators.email('nour@sub.example.co.uk'), isNull);
      expect(LoginFormValidators.email(''), isNotNull);
      expect(LoginFormValidators.email('nour@'), isNotNull);
      expect(LoginFormValidators.email('nour example.com'), isNotNull);
      expect(LoginFormValidators.password('secret'), isNull);
      expect(LoginFormValidators.password(''), isNotNull);
    });

    test('unlocks the request as soon as both fields hold something', () {
      expect(
        LoginFormValidators.isComplete(emailAddress: 'nour@example.com', passwordValue: ''),
        isFalse,
      );
      expect(
        LoginFormValidators.isComplete(emailAddress: '', passwordValue: 'secret'),
        isFalse,
      );
      expect(
        LoginFormValidators.isComplete(emailAddress: 'nour@', passwordValue: 'secret'),
        isTrue,
        reason: 'a malformed address is reported when the form is submitted',
      );
      expect(
        LoginFormValidators.isComplete(emailAddress: 'nour@example.com', passwordValue: 'secret'),
        isTrue,
      );
    });
  });

  group('LoginCubit', () {
    test('signs in with the saved address and stores the token', () async {
      final _FakeAuthRepository auth = _FakeAuthRepository();
      final LoginCubit cubit = _buildCubit(auth);
      addTearDown(cubit.close);

      await cubit.signInWith(email: 'nour@example.com', password: 'secret');

      expect(cubit.state, isA<LoginSuccess>());
      expect((cubit.state as LoginSuccess).session.token, 'session-token');
      expect(auth.savedToken, 'session-token');
      expect(auth.lastEmail, 'nour@example.com');
      expect(auth.lastDatabaseUrl.toString(), 'https://saved.example.com');
    });

    test('keeps refused credentials in a state the user can correct', () async {
      final _FakeAuthRepository auth = _FakeAuthRepository(
        failure: const ServerValidationFailure('Invalid credentials.', code: 'invalid_credentials'),
      );
      final LoginCubit cubit = _buildCubit(auth);
      addTearDown(cubit.close);

      await cubit.signInWith(email: 'nour@example.com', password: 'wrong');

      final LoginInvalidCredentials state = cubit.state as LoginInvalidCredentials;
      expect(state.message, 'Invalid credentials.');
      expect(auth.savedToken, isNull);
      expect(state.canSubmit, isTrue);
    });

    test('reports a transport failure separately from refused credentials', () async {
      final LoginCubit cubit = _buildCubit(_FakeAuthRepository(failure: const NetworkFailure()));
      addTearDown(cubit.close);

      await cubit.signInWith(email: 'nour@example.com', password: 'secret');

      expect(cubit.state, isA<LoginFailure>());
      expect((cubit.state as LoginFailure).message, isNotEmpty);
    });

    test('refuses to sign in when no verified address is saved', () async {
      final LoginCubit cubit =
          _buildCubit(_FakeAuthRepository(), connection: _FakeConnectionRepository());
      addTearDown(cubit.close);

      await cubit.signInWith(email: 'nour@example.com', password: 'secret');

      expect(cubit.state, isA<LoginMissingDatabase>());
    });

    test('drops a failure as soon as the form is edited', () async {
      final LoginCubit cubit = _buildCubit(
        _FakeAuthRepository(failure: const NetworkFailure()),
      );
      addTearDown(cubit.close);

      await cubit.signInWith(email: 'nour@example.com', password: 'secret');
      expect(cubit.state, isA<LoginFailure>());

      cubit.onFormEdited();
      expect(cubit.state, isA<LoginEditing>());

      // Nothing left to clear, so the state stays as it is.
      cubit.onFormEdited();
      expect(cubit.state, isA<LoginEditing>());
    });

    test('returns the message the server sent for a reset request', () async {
      final _FakeAuthRepository auth = _FakeAuthRepository();
      final LoginCubit cubit = _buildCubit(auth);
      addTearDown(cubit.close);

      await cubit.resetPassword('nour@example.com');

      expect(
        cubit.state,
        isA<LoginPasswordResetRequested>().having(
          (LoginPasswordResetRequested state) => state.message,
          'message',
          _FakeAuthRepository.resetMessage,
        ),
      );
    });

    test('reports a failed reset request with the server message', () async {
      final LoginCubit cubit = _buildCubit(
        _FakeAuthRepository(failure: const TimeoutFailure()),
      );
      addTearDown(cubit.close);

      await cubit.resetPassword('nour@example.com');

      expect(cubit.state, isA<LoginPasswordResetFailure>());
      expect((cubit.state as LoginPasswordResetFailure).message, isNotEmpty);
    });
  });

  group('LoginScreen', () {
    final ValidatedDatabase database = ValidatedDatabase(
      database: 'nts-test',
      baseUrl: DatabaseUrl.parse('https://saved.example.com'),
    );

    Future<void> pumpLogin(WidgetTester tester, _FakeAuthRepository auth) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final LoginCubit cubit = _buildCubit(auth);
      addTearDown(cubit.close);

      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: MaterialApp(home: LoginScreen(database: database)),
        ),
      );
      await tester.pump();
    }

    testWidgets('shows the verified server and keeps Sign in off until both fields are filled',
        (tester) async {
      await pumpLogin(tester, _FakeAuthRepository());

      expect(find.text('Sign in'), findsNWidgets(2));
      expect(find.text('Enter your credentials to continue'), findsOneWidget);
      expect(find.text('nts-test'), findsOneWidget);
      expect(find.text('saved.example.com'), findsOneWidget);

      expect(
        tester.widget<AppButton>(find.widgetWithText(AppButton, 'Sign in')).enabled,
        isFalse,
      );

      await tester.enterText(find.widgetWithText(TextFormField, 'you@company.com'), 'nour@example.com');
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.widgetWithText(AppButton, 'Sign in')).enabled,
        isFalse,
        reason: 'the password is still missing',
      );

      await tester.enterText(find.widgetWithText(TextFormField, 'Your password'), 'secret');
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.widgetWithText(AppButton, 'Sign in')).enabled,
        isTrue,
      );
    });

    testWidgets('signs in with the typed credentials and stores the token', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final _FakeAuthRepository auth = _FakeAuthRepository();
      final LoginCubit cubit = _buildCubit(auth);
      final AttendanceCubit attendanceCubit = AttendanceCubit(
        getAttendanceLogs: GetAttendanceLogs(
          AttendanceRepositoryImpl(AttendanceLocalDataSource()),
        ),
        filterAttendanceLogs: const FilterAttendanceLogs(),
      );
      final ExpensesCubit expensesCubit = ExpensesCubit(
        getExpenses: GetExpenses(
          ExpenseRepositoryImpl(ExpenseLocalDataSource()),
        ),
        filterExpenses: const FilterExpenses(),
        summarizeExpenses: const SummarizeExpenses(),
      );
      final homeSource = HomeLocalDataSource();
      final HomeCubit homeCubit = HomeCubit(
        getTodaySession: GetTodaySession(HomeRepositoryImpl(homeSource)),
        checkIn: CheckIn(HomeRepositoryImpl(homeSource)),
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider.value(value: attendanceCubit),
            BlocProvider.value(value: expensesCubit),
            BlocProvider.value(value: homeCubit),
            BlocProvider(create: (_) => AppNavCubit()),
          ],
          child: MaterialApp(home: LoginScreen(database: database)),
        ),
      );
      await tester.pump();

      await tester.enterText(find.widgetWithText(TextFormField, 'you@company.com'), 'nour@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Your password'), 'secret');
      await tester.pump();
      await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      expect(auth.lastEmail, 'nour@example.com');
      expect(auth.lastDatabaseUrl.toString(), 'https://saved.example.com');
      expect(auth.savedToken, 'session-token');

      // The shell with the bottom navigation replaces the whole login stack.
      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
      final NavigatorState navigator = tester.state<NavigatorState>(find.byType(Navigator));
      expect(navigator.canPop(), isFalse);

      // The home clock stays pending, so close every cubit before the test ends.
      await homeCubit.close();
      await attendanceCubit.close();
      await expensesCubit.close();
      await cubit.close();
    });

    testWidgets('keeps refused credentials on the form, with the server message', (tester) async {
      await pumpLogin(
        tester,
        _FakeAuthRepository(
          failure: const ServerValidationFailure('Invalid credentials.', code: 'invalid_credentials'),
        ),
      );

      await tester.enterText(find.widgetWithText(TextFormField, 'you@company.com'), 'nour@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Your password'), 'wrong');
      await tester.pump();
      await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Could not sign in'), findsOneWidget);
      expect(find.text('Invalid credentials.'), findsOneWidget);
      expect(tester.widget<TextFormField>(find.byType(TextFormField).first).controller!.text,
          'nour@example.com');

      // Editing the form drops the message about the previous attempt.
      await tester.enterText(find.widgetWithText(TextFormField, 'Your password'), 'another');
      await tester.pump();
      expect(find.text('Could not sign in'), findsNothing);
    });

    testWidgets('asks the server for a reset link with the address on the form', (tester) async {
      final _FakeAuthRepository auth = _FakeAuthRepository();
      await pumpLogin(tester, auth);

      await tester.enterText(find.widgetWithText(TextFormField, 'you@company.com'), 'nour@example.com');
      await tester.pump();
      await tester.tap(find.widgetWithText(AppButton, 'Forgot password?'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Reset password'), findsOneWidget);
      // The dialog starts from the address the user already typed.
      expect(
        tester
            .widget<TextFormField>(
              find.descendant(
                of: find.byType(AlertDialog),
                matching: find.widgetWithText(TextFormField, 'you@company.com'),
              ),
            )
            .controller!
            .text,
        'nour@example.com',
      );

      await tester.tap(find.widgetWithText(AppButton, 'Send link'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(auth.lastEmail, 'nour@example.com');
      expect(find.text(_FakeAuthRepository.resetMessage), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('refuses a malformed address before any request is made', (tester) async {
      final _FakeAuthRepository auth = _FakeAuthRepository();
      await pumpLogin(tester, auth);

      await tester.enterText(find.widgetWithText(TextFormField, 'you@company.com'), 'nour@');
      await tester.enterText(find.widgetWithText(TextFormField, 'Your password'), 'secret');
      await tester.pump();
      await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(auth.lastEmail, isNull, reason: 'nothing may be sent for an invalid address');
    });
  });
}

LoginCubit _buildCubit(_FakeAuthRepository auth, {ConnectionRepository? connection}) => LoginCubit(
      signIn: SignIn(auth),
      requestPasswordReset: RequestPasswordReset(auth),
      saveAuthToken: SaveAuthToken(auth),
      getSavedDatabaseUrl: GetSavedDatabaseUrl(
        connection ?? _FakeConnectionRepository(saved: DatabaseUrl.parse('https://saved.example.com')),
      ),
    );

/// In-memory stand-in for the authentication backend.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.failure});

  final AppFailure? failure;

  static const String resetMessage = 'A reset link has been sent to your email address.';

  String? savedToken;
  String? lastEmail;
  DatabaseUrl? lastDatabaseUrl;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
    required DatabaseUrl databaseUrl,
  }) async {
    lastEmail = email;
    lastDatabaseUrl = databaseUrl;

    final AppFailure? failure = this.failure;
    if (failure != null) throw failure;

    return const AuthSession(token: 'session-token', userName: 'Nour El-Sayed');
  }

  @override
  Future<String> requestPasswordReset({
    required String email,
    required DatabaseUrl databaseUrl,
  }) async {
    lastEmail = email;
    lastDatabaseUrl = databaseUrl;

    final AppFailure? failure = this.failure;
    if (failure != null) throw failure;

    return _FakeAuthRepository.resetMessage;
  }

  @override
  Future<void> saveAuthToken(String token) async => savedToken = token;

  @override
  Future<String?> loadAuthToken() async => savedToken;

  @override
  Future<void> clearAuthToken() async => savedToken = null;
}

/// In-memory stand-in for the connection repository, which owns the saved
/// address the login flow reads back.
class _FakeConnectionRepository implements ConnectionRepository {
  _FakeConnectionRepository({this.saved});

  DatabaseUrl? saved;

  @override
  Future<void> saveDatabaseUrl(DatabaseUrl url) async => saved = url;

  @override
  Future<DatabaseUrl?> loadSavedDatabaseUrl() async => saved;

  @override
  Future<ValidatedDatabase> validateDatabase(DatabaseUrl url) =>
      throw UnimplementedError('The login flow does not validate the address.');
}
