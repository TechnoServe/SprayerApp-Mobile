// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/event.dart';
import 'package:http/http.dart' as http;

class EventModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "events";

  // Define a function that inserts profiles into the database
  Future<int> insertEvent(Event event) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Event into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Event is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that inserts profiles into the database
  Future<int> updateEvent(Event event) async {
    print(event);
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Event into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Event is inserted twice.
    // In this case, replace any previous data.
    return await db.update(
      table,
      event.toMap(),
      where: "event_uid = ?",
      whereArgs: [event.eventUid],
    );
  }

  // Define a function that inserts profiles into the database
  Future<int> insertParticipantEvent(Map<String, dynamic> map) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();
    //await deleteFarmer(map["event_uid"]);
    // Insert the Event into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Event is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      "events_farmers",
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> numberOfFarmersAndTreesToAssist() async {
    final db = await database.initializeDatabase();
    int fromDate = DateTime.now().millisecondsSinceEpoch;
    int toDate = DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;
    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT
        (SELECT COUNT(*) FROM events_farmers WHERE event_uid = e.event_uid) AS number_of_participants,
        (SELECT COALESCE(SUM(number_of_trees),0) + COALESCE(SUM(number_of_small_trees),0) FROM plots WHERE farmer_uid IN(SELECT farmer_uid FROM events_farmers WHERE event_uid = e.event_uid)) AS number_of_trees
        FROM $table e WHERE e.from_date > $fromDate AND e.to_date < $toDate ORDER BY id DESC''');

    return maps.isNotEmpty ? maps.first : {};
  }

  Future<int> getNumberOfParticipants() async {
    Map<String, dynamic> result = await numberOfFarmersAndTreesToAssist();

    return result.isNotEmpty ? result["number_of_participants"] : 0;
  }

  Future<int> getNumberOfTreesToAssist() async {
    Map<String, dynamic> result = await numberOfFarmersAndTreesToAssist();

    return result.isNotEmpty ? result["number_of_trees"] : 0;
  }

  // A method that retrieves all the profiles from the profiles table.
  Future<List<Event>> events(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    String filter = await Utils.getCurrentCampaignFilter(alias: "e");

    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''SELECT e.id, 
        e.event, 
        e.event_type, 
        e.event_uid, 
        e.user_uid, 
        e.from_date, 
        e.to_date, 
        e.created_at, 
        e.updated_at, 
        e.last_sync_at, 
        e.sync_status, 
        (SELECT COUNT(*) FROM events_farmers WHERE event_uid = e.event_uid) AS number_of_participants,
        (SELECT COALESCE(SUM(number_of_trees),0) + COALESCE(SUM(number_of_small_trees),0) FROM plots WHERE farmer_uid IN(SELECT farmer_uid FROM events_farmers WHERE event_uid = e.event_uid)) AS number_of_trees
        FROM $table e WHERE e.user_uid = $userUid $filter ORDER BY id DESC''');

    // Convert the List<Map<String, dynamic> into a List<Event>.
    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        name: maps[i]['event'],
        eventType: maps[i]['event_type'],
        eventUid: maps[i]['event_uid'],
        userUid: maps[i]['user_uid'],
        fromDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['from_date']),
        toDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['to_date']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
        numberOfParticipants: maps[i]['number_of_participants'],
        numberOfTress: maps[i]['number_of_trees'],
      );
    });
  }

  // A method that retrieves all the farmers from the farmers table.
  Future<List<Farmer>> farmers(int eventUid) async {
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
            (SELECT COALESCE(COUNT(*),0) FROM plots WHERE farmer_uid = f.farmer_uid) AS numberOfPlots,
            (SELECT COALESCE(SUM(number_of_trees),0) + COALESCE(SUM(number_of_small_trees),0) FROM plots WHERE farmer_uid = f.farmer_uid) AS numberOfTrees
          FROM farmers f WHERE f.farmer_uid IN(SELECT farmer_uid FROM events_farmers WHERE event_uid = $eventUid)
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

        //related attributes
        numberOfPlots: maps[i]['numberOfPlots'],
        numberOfTrees: maps[i]['numberOfTrees'],
      );
    });
  }

  // A method that retrieves all the profiles from the profiles table.
  Future<List<Event>> findEventByEventUid(int eventUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''SELECT e.id, 
        e.event, 
        e.event_type, 
        e.event_uid, 
        e.user_uid, 
        e.from_date, 
        e.to_date, 
        e.created_at, 
        e.updated_at, 
        e.last_sync_at, 
        e.sync_status, 
        (SELECT COUNT(*) FROM events_farmers WHERE event_uid = e.event_uid) AS number_of_participants
        FROM $table e WHERE event_uid = $eventUid''');

    // Convert the List<Map<String, dynamic> into a List<Event>.
    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        name: maps[i]['event'],
        eventType: maps[i]['event_type'],
        eventUid: maps[i]['event_uid'],
        userUid: maps[i]['user_uid'],
        fromDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['from_date']),
        toDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['to_date']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
        numberOfParticipants: maps[i]['number_of_participants'],
      );
    });
  }

  // A method that retrieves all the profiles from the profiles table.
  Future<List<Farmer>> participantsInEvent(int eventUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT a.* FROM farmers a INNER JOIN events_farmers b a.farmer_uid = b.farmer_uid WHERE b.event_uid =  $eventUid");

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

        //related attributes
        numberOfPlots: maps[i]['numberOfPlots'],
        numberOfTrees: maps[i]['numberOfTrees'],
      );
    });
  }

  Future<int> deleteFarmer(int eventUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();
    // Remove the Farmer from the database.
    return await db.delete(
      "events_farmers",
      // Use a `where` clause to delete a specific farmer.
      where: 'event_uid = ?',
      // Pass the Farmer's farmer_uid as a whereArg to prevent SQL injection.
      whereArgs: [eventUid],
    );
  }

  // A method that retrieves all the profiles from the profiles table.
  Future<Event> eventByEventType(String eventType, int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The profiles.
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: "event_type = ? AND user_uid = ?",
        whereArgs: [eventType, userUid]);

    var data = maps.first;

    // Convert the List<Map<String, dynamic> into a List<Event>.
    return Event(
      id: data['id'],
      name: data['event'],
      eventType: data['event_type'],
      eventUid: data['event_uid'],
      userUid: data['user_uid'],
      fromDate: data['from_date'],
      toDate: data['to_date'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updated_at']),
      lastSyncAt: DateTime.fromMillisecondsSinceEpoch(data['last_sync_at']),
      syncStatus: data['sync_status'],
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
          Event event = Event.fromMap(maps[i]);
          event = event.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(event.toJson());

          var response = await client.post(
            Uri.parse("${Utils.api}/save/events/event_uid"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body,
          );

          print("Response Event Model: ${response.reasonPhrase}");

          if (response.statusCode == 200) {
            var responseText = json.decode(response.body);
            int index = i + 1;
            if (responseText["status"] == "success") {
              int value = await updateEvent(event);

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
      print("events: ${e.toString()}");
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT event_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse("${Utils.api}/fetch/events/event_uid"),
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
              Event event = Event.fromJson(responseText[i]);
              int value = await insertEvent(event);

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
            "events: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("events: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
