part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.imageURL,
    this.status = ProfileStatus.initial,
  });

  final String? imageURL;
  final ProfileStatus status;

  ProfileState copyWith({
    String? imageURL,
    ProfileStatus? status,
  }) {
    return ProfileState(
      imageURL: imageURL ?? this.imageURL,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [imageURL, status];
}
