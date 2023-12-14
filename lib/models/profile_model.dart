// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/profile.dart';
import 'package:http/http.dart' as http;

class ProfileModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "profiles";

  // Define a function that inserts profiles into the database
  Future<int> insertProfile(Profile profile) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Profile into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same profile is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the profiles from the profiles table.
  Future<List<Profile>> profiles() async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps =
        await db.query(table, orderBy: "id DESC");

    // Convert the List<Map<String, dynamic> into a List<Profile>.
    return List.generate(maps.length, (i) {
      return Profile(
        id: maps[i]['id'],
        name: maps[i]['name'],
        visibility: maps[i]['visibility'],
      );
    });
  }

  // A method that retrieves all the profiles from the profiles table.
  Future<Profile> profileById(String name) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: "name = ?", whereArgs: [name]);

    var data = maps.first;

    // Convert the List<Map<String, dynamic> into a List<Profile>.
    return Profile(
      id: data['id'],
      name: data['name'],
      visibility: data['visibility'],
    );
  }

  Stream apiGetFromServer() async* {
    print("Profile model called");
    final db = await database.initializeDatabase();
    var client = http.Client();

    print(client.toString());

    try {
      var response = await client.get(
        Uri.parse("${Utils.api}/profiles"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print("Successfully downloaded profiles ${response.body}");

        await db.rawDelete("DELETE FROM $table");

        var responseText = json.decode(response.body);

        if (responseText["status"] == "success") {
          for (var i = 0; i < responseText["data"].length; i++) {
            Profile profile = Profile.fromJson(responseText["data"][i]);
            insertProfile(profile);
          }
        }
      } else {
        print("Profiles: response code ${response.statusCode}");
        print("Profiles: request ${response.request}");
        yield false;
      }
      yield true;
    } catch (e) {
      print("Profiles: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
