import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/viewmodel/utils/Reponse.dart';

import '../model/repositories/SignInRepository.dart';

enum AuthStatus { UNINITIALIZED, AUTHENTICATED, UNAUTHENTICATED }

class AuthViewModel extends ChangeNotifier {
  final SignInRepository repository = SignInRepository();

  Response<AuthStatus> _response = Response.complete(AuthStatus.UNINITIALIZED);

  Response<AuthStatus> get response => _response;
  
  void autoLogin() {
    repository.onLoginStatusChanged().listen((isLogged) {
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
}
