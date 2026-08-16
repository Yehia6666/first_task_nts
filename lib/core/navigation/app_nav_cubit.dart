import 'package:flutter_bloc/flutter_bloc.dart';

/// App-level navigation destinations reachable from the drawer and the bottom
/// navigation bar. The order matches the destination stack in [AppShell].
enum AppDestination {
  home,
  timeOff,
  payroll,
  expense,
  attendance,
  settings,
}

/// Holds the currently selected destination. This is the single source of
/// truth shared by the app shell (bottom nav) and the drawer, so the active
/// item always stays in sync with the visible destination.
class AppNavCubit extends Cubit<AppDestination> {
  AppNavCubit() : super(AppDestination.home);

  AppDestination? _previous;

  /// Switches to [destination], remembering the previously active destination
  /// so [goBack] can return to it (used by the drawer-only Attendance screen).
  void select(AppDestination destination) {
    if (state == destination) return;
    _previous = state;
    emit(destination);
  }

  /// Returns to the destination that was active before the last [select].
  /// No-op when there is nothing to return to.
  void goBack() {
    final previous = _previous;
    if (previous == null || previous == state) return;
    _previous = null;
    emit(previous);
  }
}
