// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:sprayer_app/entities/expenses_income.dart';
import 'package:sprayer_app/entities/user.dart';
import 'package:sprayer_app/helpers/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class ExpensesIncomeModel {
  DatabaseBuilder database = DatabaseBuilder();

  final String table = "expenses_incomes";

  // Define a function that inserts expensesIncomes into the database
  Future<int> insertExpensesIncome(ExpensesIncome expensesIncome) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Insert the ExpensesIncome into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same expensesIncome is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      table,
      expensesIncome.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the expensesIncomes from the expensesIncomes table.
  Future<List<ExpensesIncome>> expensesIncomes(int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    String filter = await Utils.getCurrentCampaignFilter(alias: "");

    // Query the table for all The expensesIncomes.
    final List<Map<String, dynamic>> maps = await db.rawQuery(''' SELECT * FROM $table WHERE user_uid = $userUid $filter''');

    // Convert the List<Map<String, dynamic> into a List<ExpensesIncome>.
    return List.generate(maps.length, (i) {
      return ExpensesIncome(
        id: maps[i]['id'],
        expensesIncomeUid: maps[i]['expenses_income_uid'],
        userUid: maps[i]['user_uid'],
        category: maps[i]['category'],
        expensesIncomeType: maps[i]['expenses_income_type'],
        paymentType: maps[i]['expenses_income_payment_type'],
        price: maps[i]['price'],
        description: maps[i]['description'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps[i]['updated_at']),
        lastSyncAt:
            DateTime.fromMillisecondsSinceEpoch(maps[i]['last_sync_at']),
        syncStatus: maps[i]['sync_status'],
      );
    });
  }

  Future<int> updateExpensesIncome(ExpensesIncome expensesIncome) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Update the given ExpensesIncome.
    return await db.update(
      table,
      expensesIncome.toMap(),
      // Ensure that the ExpensesIncome has a matching id.
      where: 'expenses_income_uid = ?',
      // Pass the ExpensesIncome's id as a whereArg to prevent SQL injection.
      whereArgs: [expensesIncome.expensesIncomeUid],
    );
  }

  Future<void> deleteExpensesIncome(int expensesIncomeUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Remove the ExpensesIncome from the database.
    await db.delete(
      table,
      // Use a `where` clause to delete a specific expensesIncome.
      where: 'expenses_income_uid = ?',
      // Pass the ExpensesIncome's id as a whereArg to prevent SQL injection.
      whereArgs: [expensesIncomeUid],
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
          ExpensesIncome expensesIncome = ExpensesIncome.fromMap(maps[i]);

          expensesIncome = expensesIncome.copyWith(
            updatedAt: DateTime.now(),
            lastSyncAt: DateTime.now(),
            syncStatus: 1,
          );

          var body = json.encode(expensesIncome.toJson());

          var response = await client.post(
            Uri.parse("${Utils.api}/save/expenses_incomes/expenses_income_uid"),
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
              int value =
                  await updateExpensesIncome(expensesIncome);

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
      print("Expenses and incomes: ${e.toString()}");
    } finally {
      client.close();
    }
  }

  Stream apiGetFromServer(User user) async* {
    final db = await database.initializeDatabase();

    var maps = await db.rawQuery('''
      SELECT expenses_income_uid
      FROM $table 
      WHERE user_uid = ${user.userUid}
      ORDER BY id DESC
    ''');

    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse("${Utils.api}/fetch/expenses_incomes/expenses_income_uid"),
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

            ExpensesIncome expensesIncome =
                ExpensesIncome.fromJson(responseText[i]);

            int value = await insertExpensesIncome(expensesIncome);

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
      print("Expenses and incomes: ${e.toString()}");
    } finally {
      client.close();
    }
  }
}
