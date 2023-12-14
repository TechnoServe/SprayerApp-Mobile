// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/campaign.dart';
import 'package:sprayer_app/entities/faq.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/profile.dart';
import 'package:http/http.dart' as http;

class CampaignModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "campaigns";
  final String currentCampaignTable = "current_campaign";

  // Define a function that inserts campaigns into the database
  Future<int> insertCampaign(Campaign campaign) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Profile into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same profile is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      campaign.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that inserts campaigns into the database
  Future<int> insertCurrentCampaign(Campaign campaign) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    await db.delete(currentCampaignTable);

    // Insert the Profile into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same profile is inserted twice.
    // In this case, replace any previous data.

    return await db.insert(
      currentCampaignTable,
      {
        "id": campaign.id,
        "opening": campaign.opening.millisecondsSinceEpoch,
        "closing": campaign.closing.millisecondsSinceEpoch,
        "description": campaign.description,
        "created_at": campaign.createdAt.millisecondsSinceEpoch,
        "updated_at": campaign.updatedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the campaigns from the campaigns table.
  Future<List<Campaign>> campaigns() async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The campaigns.
    final List<Map<String, dynamic>> maps =
        await db.query(table, orderBy: "id DESC");

    // Convert the List<Map<String, dynamic> into a List<Campaign>.
    return List.generate(maps.length, (i) {
      print(maps[i]);
      late Campaign campaign;
      try {
        campaign = Campaign(
          id: maps[i]['id'],
          opening: DateTime.fromMillisecondsSinceEpoch(maps[i]['opening']),
          closing: DateTime.fromMillisecondsSinceEpoch(maps[i]['closing']),
          description: maps[i]['description'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
          deletedAt: maps[i]['deleted_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(maps[i]['deleted_at'])
              : DateTime.now(),
          lastSyncAt: maps[i]['last_sync_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at'])
              : DateTime.now(),
        );
      } catch (e) {
        print(e);
      }

      print(campaign);

      return campaign;
    });
  }

  // A method that retrieves all the campaigns from the campaigns table.
  Future<Campaign> getCurrentCampaign() async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The campaigns.
    final List<Map<String, dynamic>> maps =
        await db.query(currentCampaignTable, orderBy: "id DESC", limit: 1);

    Map<String, dynamic> map = maps.isNotEmpty ? maps.first : {};

    return map.isNotEmpty
        ? Campaign(
            id: map['id'],
            opening: DateTime.fromMillisecondsSinceEpoch(map['opening']),
            closing: DateTime.fromMillisecondsSinceEpoch(map['closing']),
            description: map['description'],
            createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
          )
        : Campaign.init();
  }

  Future apiGetFromServerAsFuture() async {
    print("Campaign model called");
    final db = await database.initializeDatabase();
    var client = http.Client();

    print(client.toString());

    try {
      var response = await client.get(
        Uri.parse("${Utils.api}/campaigns"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      if (response.statusCode == 200) {
        var responseText = json.decode(response.body);
        var count = responseText["data"].length;

        if (responseText["data"].isNotEmpty) {
          await db.delete(table);

          for (var i = 0; i < count; i++) {
            Campaign campaign = Campaign.fromJson(responseText["data"][i]);
            int value = await insertCampaign(campaign);

            if (value > 0) {
              // print("Campaign successfully inserted $campaign");
            } else {
              //print("Failed to insert campaign $campaign");
            }
          }
        }
      }
    } catch (e) {
      print("Campaigns: ${e.toString()}");
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer() async* {
    print("Campaign model called");
    final db = await database.initializeDatabase();
    var client = http.Client();

    print(client.toString());

    try {
      var response = await client.get(
        Uri.parse("${Utils.api}/campaigns"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      if (response.statusCode == 200) {
        var responseText = json.decode(response.body);
        var count = responseText["data"].length;

        if (responseText["data"].isNotEmpty) {
          await db.delete(table);

          for (var i = 0; i < count; i++) {
            int index = i + 1;
            Campaign campaign = Campaign.fromJson(responseText["data"][i]);

            int value = await insertCampaign(campaign);

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
    } catch (e) {
      print("Campaigns: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
