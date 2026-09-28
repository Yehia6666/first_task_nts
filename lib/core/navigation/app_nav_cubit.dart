import 'package:flutter_bloc/flutter_bloc.dart';

enum AppDestination {
  home,
  timeOff,
  payroll,
  expense,
  attendance,
  settings,
}

class AppNavCubit extends Cubit<AppDestination> {
  AppNavCubit() : super(AppDestination.home);

  AppDestination? _previous;

  void select(AppDestination destination) {
    if (state == destination) return;
    _previous = state;
    emit(destination);
  }

  void goBack() {
    final previous = _previous;
    if (previous == null || previous == state) return;
    _previous = null;
    emit(previous);
  }
}
