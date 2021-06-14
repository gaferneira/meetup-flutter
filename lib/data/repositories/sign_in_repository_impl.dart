import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_meetup/data/repositories/sign_in_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInRepositoryImpl extends SignInRepository {

  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  SignInRepositoryImpl({required this.auth, required this.googleSignIn});

  @override
  Future<String?> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential authResult =
        await auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = auth.currentUser!;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }

  @override
  Future<void> signOutGoogle() async {
    await auth.signOut();
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  @override
  User? getCurrentUser() {
    return auth.currentUser;
  }

  @override
  Stream<bool> onLoginStatusChanged() {
    return auth.authStateChanges().map<bool>((user) => user != null);
  }
}
