import 'package:flutter/widgets.dart';

import '../../data/repositories/SignInRepository.dart';

enum AuthStatus { Uninitialized, Authenticated, Unauthenticated }

class AuthViewModel extends ChangeNotifier {
  final SignInRepository repository = SignInRepository();

  AuthStatus _status = AuthStatus.Uninitialized;

  AuthStatus get status => _status;

  AuthViewModel() {
    repository.onLoginStatusChanged().listen((isLogged) {
      if (isLogged) {
        _status = AuthStatus.Authenticated;
      } else {
        _status = AuthStatus.Unauthenticated;
      }
      notifyListeners();
    });
  }
}
