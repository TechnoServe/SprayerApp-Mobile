// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/farmer.dart';
import 'package:sprayer_app/entities/payment.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class PaymentModel {
  DatabaseBuilder database = DatabaseBuilder();
  final String table = "payments";

  // Define a function that inserts application into the database
  Future<int> insertPayment(Payment application) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the Payment into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same application is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      application.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the application from the application table.
  Future<List<Payment>> payments(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The chemicalPayment.
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: "user_id = ?", whereArgs: [userUid], orderBy: "id DESC");

    // Convert the List<Map<String, dynamic> into a List<Payment>.
    return List.generate(maps.length, (i) {
      return Payment(
        id: maps[i]['id'],
        paymentUid: maps[i]['payment_uid'],
        userUid: maps[i]['user_uid'],
        farmerUid: maps[i]['farmer_uid'],
        paid: maps[i]['paid'],
        discount: maps[i]['discount'],
        description: maps[i]['description'],
        paymentType: maps[i]['payment_type'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
      );
    });
  }

  // A method that retrieves all the farmers from the farmers table.
  Future<List<Farmer>> farmers(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    String filterForFarmer = await Utils.getCurrentCampaignFilter(alias: "f");
    String filter = await Utils.getCurrentCampaignFilter(alias: "");

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
            COALESCE((SELECT SUM(number_of_trees) + COALESCE(SUM(number_of_small_trees),0) FROM plots WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid $filter), 0) AS numberOfTrees,
            COALESCE((SELECT aggreed_payment FROM payments_aggreement WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid $filter), 0.0) AS aggreed_payment,
            COALESCE((SELECT COALESCE(aggreed_trees_to_spray, 0) +  COALESCE(aggreed_trees_small_to_spray,0) FROM payments_aggreement WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid $filter), 0) AS aggreed_trees_to_spray,
            COALESCE((SELECT number_of_applications FROM payments_aggreement WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid $filter), 0) AS number_of_applications,
            (SELECT payment_type FROM payments_aggreement WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid $filter) AS payment_type,
            COALESCE((SELECT SUM(paid) FROM payments WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid $filter), 0.0) AS total_paid,
            COALESCE((SELECT SUM(discount) FROM payments WHERE farmer_uid = f.farmer_uid AND user_uid = $userUid $filter), 0.0) AS discount,
            COALESCE((SELECT SUM(number_of_trees_sprayed) + COALESCE(SUM(number_of_small_trees_sprayed),0) FROM chemical_application WHERE farmer_uid = f.farmer_uid AND application_number = 1 AND user_uid = $userUid $filter), 0) AS treesSprayedInFirstApplication,
            COALESCE((SELECT SUM(number_of_trees_sprayed) + COALESCE(SUM(number_of_small_trees_sprayed),0) FROM chemical_application WHERE farmer_uid = f.farmer_uid AND application_number = 2 AND user_uid = $userUid $filter), 0) AS treesSprayedInSecondApplication,
            COALESCE((SELECT SUM(number_of_trees_sprayed) + COALESCE(SUM(number_of_small_trees_sprayed),0) FROM chemical_application WHERE farmer_uid = f.farmer_uid AND application_number = 3 AND user_uid = $userUid $filter), 0) AS treesSprayedInThirdApplication
          FROM farmers f WHERE f.farmer_uid IN(SELECT farmer_uid FROM chemical_application) AND user_uid = $userUid $filterForFarmer
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

        //related attributes for payment agreement
        aggredPayment: maps[i]['aggreed_payment'],
        aggredTrees: maps[i]['aggreed_trees_to_spray'],
        numberOfApplications: maps[i]['number_of_applications'],
        paymentType: maps[i]['payment_type'],

        //related attributes for payment
        totalPaid: maps[i]['total_paid'],
        discount: maps[i]["discount"],
        paymentUid: maps[i]['payment_uid'],
      );
    });
  }

  Future<int> updatePayment(Payment payment) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given Payment.
    return await db.update(
      table,
      payment.toMap(),
      // Ensure that the Payment has a matching paymentUid.
      where: 'payment_uid = ?',
      // Pass the Payment's paymentUid as a whereArg to prevent SQL injection.
      whereArgs: [payment.paymentUid],
    );
  }

  Future<void> deletePayment(int paymentUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the Payment from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific application.
      where: 'payment_uid = ?',
      // Pass the Payment's paymentUid as a whereArg to prevent SQL injection.
      whereArgs: [paymentUid],
    );
  }

  Future<Map<String, dynamic>> dashboard(int userUid) async {
    List<Farmer> result = await farmers(userUid);
    double dashboardTotalPaid = 0.0;
    double dashbarrdTotalDebit = 0.0;

    for (int index = 0; index < result.length; index++) {
      int numberOfApplication = result[index].numberOfApplications ?? 0;

      double agreedPaymentPerTreesInEachApplication = 0.0, toPay = 0.0, debit = 0.0;

      double totalPaid = result[index].totalPaid ?? 0.0;
      double discount = result[index].discount ?? 0.0;
      totalPaid = totalPaid.roundToDouble();

      if (numberOfApplication > 0) {
        agreedPaymentPerTreesInEachApplication =
            result[index].aggredPayment! / numberOfApplication;

        int fisrtApplication =
            result[index].treesSprayedInFirstApplication ?? 0;
        int secondApplication =
            result[index].treesSprayedInSecondApplication ?? 0;
        int thirdApplication =
            result[index].treesSprayedInThirdApplication ?? 0;

        toPay = ((fisrtApplication + secondApplication + thirdApplication) *
                agreedPaymentPerTreesInEachApplication)
            .roundToDouble();

        debit = (toPay - totalPaid - discount).roundToDouble();

        dashboardTotalPaid += totalPaid;
        dashbarrdTotalDebit += debit;
      }
    }

    return {
      "dashboardTotalPaid": dashboardTotalPaid,
      "dashbarrdTotalDebit": dashbarrdTotalDebit
    };
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
          Payment payment = Payment.fromMap(maps[i]);

          payment = payment.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(payment.toJson());

          var response = await client.post(
            Uri.parse("${Utils.api}/save/payments/payment_uid"),
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
              int value = await updatePayment(payment);

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
      SELECT payment_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse("${Utils.api}/fetch/payments/payment_uid"),
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

      print("Payment From server: ${response.body}");

      if (response.statusCode == 200) {
        var responseText = json.decode(response.body);
        var count = responseText.length;

        if (responseText.isNotEmpty) {
          for (var i = 0; i < count; i++) {
            int index = i + 1;

            Payment payment = Payment.fromJson(responseText[i]);

            int value = await insertPayment(payment);

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
            "Payment Model: ${response.reasonPhrase} ${response.statusCode}, uri: ${response.request}");
      }
    } catch (e) {
      print("Payment Model: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
