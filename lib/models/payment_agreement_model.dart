// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/entities/payment_agreement.dart';
import 'package:http/http.dart' as http;

class PaymentAggreementModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "payments_aggreement";

  // Define a function that inserts paymentAgreements into the database
  Future<int> insertPaymentAgreement(PaymentAgreement paymentAgreement) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the PaymentAgreement into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same paymentAgreement is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      paymentAgreement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
            py.payment_aggreement_uid,
            COALESCE(py.aggreed_payment, 0.0) AS aggreed_payment,
            COALESCE(py.aggreed_payment_per_small_trees, 0.0) AS aggreed_payment_per_small_trees,
            COALESCE(py.aggreed_trees_to_spray, 0) AS aggreed_trees_to_spray,
            COALESCE(py.aggreed_trees_small_to_spray, 0) AS aggreed_trees_small_to_spray,
            COALESCE(py.number_of_applications, 0) AS number_of_applications,
            py.payment_type,
            (SELECT COALESCE(SUM(number_of_trees),0) FROM plots WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid) AS number_of_trees
          FROM farmers f
          LEFT JOIN $table py ON py.farmer_uid = f.farmer_uid
          WHERE f.user_uid = $userUid $filter
          ORDER BY f.id DESC
        ''').catchError((e) {
      print(e);
    });

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
        numberOfTrees: maps[i]["number_of_trees"],

        //related attributes for payment aggreement
        paymentAgreementUid: maps[i]["payment_aggreement_uid"],
        aggredPayment: maps[i]["aggreed_payment"],
        aggreedPaymentPerSmallTrees: double.tryParse(maps[i]["aggreed_payment_per_small_trees"].toString()) ?? 0,
        aggredTrees: maps[i]["aggreed_trees_to_spray"],
        aggredSmallTrees: maps[i]["aggreed_trees_small_to_spray"] ?? 0,
        paymentType: maps[i]["payment_type"],
        numberOfApplications: maps[i]["number_of_applications"],
      );
    });
  }

  Future<int> updatePaymentAgreement(PaymentAgreement paymentAgreement) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given PaymentAgreement.
    return await db.update(
      table,
      paymentAgreement.toMap(),
      // Ensure that the PaymentAgreement has a matching paymentAgreementUid.
      where: 'payment_aggreement_uid = ?',
      // Pass the PaymentAgreement's paymentAgreementUid as a whereArg to prevent SQL injection.
      whereArgs: [paymentAgreement.paymentAgreementUid],
    );
  }

  Future<void> deletePaymentAgreement(int paymentAgreementUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the PaymentAgreement from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific paymentAgreement.
      where: 'payment_aggreement_uid = ?',
      // Pass the PaymentAgreement's paymentAgreementUid as a whereArg to prevent SQL injection.
      whereArgs: [paymentAgreementUid],
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
          PaymentAgreement paymentAgreement = PaymentAgreement.fromMap(maps[i]);

          paymentAgreement = paymentAgreement.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(paymentAgreement.toJson());

          var response = await client.post(
            Uri.parse(
                "${Utils.api}/save/payments_aggreement/payment_aggreement_uid"),
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
              int value = await updatePaymentAgreement(paymentAgreement);

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
      print("Payment agreement: ${e.toString()}");
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT payment_aggreement_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse(
            "${Utils.api}/fetch/payments_aggreement/payment_aggreement_uid"),
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

            PaymentAgreement paymentAgreement =
                PaymentAgreement.fromJson(responseText[i]);

            int value = await insertPaymentAgreement(paymentAgreement);

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
      print("Payment agreement: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
