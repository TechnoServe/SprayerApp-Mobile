// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/application.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class ApplicationModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "chemical_application";

  // Define a function that inserts application into the database
  Future<int> insertApplication(Application application) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Application into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same application is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      application.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the application from the application table.
  Future<List<Application>> applications(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The chemicalAcquisitions.
    String filter = await Utils.getCurrentCampaignFilter(alias: "ch");

    // Query the table for all The farmers.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT DISTINCT 
            f.first_name, 
            f.last_name, 
            ch.id,
            COALESCE(ch.chemical_application_uid, 0) AS chemical_application_uid,
            COALESCE(ch.farmer_uid, 0) AS farmer_uid,
            COALESCE(ch.user_uid, 0) AS user_uid,
            COALESCE(ch.number_of_trees_sprayed, 0) AS number_of_trees_sprayed,
            COALESCE(ch.number_of_small_trees_sprayed, 0) AS number_of_small_trees_sprayed,
            COALESCE(ch.application_number, 0) AS application_number,
            ch.sprayed_at,
            ch.created_at,
            ch.updated_at,
            ch.last_sync_at,
            ch.sync_status
          FROM farmers f
          LEFT JOIN $table ch ON ch.farmer_uid = f.farmer_uid
          WHERE f.user_uid = $userUid $filter
          ORDER BY ch.id DESC
        ''');

    print(maps);

    // Convert the List<Map<String, dynamic> into a List<Application>.
    return List.generate(maps.length, (i) {
      return Application(
        id: maps[i]['id'],
        chemicalApplicationUid: maps[i]['chemical_application_uid'],
        userUid: maps[i]['user_uid'],
        farmerUid: maps[i]['farmer_uid'],
        numberOfTreesSprayed: maps[i]['number_of_trees_sprayed'],
        numberOfSmallTreesSprayed: maps[i]['number_of_small_trees_sprayed'],
        applicationNumber: maps[i]['application_number'],
        sprayedAt: (maps[i]['sprayed_at'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['sprayed_at'])
            : DateTime.now(),
        createdAt: (maps[i]['created_at'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at'])
            : DateTime.now(),
        updatedAt: (maps[i]['updated_at'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at'])
            : DateTime.now(),
        lastSyncAt: (maps[i]['last_sync_at'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at'])
            : DateTime.now(),
        syncStatus: maps[i]['sync_status'] ?? 0,

        //related attributes
        firstName: maps[i]['first_name'],
        lastName: maps[i]['last_name'],
      );
    });
  }

  // A method that retrieves all the farmers from the farmers table.
  Future<List<Farmer>> farmers(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    String filter = await Utils.getCurrentCampaignFilter(alias: "f");

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
            f.mobile_number,
            f.email,
            f.province,
            f.district,
            f.administrative_post,
            f.created_at,
            f.updated_at,
            f.last_sync_at,
            f.sync_status,
            (SELECT COALESCE(SUM(number_of_trees),0) + COALESCE(SUM(number_of_small_trees),0) FROM plots WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid) AS numberOfTrees,
            (SELECT COALESCE(SUM(number_of_trees_sprayed),0) + COALESCE(SUM(number_of_small_trees_sprayed),0) FROM $table WHERE farmer_uid = f.farmer_uid AND application_number = 1 AND user_uid = $userUid) AS treesSprayedInFirstApplication,
            (SELECT COALESCE(SUM(number_of_trees_sprayed),0) + COALESCE(SUM(number_of_small_trees_sprayed),0) FROM $table WHERE farmer_uid = f.farmer_uid AND application_number = 2 AND user_uid = $userUid) AS treesSprayedInSecondApplication,
            (SELECT COALESCE(SUM(number_of_trees_sprayed),0) + COALESCE(SUM(number_of_small_trees_sprayed),0) FROM $table WHERE farmer_uid = f.farmer_uid AND application_number = 3 AND user_uid = $userUid) AS treesSprayedInThirdApplication,
            (SELECT date_of_next_application FROM $table WHERE farmer_uid = f.farmer_uid AND application_number = 1 AND user_uid = $userUid ORDER BY id ASC LIMIT 1) AS dateOfSecondApplication,
            (SELECT date_of_next_application FROM $table WHERE farmer_uid = f.farmer_uid AND application_number = 2 AND user_uid = $userUid ORDER BY id ASC LIMIT 1) AS dateOfThirdApplication
          FROM farmers f WHERE user_uid = $userUid $filter
          ORDER BY f.id DESC
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

        //related attributes for plots
        numberOfTrees: maps[i]['numberOfTrees'],

        //related attributes for the chemical application
        treesSprayedInFirstApplication: maps[i]
            ['treesSprayedInFirstApplication'],
        treesSprayedInSecondApplication: maps[i]
            ['treesSprayedInSecondApplication'],
        treesSprayedInThirdApplication: maps[i]
            ['treesSprayedInThirdApplication'],
        dateOfSecondApplication:
        (maps[i]['dateOfSecondApplication'] != null) ? DateTime.fromMillisecondsSinceEpoch(maps[i]['dateOfSecondApplication']) : null,
        dateOfThirdApplication:
        (maps[i]['dateOfThirdApplication'] != null) ? DateTime.fromMillisecondsSinceEpoch(maps[i]['dateOfThirdApplication']) : null,
      );
    });
  }

  Future<int> updateApplication(Application application) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given Application.
    return await db.update(
      table,
      application.toMap(),
      // Ensure that the Application has a matching chemical_application_uid.
      where: 'chemical_application_uid = ?',
      // Pass the Application's chemical_application_uid as a whereArg to prevent SQL injection.
      whereArgs: [application.chemicalApplicationUid],
    );
  }

  Future<void> deleteApplication(int chemicalApplicationUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the Application from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific application.
      where: 'chemical_application_uid = ?',
      // Pass the Application's chemicalApplicationUid as a whereArg to prevent SQL injection.
      whereArgs: [chemicalApplicationUid],
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
          Application app = Application.fromMap(maps[i]);

          app = app.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(app.toJson());

          var response = await client.post(
            Uri.parse(
                "${Utils.api}/save/chemical_application/chemical_application_uid"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body,
          );

          print("Application from map: ${response.reasonPhrase}");
          if (response.statusCode == 200) {
            var responseText = json.decode(response.body);
            int index = i + 1;
            if (responseText["status"] == "success") {
              int value = await updateApplication(app);

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
      print("Application Model 1: ${e.toString()}");
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT chemical_application_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse(
            "${Utils.api}/fetch/chemical_application/chemical_application_uid"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: json.encode({
          "uid": maps,
          "province": user.province,
          "district": user.district,
          "administrative_post": user.administrativePost,
          "visibility": user.visibility,
        }),
      );
      
      if (response.statusCode == 200) {
        var responseText = json.decode(response.body);
        var count = responseText.length;

        if (responseText.isNotEmpty) {
          for (var i = 0; i < count; i++) {
            int index = i + 1;

            Application application = Application.fromJson(responseText[i]);

            int value = await insertApplication(application);

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
      }else {
        print("Application Model: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("Application Model 2: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
