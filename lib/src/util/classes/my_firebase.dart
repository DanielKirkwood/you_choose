import 'package:firebase_core/firebase_core.dart';

class MyFirebase {
  MyFirebase({
    required this.firebaseApp,
  });

  FirebaseApp firebaseApp;

  FirebaseApp get app {
    return firebaseApp;
  }
}
