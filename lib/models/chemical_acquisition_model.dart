// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/chemical_acquisition.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class ChemicalAcquisitionModel {
  DatabaseBuilder database = DatabaseBuilder();

  String table = "chemical_acquisition";

  // Define a function that inserts chemicalAcquisitions into the database
  Future<int> insertChemicalAcquisition(
      ChemicalAcquisition chemicalAcquisition) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the ChemicalAcquisition into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same chemicalAcquisition is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      chemicalAcquisition.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the chemicalAcquisitions from the chemicalAcquisitions table.
  Future<List<ChemicalAcquisition>> chemicalAcquisitions(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The chemicalAcquisitions.
    String filter = await Utils.getCurrentCampaignFilter(alias: "");

    // Query the table for all The expensesIncomes.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        ''' SELECT * FROM $table WHERE user_uid = $userUid $filter''');

    // Convert the List<Map<String, dynamic> into a List<ChemicalAcquisition>.
    return List.generate(maps.length, (i) {
      return ChemicalAcquisition(
        id: maps[i]['id'],
        chemicalAcquisitionUid: maps[i]['chemical_acquisition_uid'],
        userUid: maps[i]['user_uid'],
        acquisitionMode: maps[i]['chemical_acquisition_mode'],
        whereYouAcquired: maps[i]['chemical_acquisition_place'],
        supplier: maps[i]['chemical_supplier'],
        name: maps[i]['chemical_name'],
        quantity: maps[i]['chemical_quantity'] ?? 0.0,
        price: maps[i]['chemical_price'] ?? 0.0,
        acquiredAt: (maps[i]['acquired_at'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['acquired_at'])
            : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
      );
    });
  }

  Future<int> updateChemicalAcquisition(
      ChemicalAcquisition chemicalAcquisition) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given ChemicalAcquisition.
    return await db.update(
      table,
      chemicalAcquisition.toMap(),
      // Ensure that the ChemicalAcquisition has a matching id.
      where: 'chemical_acquisition_uid = ?',
      // Pass the ChemicalAcquisition's id as a whereArg to prevent SQL injection.
      whereArgs: [chemicalAcquisition.chemicalAcquisitionUid],
    );
  }

  Future<void> deleteChemicalAcquisition(int chemicalAcquisitionUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the ChemicalAcquisition from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific chemicalAcquisition.
      where: 'chemical_acquisition_uid = ?',
      // Pass the ChemicalAcquisition's id as a whereArg to prevent SQL injection.
      whereArgs: [chemicalAcquisitionUid],
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
          ChemicalAcquisition app = ChemicalAcquisition.fromMap(maps[i]);

          app = app.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(app.toJson());

          var response = await client.post(
            Uri.parse(
                "${Utils.api}/save/chemical_acquisition/chemical_acquisition_uid"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body,
          );

          if (response.statusCode == 200) {
            print(response.body);
            var responseText = json.decode(response.body);
            int index = i + 1;
            if (responseText["status"] == "success") {
              int value = await updateChemicalAcquisition(app);

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
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT chemical_acquisition_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse(
            "${Utils.api}/fetch/chemical_acquisition/chemical_acquisition_uid"),
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

            ChemicalAcquisition chemicalAcquisition =
                ChemicalAcquisition.fromJson(responseText[i]);

            int value = await insertChemicalAcquisition(chemicalAcquisition);

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
            "Chemical Acquisition Model: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("Chemical Acquisition Model: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
