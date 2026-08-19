import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  static const _profileData = {
    'name': 'Mobile App Test (copy)',
    'email': 'mo_test@test.com',
    'phone': '+02 2 2727008',
    'company': 'ProService',
    'department': 'Mobile Development',
    'employeeId': 'EMP-2024-001',
  };

  bool _isCardFlipped = false;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(ProfileSuccess(
      name: _profileData['name']!,
      email: _profileData['email']!,
      phone: _profileData['phone']!,
      company: _profileData['company']!,
      department: _profileData['department']!,
      employeeId: _profileData['employeeId']!,
      isCardFlipped: _isCardFlipped,
    ));
  }

  void toggleCardFlip() {
    final current = state;
    if (current is ProfileSuccess) {
      _isCardFlipped = !_isCardFlipped;
      emit(current.copyWith(isCardFlipped: _isCardFlipped));
    }
  }

  void simulateError() {
    emit(const ProfileFailure(
      'Failed to load profile. Please try again.',
    ));
  }
}
