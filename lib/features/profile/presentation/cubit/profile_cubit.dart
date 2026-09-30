import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.getUserProfile}) : super(const ProfileInitial());

  final GetUserProfile getUserProfile;

  bool _isCardFlipped = false;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final UserProfile profile = await getUserProfile();
      if (isClosed) return;
      emit(ProfileSuccess(
        name: profile.displayName,
        email: _first(profile.email, profile.employee?.workEmail),
        phone: _first(
          profile.phone,
          profile.employee?.workPhone,
          profile.employee?.workMobile,
        ),
        company: profile.employee?.company ?? '',
        department: profile.employee?.department ?? '',
        employeeId: _first(
          profile.employee?.code,
          profile.employee?.id?.toString(),
        ),
        imageUrl: profile.employee?.imageUrl ?? '',
        isCardFlipped: _isCardFlipped,
      ));
    } on AppFailure catch (failure) {
      if (isClosed) return;
      emit(ProfileFailure(failure.message));
    } on TimeoutException {
      if (isClosed) return;
      emit(const ProfileFailure(
        'The server took too long to return your profile. Check your connection and try again.',
      ));
    } catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(const ProfileFailure(
        'We could not load your profile. Please try again.',
      ));
    }
  }

  static String _first(String? preferred, String? fallback, [
    String? second,
  ]) {
    if (preferred != null && preferred.trim().isNotEmpty) return preferred;
    if (fallback != null && fallback.trim().isNotEmpty) return fallback;
    if (second != null && second.trim().isNotEmpty) return second;
    return '';
  }

  void toggleCardFlip() {
    final current = state;
    if (current is ProfileSuccess) {
      _isCardFlipped = !_isCardFlipped;
      emit(current.copyWith(isCardFlipped: _isCardFlipped));
    }
  }
}
