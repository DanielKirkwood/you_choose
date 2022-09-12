part of 'form_bloc.dart';

enum Status { signIn, signUp }

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends FormEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends FormEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class UsernameChanged extends FormEvent {
  final String username;
  const UsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class FormSubmitted extends FormEvent {
  final Status value;
  const FormSubmitted({required this.value});

  @override
  List<Object> get props => [value];
}

class FormSucceeded extends FormEvent {
  const FormSucceeded();

  @override
  List<Object> get props => [];
}
