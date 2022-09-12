part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final String? username;
  const AuthenticationSuccess({this.username});

  @override
  List<Object?> get props => [username];
}

class AuthenticationFailure extends AuthenticationState {
  @override
  List<Object?> get props => [];
}
