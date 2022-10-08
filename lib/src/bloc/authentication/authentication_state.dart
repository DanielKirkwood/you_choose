part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final UserModel user;
  const AuthenticationSuccess({required this.user});

  @override
  List<Object> get props => [user];

  AuthenticationSuccess copyWith({UserModel? user}) {
    return AuthenticationSuccess(user: user ?? this.user);
  }
}

class AuthenticationFailure extends AuthenticationState {
  @override
  List<Object> get props => [];
}
