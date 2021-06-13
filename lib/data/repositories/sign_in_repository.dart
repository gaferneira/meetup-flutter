import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInRepository {
  Future<String?> signInWithGoogle();
  Future<void> signOutGoogle();
  User? getCurrentUser();
  Stream<bool> onLoginStatusChanged();
}
