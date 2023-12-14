// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:http/http.dart' as http;

class FarmerModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "farmers";

  // Define a function that inserts farmers into the database
  Future<int> insertFarmer(Farmer farmer) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Farmer into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same farmer is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      farmer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the farmers from the farmers table.
  Future<List<Farmer>> farmers(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    String campaignFilter = "";

    // Query the table for all The farmers.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT DISTINCT
            f.id, 
            f.farmer_uid, 
            f.user_uid, 
            f.first_name, 
            f.last_name, 
            f.gender, 
            f.birth_date,
            f.birth_year,
            f.mobile_number,
            f.email,
            f.province,
            f.district,
            f.administrative_post,
            f.created_at,
            f.updated_at,
            f.last_sync_at,
            f.sync_status,
            f.status,
            (SELECT COALESCE(COUNT(*),0) FROM plots WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid) AS numberOfPlots,
            (SELECT COALESCE(SUM(number_of_trees),0) + COALESCE(SUM(number_of_small_trees),0) FROM plots WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid) AS numberOfTrees
          FROM $table f WHERE f.user_uid = $userUid
          ORDER BY f.status DESC
        ''');

    // Convert the List<Map<String, dynamic> into a List<Farmer>.
    return List.generate(maps.length, (i) {
      return Farmer(
        id: maps[i]['id'],
        farmerUid: maps[i]['farmer_uid'],
        userUid: maps[i]['user_uid'],
        firstName: maps[i]['first_name'],
        lastName: maps[i]['last_name'],
        gender: maps[i]['gender'],
        birthDate: (maps[i]['birth_date'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['birth_date'])
            : null,
        birthYear: maps[i]['birth_year'],
        mobileNumber: maps[i]['mobile_number'],
        email: maps[i]['email'],
        province: maps[i]['province'],
        district: maps[i]['district'],
        administrativePost: maps[i]['administrative_post'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
        status: maps[i]['status'],

        //related attributes
        numberOfPlots: maps[i]['numberOfPlots'],
        numberOfTrees: maps[i]['numberOfTrees'],
      );
    });
  }

  Future<int> updateFarmer(Farmer farmer) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given Farmer.
    return await db.update(
      table,
      farmer.toMap(),
      // Ensure that the Farmer has a matching farmer_uid.
      where: 'farmer_uid = ?',
      // Pass the Farmer's farmer_uid as a whereArg to prevent SQL injection.
      whereArgs: [farmer.farmerUid],
    );
  }

  Future<int> deleteFarmer(int farmerUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the Farmer from the database.
    return await db.delete(
      table,
      // Use a `where` clause to delete a specific farmer.
      where: 'farmer_uid = ?',
      // Pass the Farmer's farmer_uid as a whereArg to prevent SQL injection.
      whereArgs: [farmerUid],
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
          print("Farmer Model 2: ${maps[i]}");
          Farmer farmer = Farmer.fromMap(maps[i]);
          print("Farmer Model 3: $farmer");

          farmer = farmer.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(farmer.toJson());
          print("Farmer Model 4: $body");

          var response = await client.post(
            Uri.parse("${Utils.api}/save/farmers/farmer_uid"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body,
          );

          print("Response Farmer Model: ${response.reasonPhrase}");

          if (response.statusCode == 200) {
            var responseText = json.decode(response.body);
            int index = i + 1;
            if (responseText["status"] == "success") {
              int value = await updateFarmer(farmer);

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
      print("farmers: ${e.toString()}");
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT farmer_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse("${Utils.api}/fetch/farmers/farmer_uid"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: json.encode({
          "uid": maps,
          "province": user.province,
          "district": user.district,
          "administrative_post": user.administrativePost,
          "visibility": user.visibility
        }),
      );

      if (response.statusCode == 200) {
        var responseText = json.decode(response.body);
        print(responseText);
        var count = responseText.length;

        if (responseText.isNotEmpty) {
          for (var i = 0; i < count; i++) {
            int index = i + 1;
            try {
              Farmer farmer = Farmer.fromJson(responseText[i]);
              int value = await insertFarmer(farmer);

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
            } catch (e) {
              print(e.toString());
            }
          }
        }
      } else {
        print(
            "farmers: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("farmers: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
