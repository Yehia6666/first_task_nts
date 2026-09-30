import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_formatters.dart';
import '../../../domain/entities/attendance_session.dart';
import '../../../domain/use_cases/check_in_use_case.dart';
import '../../../domain/use_cases/get_today_session_use_case.dart';

part 'home_state.dart';

/// Holds Home screen state, delegates business logic to use cases, and emits
/// states the UI renders. Contains no layout/widget code.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.getTodaySession,
    required this.checkIn,
  }) : super(const HomeInitial()) {
    load();
  }

  final GetTodaySessionUseCase getTodaySession;
  final CheckInUseCase checkIn;

  AttendanceSession? _session;
  Timer? _clock;
  bool _isCheckingIn = false;

  Future<void> load() async {
    emit(const HomeLoading());
    try {
      _session = await getTodaySession();
      _startClock();
      _emitLoaded();
    } catch (_) {
      emit(const HomeFailure('We could not load your session. Please try again.'));
    }
  }

  void _startClock() {
    _clock?.cancel();
    _clock = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _emitLoaded(),
    );
  }

  void _emitLoaded() {
    final session = _session;
    if (session == null) return;
    final now = DateTime.now();
    emit(HomeSuccess(
      session: session,
      currentTime: now,
      progress: session.progressAt(now),
      isCheckingIn: _isCheckingIn,
    ));
  }

  Future<void> onCheckInPressed() async {
    final session = _session;
    if (session == null ||
        _isCheckingIn ||
        session.status != AttendanceSessionStatus.notCheckedIn) {
      return;
    }

    _isCheckingIn = true;
    _emitLoaded();
    try {
      final now = DateTime.now();
      _session = await checkIn(now);
      _isCheckingIn = false;
      emit(HomeSuccess(
        session: _session!,
        currentTime: DateTime.now(),
        progress: _session!.progressAt(DateTime.now()),
        isCheckingIn: false,
        feedback: 'Checked in at ${AppFormatters.timeOfDayWithSeconds(now)}',
      ));
    } catch (_) {
      _isCheckingIn = false;
      _emitLoaded();
      emit(const HomeFailure('We could not check you in. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _clock?.cancel();
    _clock = null;
    return super.close();
  }
}
