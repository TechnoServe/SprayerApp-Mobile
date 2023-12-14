// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/faq.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/profile.dart';
import 'package:http/http.dart' as http;

class FAQModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "faqs";

  // Define a function that inserts profiles into the database
  Future<int> insertFAQ(FAQ faq) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Profile into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same profile is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      faq.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the profiles from the profiles table.
  Future<List<FAQ>> faqs() async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps =
        await db.query(table, orderBy: "id DESC");

    // Convert the List<Map<String, dynamic> into a List<Profile>.
    return List.generate(maps.length, (i) {
      return FAQ(
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }

  Stream apiGetFromServer() async* {
    print("FAQ model called");
    final db = await database.initializeDatabase();
    var client = http.Client();

    print(client.toString());

    try {
      var response = await client.get(
        Uri.parse("${Utils.api}/faqs"),
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
            FAQ faq = FAQ.fromJson(responseText["data"][i]);
            int value = await insertFAQ(faq);

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
      print("FAQs: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
