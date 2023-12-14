// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:sprayer_app/entities/user.dart';

class UserCookies {

  FutureOr<bool> save(User user) async {
    remove();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userUid", user.userUid ?? 0);
    prefs.setString("firstName", user.firstName ?? "");
    prefs.setString("lastName", user.lastName ?? "");
    prefs.setString("mobileNumber", user.mobileNumber ?? "");
    prefs.setString("email", user.email ?? "");
    prefs.setString("province", user.province ?? "");
    prefs.setString("district", user.district ?? "");
    prefs.setString("administrativePost", user.administrativePost ?? "");
    prefs.setString("password", user.password ?? "");
    prefs.setString("profile", user.profile ?? "");
    prefs.setString("visibility", user.visibility ?? "");

    print("object prefernces");
    print(prefs.toString());

    return true;
  }

  FutureOr<User> read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt("id");
    int? userUid = prefs.getInt("userUid");
    String? firstName = prefs.getString("firstName");
    String? lastName = prefs.getString("lastName");
    String? mobileNumber = prefs.getString("mobileNumber");
    String? email = prefs.getString("email");
    String? province = prefs.getString("province");
    String? district = prefs.getString("district");
    String? administrativePost = prefs.getString("administrativePost");
    String? password = prefs.getString("password");
    String? profile = prefs.getString("profile");
    String? visibility = prefs.getString("visibility");

    return User(
      id: id,
      userUid: userUid,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      email: email,
      province: province,
      district: district,
      administrativePost: administrativePost,
      password: password,
      profile: profile,
      visibility: visibility,
    );
  }

  void remove() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("id");
    prefs.remove("userUid");
    prefs.remove("firstName");
    prefs.remove("lastName");
    prefs.remove("mobileNumber");
    prefs.remove("email");
    prefs.remove("province");
    prefs.remove("district");
    prefs.remove("administrativePost");
    prefs.remove("password");
    prefs.remove("profile");
    prefs.remove("visibility");
  }
}
