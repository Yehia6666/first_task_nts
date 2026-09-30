part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.session,
    required this.currentTime,
    required this.progress,
    required this.isCheckingIn,
    this.feedback,
  });

  final AttendanceSession session;
  final DateTime currentTime;

  /// Fraction (0..1) of the working window elapsed at [currentTime].
  final double progress;
  final bool isCheckingIn;

  /// One-time message for the UI to surface (e.g. check-in confirmation).
  final String? feedback;

  @override
  List<Object?> get props => [
        session,
        currentTime,
        progress,
        isCheckingIn,
        feedback,
      ];
}

class HomeFailure extends HomeState {
  const HomeFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
