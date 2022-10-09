part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({this.status = ProfileStatus.initial});

  final ProfileStatus status;

  @override
  List<Object> get props => [status];
}
