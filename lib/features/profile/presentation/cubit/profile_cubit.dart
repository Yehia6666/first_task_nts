import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/token_store.dart';
import '../../domain/usecases/get_profile_use_case.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.getProfile, required this.tokenStore})
      : super(const ProfileInitial());

  final GetProfileUseCase getProfile;
  final TokenStore tokenStore;

  bool _isCardFlipped = false;

  /// Reads the persisted bearer token and loads the profile. When no token is
  /// stored the request is skipped and a failure is emitted instead of calling
  /// the API unauthenticated.
  Future<void> load() async {
    emit(const ProfileLoading());

    final token = await tokenStore.read();
    if (token == null || token.isEmpty) {
      emit(const ProfileFailure('No active session. Please sign in again.'));
      return;
    }

    final result = await getProfile(token);
    result.fold(
      (failure) => emit(ProfileFailure(failure.errorMessage)),
      (profile) => emit(ProfileSuccess(
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
        company: profile.company,
        department: profile.department,
        employeeId: profile.employeeId,
        isCardFlipped: _isCardFlipped,
      )),
    );
  }

  void toggleCardFlip() {
    final current = state;
    if (current is ProfileSuccess) {
      _isCardFlipped = !_isCardFlipped;
      emit(current.copyWith(isCardFlipped: _isCardFlipped));
    }
  }
}
