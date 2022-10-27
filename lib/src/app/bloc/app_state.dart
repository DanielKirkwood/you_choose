part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    required this.firebaseApp,
    this.user = UserModel.empty,
  });

  const AppState.authenticated(UserModel user, FirebaseApp firebaseApp)
      : this._(
          status: AppStatus.authenticated,
          user: user,
          firebaseApp: firebaseApp,
        );

  const AppState.unauthenticated(FirebaseApp firebaseApp)
      : this._(
          status: AppStatus.unauthenticated,
          firebaseApp: firebaseApp,
        );

  final AppStatus status;
  final UserModel user;
  final FirebaseApp firebaseApp;

  @override
  List<Object> get props => [status, user];
}
