part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileSuccess extends ProfileState {
  const ProfileSuccess({
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.department,
    required this.employeeId,
    this.imageUrl = '',
    this.isCardFlipped = false,
  });

  final String name;
  final String email;
  final String phone;
  final String company;
  final String department;
  final String employeeId;
  final String imageUrl;
  final bool isCardFlipped;

  ProfileSuccess copyWith({bool? isCardFlipped}) {
    return ProfileSuccess(
      name: name,
      email: email,
      phone: phone,
      company: company,
      department: department,
      employeeId: employeeId,
      imageUrl: imageUrl,
      isCardFlipped: isCardFlipped ?? this.isCardFlipped,
    );
  }

  @override
  List<Object> get props => [
        name,
        email,
        phone,
        company,
        department,
        employeeId,
        imageUrl,
        isCardFlipped,
      ];
}

final class ProfileFailure extends ProfileState {
  final String error;
  const ProfileFailure(this.error);

  @override
  List<Object> get props => [error];
}
