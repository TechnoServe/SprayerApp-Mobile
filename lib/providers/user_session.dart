import 'package:flutter/foundation.dart';
import 'package:sprayer_app/entities/user.dart';

class UserSession with ChangeNotifier{
  User? _loggedUser;

  User? get loggedUser => _loggedUser;

  void updateLoggedUser(User currentUser)
  {
    _loggedUser = currentUser;
    notifyListeners();
  }
}