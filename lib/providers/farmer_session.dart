import 'package:flutter/foundation.dart';

class FarmerSession with ChangeNotifier {
  dynamic _profile;

  get profile => _profile;

  void update(dynamic data) {
    _profile = data;

    notifyListeners();
  }
}
