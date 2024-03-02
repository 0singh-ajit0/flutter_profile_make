import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();

  static AuthService get instance => AuthService();
  FirebaseAuth get _auth => FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Log in
  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Log out
  Future<void> logOut() async {
    if (currentUser != null) {
      await _auth.signOut();
    }
  }
}
