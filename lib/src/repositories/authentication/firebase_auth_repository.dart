import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/authentication/authentication_repository.dart';
import 'package:you_choose/src/repositories/database/firestore_repository.dart';
import 'package:you_choose/src/util/cache/cache.dart';

/// {@template sign_up_with_email_and_password_failure}
/// Thrown if during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class FirebaseAuthRepository extends AuthenticationRepository {
  /// {@macro authentication_repository}
  FirebaseAuthRepository(
      {CacheClient? cache,
      firebase_auth.FirebaseAuth? firebaseAuth,
      FirestoreRepository? firestoreRepository})
      : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _db = FirestoreRepository();

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirestoreRepository _db;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [UserModel] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [UserModel.empty()] if the user is not authenticated.
  @override
  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null
          ? const UserModel.empty()
          : UserModel(
              uid: firebaseUser.uid,
              username: "",
              email: firebaseUser.email!,
              isVerified: firebaseUser.emailVerified,
              useDefaultProfileImage: true);

      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [UserModel.empty()] if there is no cached user.
  @override
  UserModel get currentUser {
    return _cache.read<UserModel>(key: userCacheKey) ?? const UserModel.empty();
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [UserModel.empty()] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

// class FirebaseAuthRepository implements AuthenticationRepository {
//   final FirebaseAuth _auth;
//   final FirestoreRepository _db;

//   FirebaseAuthRepository(
//       {FirebaseAuth? firebaseAuth, FirestoreRepository? firestoreRepository})
//       : _auth = firebaseAuth ?? FirebaseAuth.instance,
//         _db = FirestoreRepository();

//   var logger = getLogger('FirebaseAuthRepository');

//   @override
//   Stream<UserModel> getCurrentUser() {
//     return _auth.authStateChanges().map((User? user) {
//       if (user != null) {
//         return UserModel(
//           uid: user.uid,
//           username: "",
//           email: user.email!,
//           isVerified: user.emailVerified,
//           useDefaultProfileImage: true,
//         );
//       } else {
//         return const UserModel.empty();
//       }
//     });
//   }

//   @override
//   Future<UserCredential> signUp(
//       {required String email, required String password}) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);

//       await verifyEmail();

//       return userCredential;
//     } on FirebaseAuthException catch (error) {
//       AuthResultStatus status = handleException(error);
//       String errorMessage = generateExceptionMessage(status);
//       logger.e(errorMessage);
//       throw FirebaseAuthException(code: error.code, message: errorMessage);
//     }
//   }

//   @override
//   Future<UserCredential> signIn(
//       {required String email, required String password}) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);

//       return userCredential;
//     } on FirebaseAuthException catch (error) {
//       AuthResultStatus status = handleException(error);
//       String errorMessage = generateExceptionMessage(status);
//       logger.e(errorMessage);
//       throw FirebaseAuthException(code: error.code, message: errorMessage);
//     }
//   }

//   @override
//   Future<void> signOut() async {
//     if (_auth.currentUser != null) {
//       await _auth.signOut();
//     } else {
//       logger.w('signOut failed as no user logged in');
//     }
//   }

//   @override
//   Future<UserModel> getUserData({required String email}) async {
//     UserModel dbUser = await _db.getUser(email: email);
//     return dbUser;
//   }

//   // send email verification email to user
//   Future<void> verifyEmail() async {
//     User? user = _auth.currentUser;
//     if (user != null && !user.emailVerified) {
//       return await user.sendEmailVerification();
//     }
//   }

//   bool isValidEmail(String email) {
//     return RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(email);
//   }

//   static handleException(e) {
//     AuthResultStatus status;
//     switch (e.code) {
//       case "invalid-email":
//         status = AuthResultStatus.invalidEmail;
//         break;
//       case "wrong-password":
//         status = AuthResultStatus.wrongPassword;
//         break;
//       case "user-not-found":
//         status = AuthResultStatus.userNotFound;
//         break;
//       case "user-disabled":
//         status = AuthResultStatus.userDisabled;
//         break;
//       case "too-many-requests":
//         status = AuthResultStatus.tooManyRequests;
//         break;
//       case "operation-not-allowed":
//         status = AuthResultStatus.operationNotAllowed;
//         break;
//       case "email-already-in-use":
//         status = AuthResultStatus.emailAlreadyExists;
//         break;
//       case "username-already-exists":
//         status = AuthResultStatus.usernameAlreadyExists;
//         break;
//       default:
//         status = AuthResultStatus.undefined;
//     }
//     return status;
//   }

//   static generateExceptionMessage(exceptionCode) {
//     String errorMessage;
//     switch (exceptionCode) {
//       case AuthResultStatus.invalidEmail:
//         errorMessage = "Your email address appears to be malformed.";
//         break;
//       case AuthResultStatus.wrongPassword:
//         errorMessage = "Your password is incorrect.";
//         break;
//       case AuthResultStatus.userNotFound:
//         errorMessage = "User with this email doesn't exist.";
//         break;
//       case AuthResultStatus.userDisabled:
//         errorMessage = "User with this email has been disabled.";
//         break;
//       case AuthResultStatus.tooManyRequests:
//         errorMessage = "Too many requests. Try again later.";
//         break;
//       case AuthResultStatus.operationNotAllowed:
//         errorMessage = "Signing in with Email and Password is not enabled.";
//         break;
//       case AuthResultStatus.emailAlreadyExists:
//         errorMessage =
//             "The email has already been registered. Please login or reset your password.";
//         break;
//       case AuthResultStatus.usernameAlreadyExists:
//         errorMessage = "The username has been taken. Please try another.";
//         break;
//       default:
//         errorMessage = "An undefined Error happened.";
//     }

//     return errorMessage;
//   }

//   @override
//   Future<void> changeUserPassword(String newPassword) async {
//     try {
//       User? currentUser = _auth.currentUser;

//       await currentUser?.updatePassword(newPassword);
//     } on FirebaseAuthException catch (error) {
//       AuthResultStatus status = handleException(error);
//       String errorMessage = generateExceptionMessage(status);
//       logger.e(errorMessage);
//       throw FirebaseAuthException(code: error.code, message: errorMessage);
//     }
//   }
// }
