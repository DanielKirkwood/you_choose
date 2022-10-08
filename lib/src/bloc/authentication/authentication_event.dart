part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationPasswordChanged extends AuthenticationEvent {
  final String newPassword;

  const AuthenticationPasswordChanged({required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}

class AuthenticationSignedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationProfileImageChanged extends AuthenticationEvent {
  final XFile newImage;
  final String uid;

  const AuthenticationProfileImageChanged(
      {required this.newImage, required this.uid});

  @override
  List<Object> get props => [newImage, uid];
}
