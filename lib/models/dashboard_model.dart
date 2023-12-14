import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sprayer_app/database/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprayer_app/helpers/utils.dart';

class DashboardModel {
  DatabaseBuilder database = DatabaseBuilder();

  // A method that retrieves all the dashboard from the dashboard table.
  Future<List<Map<String, dynamic>>> dashboard(
      BuildContext context, int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();
    var language = AppLocalizations.of(context)!;

    String filterForFarmer = await Utils.getCurrentCampaignFilter(alias: "f");
    String filter = await Utils.getCurrentCampaignFilter(alias: "");

    /*
    (SELECT COALESCE(SUM(number_of_trees_cleaned),0) FROM preparatory_activity WHERE user_uid = $userUid $filter) AS numberOfTreesCleaned,
    (SELECT COALESCE(SUM(number_of_trees_pruned),0) FROM preparatory_activity WHERE user_uid = $userUid $filter) AS numberOfTreesPruned,
     */

    // Query the table for all The dashboard.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT DISTINCT
            COALESCE(COUNT(*),0) AS registeredFarmers,
            (SELECT COUNT(DISTINCT farmer_uid) FROM chemical_application WHERE user_uid = $userUid $filter) AS assistedFarmers,
            (SELECT COALESCE(COUNT(*),0) FROM plots WHERE user_uid = $userUid $filter) AS numberOfPlots,
            (SELECT COALESCE(SUM(number_of_trees),0) + COALESCE(SUM(number_of_small_trees),0) FROM plots WHERE user_uid = $userUid $filter) AS numberOfTrees
          FROM farmers f WHERE f.user_uid = $userUid $filterForFarmer
        ''');

    // Convert the List<Map<String, dynamic>.
    return List.generate(maps.length, (i) {
      return {
        language.general_registered_trees_message: maps[i]["numberOfTrees"],
        language.general_registered_farmers_message: maps[i]
            ["registeredFarmers"],
        language.general_assisted_farmers_message: maps[i]["assistedFarmers"],
        language.general_registered_plantation_message: maps[i]
            ["numberOfPlots"],
      };
    });
  }

  Future<double> totalSprayedTreesPerApplication(
      int applicationNumber, int userUid) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    String filter = await Utils.getCurrentCampaignFilter(alias: "");

    // Query the table for all The dashboard.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT 
          COALESCE(SUM(number_of_trees_sprayed),0) AS number_of_trees_sprayed,
          COALESCE(SUM(number_of_small_trees_sprayed),0) AS number_of_small_trees_sprayed
          FROM chemical_application WHERE user_uid = $userUid $filter GROUP BY application_number HAVING application_number = $applicationNumber
        ''');

    final double value = maps.fold(
        0,
        (previousValue, element) =>
            previousValue +
            element["number_of_trees_sprayed"] +
            element["number_of_small_trees_sprayed"]);

    return value;
  }

  Future<List<Map<String, dynamic>>> totalSprayedTrees(String condition) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The dashboard.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT 
            COALESCE(SUM(number_of_trees_sprayed),0) AS number_of_trees_sprayed,
            COALESCE(SUM(number_of_small_trees_sprayed),0) AS number_of_small_trees_sprayed,
            application_number
          FROM chemical_application $condition GROUP BY application_number
        ''');

    // Convert the List<Map<String, dynamic>.
    return List.generate(maps.length, (i) => maps[i]);
  }

  // A method that retrieves all the dashboard from the dashboard table.
  Future<List<Map<String, dynamic>>> expensesIncomes(
      String filter, String condition) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The dashboard.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT 
            CASE WHEN expenses_income_payment_type = 'Kg' THEN COALESCE(SUM(price * 37),0) ELSE SUM(price) END AS price,
            expenses_income_type
          FROM expenses_incomes
          $condition
          GROUP BY expenses_income_type, expenses_income_payment_type
          HAVING expenses_income_type = '$filter'
        ''');
    // Convert the List<Map<String, dynamic>.
    return List.generate(maps.length, (i) => maps[i]);
  }

  // A method that retrieves all the dashboard from the dashboard table.
  Future<List<Map<String, dynamic>>> profit(String condition) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The dashboard.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT 
            CASE WHEN payment_type = 'Kg' THEN COALESCE(SUM((paid - discount) * 37),0) ELSE SUM((paid - discount)) END AS profit
          FROM payments
          $condition
          GROUP BY user_uid, payment_type
        ''');

    // Convert the List<Map<String, dynamic>.
    return List.generate(maps.length, (i) => maps[i]);
  }

  // A method that retrieves all the dashboard from the dashboard table.
  Future<List<Map<String, dynamic>>> chemicalAcquisitionExpense(
      String condition) async {
    // Get a reference to the database.
    final db = await database.initializeDatabase();

    // Query the table for all The dashboard.
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
          SELECT 
            COALESCE(SUM(chemical_price), 0) AS chemicalAcquisitionExpense
          FROM chemical_acquisition
          $condition
        ''');

    // Convert the List<Map<String, dynamic>.
    return List.generate(maps.length, (i) => maps[i]);
  }

  Future<double> totalIncomes(BuildContext context, String condition) async {
    var language = AppLocalizations.of(context)!;
    var expensesIncomesOverview = await expensesIncomes(
        language.form_field_income_input_value, condition);
    var profitsOverview = await profit(condition);

    double expensesIncomesOverviewValue =
        expensesIncomesOverview.fold<double>(0, (previousValue, element) {
      return previousValue + element["price"];
    });

    double profitsOverviewValue =
        profitsOverview.fold<double>(0, (previousValue, element) {
      return previousValue + element["profit"];
    });

    return expensesIncomesOverviewValue + profitsOverviewValue;
  }

  Future<double> totalExpenses(BuildContext context, String condition) async {
    var language = AppLocalizations.of(context)!;
    var expensesIncomesOverview = await expensesIncomes(
        language.form_field_expense_input_value, condition);
    var chemicalAcquisitionOverview =
        await chemicalAcquisitionExpense(condition);

    double expensesIncomesOverviewValue =
        expensesIncomesOverview.fold<double>(0, (previousValue, element) {
      return previousValue + element["price"];
    });

    double chemicalAcquisitionOverviewValue =
        chemicalAcquisitionOverview.fold<double>(0, (previousValue, element) {
      return previousValue + element["chemicalAcquisitionExpense"];
    });

    return expensesIncomesOverviewValue + chemicalAcquisitionOverviewValue;
  }

  Future<double> profitPerTree(BuildContext context, String condition) async {
    double expensesIncomesOverviewValue =
        await totalIncomes(context, condition);

    var treeOverview = await totalSprayedTrees(condition);

    double treeOverviewValue =
        treeOverview.fold<double>(0, (previousValue, element) {
      return previousValue + element["number_of_trees_sprayed"] + element["number_of_small_trees_sprayed"];
    });

    return expensesIncomesOverviewValue /
        (treeOverviewValue == 0 ? 1 : treeOverviewValue);
  }

  Future<double> costPerTree(BuildContext context, String condition) async {
    double expensesIncomesOverviewValue =
        await totalExpenses(context, condition);

    var treeOverview = await totalSprayedTrees(condition);

    double treeOverviewValue =
        treeOverview.fold<double>(0, (previousValue, element) {
      return previousValue + element["number_of_trees_sprayed"] + element["number_of_small_trees_sprayed"];
    });

    return expensesIncomesOverviewValue /
        (treeOverviewValue == 0 ? 1 : treeOverviewValue);
  }
}
