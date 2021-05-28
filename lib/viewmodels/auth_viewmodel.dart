import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/sign_in_repository.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';


enum AuthStatus { UNINITIALIZED, AUTHENTICATED, UNAUTHENTICATED }

class AuthViewModel extends ChangeNotifier {
  final SignInRepository repository = SignInRepository();
  StreamSubscription? streamSubscription;

  Response<AuthStatus> _response = Response.complete(AuthStatus.UNINITIALIZED);

  Response<AuthStatus> get response => _response;
  
  void autoLogin() {
    streamSubscription = repository.onLoginStatusChanged().listen((isLogged) {
      if (isLogged) {
        _response = Response.complete(AuthStatus.AUTHENTICATED);
      } else {
        _response = Response.complete(AuthStatus.UNAUTHENTICATED);
      }
      notifyListeners();
    });
  }
  
  void signInWithGoogle() {
    repository.signInWithGoogle().then((result) => {
      if (result != null) {
        // success
      }
    });
  }

  signOut() {
    repository.signOutGoogle();
  }

  User? getCurrentUser() {
    return repository.getCurrentUser();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
}
