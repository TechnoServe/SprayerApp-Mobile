// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/preparatory_activity.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class PreparatoryActivityModel {
  DatabaseBuilder database = DatabaseBuilder();
  final String table = "preparatory_activity";

  // Define a function that inserts preparatoryActivitys into the database
  Future<int> insertPreparatoryActivity(
      PreparatoryActivity preparatoryActivity) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the PreparatoryActivity into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same preparatoryActivity is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      preparatoryActivity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the preparatoryActivitys from the preparatoryActivitys table.
  Future<List<PreparatoryActivity>> preparatoryActivities(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The farmers.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT DISTINCT 
            f.first_name, 
            f.last_name, 
            py.id,
            py.preparatory_activity_uid,
            py.farmer_uid,
            py.user_uid,
            py.pruning_type,
            COALESCE(py.number_of_trees_cleaned, 0) AS number_of_trees_cleaned,
            COALESCE(py.number_of_trees_pruned, 0) AS number_of_trees_pruned,
            py.created_at,
            py.updated_at,
            py.last_sync_at,
            py.sync_status
          FROM farmers f
          LEFT JOIN $table py ON py.farmer_uid = f.farmer_uid
          WHERE py.user_uid = $userUid
          ORDER BY py.id DESC
        ''');

    // Convert the List<Map<String, dynamic> into a List<PreparatoryActivity>.
    return List.generate(maps.length, (i) {
      return PreparatoryActivity(
        id: maps[i]['id'],
        preparatoryActivityUid: maps[i]['preparatory_activity_uid'] ?? 0,
        farmerUid: maps[i]['farmer_uid'] ?? 0,
        userUid: maps[i]['user_uid'] ?? 0,
        numberOfTreesCleaned: maps[i]['number_of_trees_cleaned'],
        numberOfTreesPruned: maps[i]['number_of_trees_pruned'],
        pruningType: maps[i]['pruning_type'],
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
            (SELECT COALESCE(SUM(number_of_trees),0) FROM plots WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid) AS numberOfTrees,
            (SELECT COALESCE(SUM(number_of_trees_cleaned),0) FROM $table WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid) AS numberOfTreesCleaned,
            (SELECT COALESCE(SUM(number_of_trees_pruned),0) FROM $table WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid) AS numberOfTreesPruned
          FROM farmers f WHERE f.user_uid = $userUid
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

        //related attributes for the preparatory activity
        treesCleaned: maps[i]['numberOfTreesCleaned'],
        treesPruned: maps[i]['numberOfTreesPruned'],
      );
    });
  }

  Future<int> updatePreparatoryActivity(
      PreparatoryActivity preparatoryActivity) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given PreparatoryActivity.
    return await db.update(table, preparatoryActivity.toMap(),
        // Ensure that the PreparatoryActivity has a matching preparatory_activity_uid.
        where: 'preparatory_activity_uid = ?',
        // Pass the PreparatoryActivity's preparatory_activity_uid as a whereArg to prevent SQL injection.
        whereArgs: [preparatoryActivity.preparatoryActivityUid]);
  }

  Future<void> deletePreparatoryActivity(int preparatoryActivityUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the PreparatoryActivity from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific preparatoryActivity.
      where: 'preparatory_activity_uid = ?',
      // Pass the PreparatoryActivity's preparatoryActivityUid as a whereArg to prevent SQL injection.
      whereArgs: [preparatoryActivityUid],
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
          PreparatoryActivity preparatoryActivity =
              PreparatoryActivity.fromMap(maps[i]);

          preparatoryActivity = preparatoryActivity.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(preparatoryActivity.toJson());

          var response = await client.post(
            Uri.parse(
                "${Utils.api}/save/preparatory_activity/preparatory_activity_uid"),
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
              int value = await updatePreparatoryActivity(preparatoryActivity);

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
      SELECT preparatory_activity_uid
      FROM $table
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse(
            "${Utils.api}/fetch/preparatory_activity/preparatory_activity_uid"),
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

            PreparatoryActivity preparatoryActivity =
                PreparatoryActivity.fromJson(responseText[i]);

            int value = await insertPreparatoryActivity(preparatoryActivity);

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
      } else {
        print(
            "Preparatory Activity Model: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("Preparatory Activity Model: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
