// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:http/http.dart' as http;

class UserModel {
  DatabaseBuilder database = DatabaseBuilder();
  final String table = "users";

  // Define a function that inserts users into the database
  Future<int> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same user is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the users from the users table.
  Future<List<User>> users() async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The users.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
              SELECT u.*, p.id as profile_id, p.name as profile_name, p.visibility as profile_visibility
              FROM $table u INNER JOIN profiles p ON p.id = u.profile_id
            ''');

    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        userUid: maps[i]['user_uid'],
        firstName: maps[i]['first_name'],
        lastName: maps[i]['last_name'],
        mobileNumber: maps[i]['mobile_number'],
        email: maps[i]['email'],
        province: maps[i]['province'],
        district: maps[i]['district'],
        password: maps[i]['password'],
        securityQuestion: maps[i]['security_question'],
        securityAnswer: maps[i]['security_answer'],
        administrativePost: maps[i]['administrative_post'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],

        //related attributes
        profileId: maps[i]['profile_id'],
        profile: maps[i]['profile_name'],
        visibility: maps[i]['profile_visibility'],
      );
    });
  }

  Future<bool> checkIfUsersExistsLocallyByUsername(
      {required String? username}) async {
    final db = await database.initializeDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'mobile_number = ? OR email = ?',
      whereArgs: [username, username],
    );

    return maps.isNotEmpty ? true : false;
  }

  Future<int> recoverUserWithSecurityQuestion(
      {required String mobileNumber,
      required String securityQuestion,
      required String securityAnswer,
      required String password}) async {
    final db = await database.initializeDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where:
          'mobile_number = ? AND security_question = ? AND security_answer = ?',
      whereArgs: [mobileNumber, securityQuestion, securityAnswer],
    );

    if (maps.isNotEmpty) {
      // Update the given User.
      return await db.rawUpdate(
          'UPDATE $table SET password = ? WHERE mobile_number = ?',
          [password, mobileNumber]);
    }

    return 0;
  }

  Future<List<User>> authanticateOnServer(
      {required String username, required String password}) async {
    final client = http.Client();
    var response = await client
        .post(
          Uri.parse("${Utils.api}/login/users"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: json.encode({
            "username": username,
            "password": password,
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      print(response.body);
      dynamic responseText;
      try {
        responseText = json.decode(response.body);
      } catch (e) {
        print(response.body);
        print("Failed to decode user json response: $e");
      }

      if (responseText["status"] == "failed") {
        return [];
      }

      if (responseText["status"] == "success") {
        User user = User.fromJson(responseText["data"]);

        await checkIfUsersExistsLocallyByUsername(username: username)
            .then((value) {
          if (value == true) {
            deleteUser(user.userUid ?? 0);
          }
        });

        int value = await insertUser(user);
        if (value > 0) {
          return [
            user.copyWith(
              profile: responseText["data"]["profile_name"],
              mobileAccess: responseText["data"]["profile_mobile_access"],
              visibility: responseText["data"]["profile_visibility"],
            )
          ];
        } else {
          return [];
        }
      }
    }
    return [];
  }

  // A method that checks the auth from the users table.
  Future<List<User>> authanticateLocally(
      {required String username, required String password}) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();
    List<Map<String, dynamic>> maps = [];

    // Query the table for all The users.
    maps = await db.rawQuery('''
                SELECT u.*,
                p.name as profile_name, 
                p.visibility as profile_visibility
                FROM users u 
                INNER JOIN profiles p ON p.id = u.profile_id 
                WHERE (u.mobile_number = '$username' OR u.email = '$username') AND u.password = '$password'
            ''');

    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        userUid: maps[i]['user_uid'],
        firstName: maps[i]['first_name'],
        lastName: maps[i]['last_name'],
        mobileNumber: maps[i]['mobile_number'],
        email: maps[i]['email'],
        province: maps[i]['province'],
        district: maps[i]['district'],
        password: maps[i]['password'],
        securityQuestion: maps[i]['security_question'],
        securityAnswer: maps[i]['security_answer'],
        administrativePost: maps[i]['administrative_post'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],

        //related attributes
        profileId: maps[i]['profile_id'],
        profile: maps[i]['profile_name'],
        visibility: maps[i]['profile_visibility'],
      );
    });
  }

  Future<int> updateUser(User user) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    print(user);

    // Update the given User.
    return await db.update(
      'users',
      user.toMap(),
      // Ensure that the User has a matching user_uid.
      where: 'user_uid = ?',
      // Pass the User's user_uid as a whereArg to prevent SQL injection.
      whereArgs: [user.userUid],
    );
  }

  Future<void> deleteUser(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the User from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific user.
      where: 'user_uid = ?',
      // Pass the User's id as a whereArg to prevent SQL injection.
      whereArgs: [userUid],
    );
  }

  Stream apiPostToServer(int userUid) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT *
      FROM $table 
      WHERE user_uid = $userUid AND (sync_status = 0 OR sync_status IS NULL) OR (updated_at > last_sync_at)
      ORDER BY id DESC
    ''');

    int count = maps.length;
    var client = http.Client();

    try {
      if (count > 0) {
        for (var i = 0; i < count; i++) {
          User user = User.fromMap(maps[i]);

          user = user.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(user.toJson(user));

          var response = await client.post(
            Uri.parse("${Utils.api}/save/users/user_uid"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body,
          );

          if (response.statusCode == 200) {
            var responseText = json.decode(response.body);
            int index = i + 1;
            if (responseText["status"] == "success") {
              int value = await updateUser(user);

              if (value > 0) {
                yield {
                  "status": "success",
                  "progress": "$index / $count",
                  "completed": (index == count) ? true : false,
                };
              } else {
                yield {
                  "status": "empty",
                  "progress": "0 / 0",
                  "completed": true,
                };
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT user_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    var response = await client.post(
      Uri.parse("${Utils.api}/fetch/users/user_uid"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: json.encode({
        "user_uid": maps,
        "province": user.province,
        "district": user.district,
        "administrative_post": user.administrativePost,
        "visibility": user.visibility,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
    }
  }
}
