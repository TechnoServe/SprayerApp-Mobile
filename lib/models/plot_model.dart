// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/plot.dart';
import 'package:http/http.dart' as http;

class PlotModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "plots";

  // Define a function that inserts plots into the database
  Future<int> insertPlot(Plot plot) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Plot into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same plot is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      plot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the plots from the plots table.
  Future<List<Plot>> plots(int farmerUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Query the table for all The plots.
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: 'farmer_uid = ? ', whereArgs: [farmerUid, ], orderBy: "id DESC");

    // Convert the List<Map<String, dynamic> into a List<Plot>.
    return List.generate(maps.length, (i) {
      return Plot(
        id: maps[i]['id'],
        plotUid: maps[i]['plot_uid'],
        farmerUid: maps[i]['farmer_uid'],
        userUid: maps[i]['user_uid'],
        name: maps[i]['name'],
        numberOfTrees: maps[i]['number_of_trees'],
        numberOfSmallTrees: maps[i]['number_of_small_trees'],
        plotType: maps[i]['plot_type'],
        plotAge: maps[i]['plot_age'],
        otherCrop: maps[i]['other_crop'],
        declaredArea: maps[i]['declared_area'],
        province: maps[i]['province'],
        district: maps[i]['district'],
        administrativePost: maps[i]['administrative_post'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
      );
    });
  }

  Future<int> updatePlot(Plot plot) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given Plot.
    return await db.update(
      table,
      plot.toMap(),
      // Ensure that the Plot has a matching plot_uid.
      where: 'plot_uid = ?',
      // Pass the Plot's plotUid as a whereArg to prevent SQL injection.
      whereArgs: [plot.plotUid],
    );
  }

  Future<int> deletePlot(int plotUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the Plot from the database.
    return await db.delete(
      table,
      // Use a `where` clause to delete a specific plot.
      where: 'plot_uid = ?',
      // Pass the Plot's plotUid as a whereArg to prevent SQL injection.
      whereArgs: [plotUid],
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
          Plot plot = Plot.fromMap(maps[i]);

          plot = plot.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(plot.toJson());

          var response = await client.post(
            Uri.parse("${Utils.api}/save/plots/plot_uid"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body,
          );

          print(response.body);

          if (response.statusCode == 200) {
            var responseText = json.decode(response.body);
            int index = i + 1;
            if (responseText["status"] == "success") {
              int value = await updatePlot(plot);

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
      SELECT plot_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse("${Utils.api}/fetch/plots/plot_uid"),
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

            Plot plot = Plot.fromJson(responseText[i]);

            int value = await insertPlot(plot);

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
        print("Plots: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("Plots: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
