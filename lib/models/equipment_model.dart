// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/equipment.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class EquipmentModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "equipments";

  // Define a function that inserts equipments into the database
  Future<int> insertEquipment(Equipment equipment) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Equipment into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same equipment is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      equipment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the equipments from the equipments table.
  Future<List<Equipment>> equipments(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The equipments.
    String filter = await Utils.getCurrentCampaignFilter(alias: "");

    // Query the table for all The expensesIncomes.
    final List<Map<String, dynamic>> maps = await db.rawQuery(''' SELECT * FROM $table WHERE user_uid = $userUid $filter''');

    // Convert the List<Map<String, dynamic> into a List<Equipment>.
    return List.generate(maps.length, (i) {
      return Equipment(
        id: maps[i]['id'],
        equipmentUid: maps[i]['equipments_uid'],
        userUid: maps[i]['user_uid'],
        name: maps[i]['name'],
        model: maps[i]['model'],
        brand: maps[i]['brand'],
        status: maps[i]['status'],
        buyedYear: maps[i]['buyed_year'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
      );
    });
  }

  Future<int> updateEquipment(Equipment equipment) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given Equipment.
    return await db.update(
      table,
      equipment.toMap(),
      // Ensure that the Equipment has a matching id.
      where: 'equipments_uid = ?',
      // Pass the Equipment's id as a whereArg to prevent SQL injection.
      whereArgs: [equipment.equipmentUid],
    );
  }

  Future<void> deleteEquipment(int equipmentUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the Equipment from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific equipment.
      where: 'equipments_uid = ?',
      // Pass the Equipment's id as a whereArg to prevent SQL injection.
      whereArgs: [equipmentUid],
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
          Equipment equipment = Equipment.fromMap(maps[i]);

          equipment = equipment.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(equipment.toJson());

          var response = await client.post(
            Uri.parse("${Utils.api}/save/equipments/equipments_uid"),
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
              int value = await updateEquipment(equipment);

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
      print("equipment: ${e.toString()}");
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT equipments_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse("${Utils.api}/fetch/equipments/equipments_uid"),
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

            Equipment equipment = Equipment.fromJson(responseText[i]);

            int value = await insertEquipment(equipment);

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
        print("Equipment Model From Server: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("Equipment Model From Server: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
