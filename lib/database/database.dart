// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprayer_app/helpers/utils.dart';

class DatabaseBuilder {
  //farmers
  String farmersTable = "farmers";
  String farmersId = 'id';
  String farmersUid = "farmer_uid";
  String farmersUserUid = 'user_uid';
  String farmersFirstName = 'first_name';
  String farmersLastName = 'last_name';
  String farmersProvince = "province";
  String farmersDistrict = 'district';
  String farmersAdministrativePost = 'administrative_post';
  String farmersLocality = 'locality';
  String farmersMobileNumber = 'mobile_number';
  String farmersEmail = 'email';
  String farmersBirthDate = 'birth_date';
  String farmersBirthYear = 'birth_year';
  String farmersGender = 'gender';
  String farmersCreatedAt = "created_at";
  String farmersUpdatedAt = "updated_at";
  String farmersLastSyncAt = "last_sync_at";
  String farmersSyncStatus = "sync_status";
  String farmersStatus = "status";

  //plots
  String plotsTable = "plots";
  String plotsId = 'id';
  String plotsUid = "plot_uid";
  String plotsFarmerUid = "farmer_uid";
  String plotsUserUid = 'user_uid';
  String plotsName = 'name';
  String plotsNumberOfTrees = 'number_of_trees';
  String plotsNumberOfSmallTrees = 'number_of_small_trees';
  String plotsDeclaredArea = 'declared_area';
  String plotsPlotType = 'plot_type';
  String plotsPlotAge = 'plot_age';
  String plotsOtherCrop = 'other_crop';
  String plotsProvince = "province";
  String plotsDistrict = 'district';
  String plotsAdministrativePost = 'administrative_post';
  String plotsCreatedAt = "created_at";
  String plotsUpdatedAt = "updated_at";
  String plotsLastSyncAt = "last_sync_at";
  String plotsSyncStatus = "sync_status";

  //chemical acquisition
  String chemicalAcquisitionTable = "chemical_acquisition";
  String chemicalAcquisitionId = 'id';
  String chemicalAcquisitionUid = 'chemical_acquisition_uid';
  String chemicalAcquisitionUserUid = 'user_uid';
  String chemicalAcquisitionChemicalAcquisitionMode =
      'chemical_acquisition_mode';
  String chemicalAcquisitionChemicalAcquisitionPlace =
      'chemical_acquisition_place';
  String chemicalAcquisitionChemicalSupplier = 'chemical_supplier';
  String chemicalAcquisitionChemicalName = 'chemical_name';
  String chemicalAcquisitionChemicalQuantity = 'chemical_quantity';
  String chemicalAcquisitionChemicalPrice = 'chemical_price';
  String chemicalAcquisitionAcquiredAt = "acquired_at";
  String chemicalAcquisitionCreatedAt = "created_at";
  String chemicalAcquisitionUpdatedAt = "updated_at";
  String chemicalAcquisitionLastSyncAt = "last_sync_at";
  String chemicalAcquisitionSyncStatus = "sync_status";

//payment aggreement
  String paymentAggreementTable = "payments_aggreement";
  String paymentAggreementId = 'id';
  String paymentAggreementUid = 'payment_aggreement_uid';
  String paymentAggreementFarmerUid = "farmer_uid";
  String paymentAggreementUserUid = 'user_uid';
  String paymentAggreementAggreedPayment = 'aggreed_payment';
  String paymentAggreementAggreedPaymentPerSmallTrees = 'aggreed_payment_per_small_trees';
  String paymentAggreementAggreedTreesToSpray = 'aggreed_trees_to_spray';
  String paymentAggreementAggreedTreesSmallToSpray = 'aggreed_trees_small_to_spray';
  String paymentAggreementPaymentType = 'payment_type';
  String paymentAggreementNumberOfApplications = 'number_of_applications';
  String paymentAggreementCreatedAt = "created_at";
  String paymentAggreementUpdatedAt = "updated_at";
  String paymentAggreementLastSyncAt = "last_sync_at";
  String paymentAggreementSyncStatus = "sync_status";

//payments
  String paymentTable = "payments";
  String paymentId = 'id';
  String paymentUid = 'payment_uid';
  String paymentFarmerUid = "farmer_uid";
  String paymentUserUid = 'user_uid';
  String paymentPaid = 'paid';
  String paymentDiscount = 'discount';
  String paymentDescription = 'description';
  String paymentType = 'payment_type';
  String paymentCreatedAt = "created_at";
  String paymentUpdatedAt = "updated_at";
  String paymentLastSyncAt = "last_sync_at";
  String paymentSyncStatus = "sync_status";

//payments
  String expensesAndIncomeTable = "expenses_incomes";
  String expensesAndIncomeId = 'id';
  String expensesAndIncomeUid = 'expenses_income_uid';
  String expensesAndIncomeUserUid = 'user_uid';
  String expensesAndIncomeCategory = 'category';
  String expensesAndIncomePrice = 'price';
  String expensesAndIncomeDescription = 'description';
  String expensesAndIncomeType = 'expenses_income_type';
  String expensesAndIncomePaymentType = 'expenses_income_payment_type';
  String expensesAndIncomeCreatedAt = "created_at";
  String expensesAndIncomeUpdatedAt = "updated_at";
  String expensesAndIncomeLastSyncAt = "last_sync_at";
  String expensesAndIncomeSyncStatus = "sync_status";

//preparatory activity
  String preparatoryActivityTable = "preparatory_activity";
  String preparatoryActivityId = 'id';
  String preparatoryActivityUid = 'preparatory_activity_uid';
  String preparatoryActivityFarmerUid = "farmer_uid";
  String preparatoryActivityUserUid = 'user_uid';
  String preparatoryActivityNumberOfTreesPruned = 'number_of_trees_pruned';
  String preparatoryActivityNumberOfTreesCleaned = 'number_of_trees_cleaned';
  String preparatoryActivityPruningType = 'pruning_type';
  String preparatoryActivityCreatedAt = "created_at";
  String preparatoryActivityUpdatedAt = "updated_at";
  String preparatoryActivityLastSyncAt = "last_sync_at";
  String preparatoryActivitySyncStatus = "sync_status";

  //chemical application
  String chemicalApplicationTable = "chemical_application";
  String chemicalApplicationId = 'id';
  String chemicalApplicationUid = 'chemical_application_uid';
  String chemicalApplicationFarmerUid = "farmer_uid";
  String chemicalApplicationUserUid = 'user_uid';
  String chemicalApplicationNumberOfTreesSprayed = 'number_of_trees_sprayed';
  String chemicalApplicationNumberOfSmallTreesSprayed = 'number_of_small_trees_sprayed';
  String chemicalApplicationNumber = 'application_number';
  String chemicalApplicationNextApplication = 'date_of_next_application';
  String chemicalApplicationSprayedAt = "sprayed_at";
  String chemicalApplicationCreatedAt = "created_at";
  String chemicalApplicationUpdatedAt = "updated_at";
  String chemicalApplicationLastSyncAt = "last_sync_at";
  String chemicalApplicationSyncStatus = "sync_status";

  //payments
  String equipmentsTable = "equipments";
  String equipmentsId = 'id';
  String equipmentsUid = 'equipments_uid';
  String equipmentsUserUid = 'user_uid';
  String equipmentsName = 'name';
  String equipmentsModel = 'model';
  String equipmentsBrand = 'brand';
  String equipmentsStatus = 'status';
  String equipmentsBuyedYear = 'buyed_year';
  String equipmentsCreatedAt = "created_at";
  String equipmentsUpdatedAt = "updated_at";
  String equipmentsLastSyncAt = "last_sync_at";
  String equipmentsSyncStatus = "sync_status";

  //users
  String usersTable = "users";
  String usersId = 'id';
  String usersUid = "user_uid";
  String usersFirstName = 'first_name';
  String usersLastName = 'last_name';
  String usersEmail = 'email';
  String usersMobileNumber = 'mobile_number';
  String usersProvince = "province";
  String usersDistrict = 'district';
  String usersAdministrativePost = 'administrative_post';
  String usersPassword = 'password';
  String usersSecurityQuestion = 'security_question';
  String usersSecurityAnswer = 'security_answer';
  String usersProfileId = 'profile_id';
  String usersCreatedAt = "created_at";
  String usersUpdatedAt = "updated_at";
  String usersLastSyncAt = "last_sync_at";
  String usersSyncStatus = "sync_status";

  String profileTable = "profiles";
  String profileId = "id";
  String profileName = "name";
  String profileVisibility = "visibility";

  String eventTable = "events";
  String eventEventId = "id";
  String eventEventUid = "event_uid";
  String eventUserUid = "user_uid";
  String eventType = "event_type";
  String eventName = "event";
  String eventFromDate = "from_date";
  String eventToDate = "to_date";
  String eventIsAllDay = "is_all_day";
  String eventBackgroundColor = "background_color";
  String eventStatus = "status";
  String eventCreatedAt = "created_at";
  String eventUpdatedAt = "updated_at";
  String eventLastSyncAt = "last_sync_at";
  String eventSyncStatus = "sync_status";

  String eventFarmerTable = "events_farmers";
  String eventFarmerId = "id";
  String eventFarmerEventUid = "event_uid";
  String eventFarmerFarmerUid = "farmer_uid";

  String faqTable = "faqs";
  String faqIdTable = "id";
  String faqTitleTable = "title";
  String faqDescriptionTable = "description";
  String faqCreatedAtTable = "created_at";
  String faqUpdatedAtTable = "updated_at";
  String faqDeletedAtTable = "deleted_at";

  String campaignsTable = "campaigns";
  String campaignsIdTable = "id";
  String campaignsOpeningTable = "opening";
  String campaignsClosingTable = "closing";
  String campaignsDescriptionTable = "description";
  String campaignsCreatedAtTable = "created_at";
  String campaignsUpdatedAtTable = "updated_at";
  String campaignsDeletedAtTable = "deleted_at";
  String campaignsLastSyncAtTable = "last_sync_at";


  String currentCampaignsTable = "current_campaign";
  String currentCampaignsIdTable = "id";
  String currentCampaignsOpeningTable = "opening";
  String currentCampaignsClosingTable = "closing";
  String currentCampaignsDescriptionTable = "description";
  String currentCampaignsCreatedAtTable = "created_at";
  String currentCampaignsUpdatedAtTable = "updated_at";

  Future<Database> initializeDatabase() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, Utils.db);

    // Open the database and returns the reference.
    return await openDatabase(path,
        version: Utils.dbVersion, onCreate: _createDb, onUpgrade: _upgradeDb);
  }

  //execute on create, when the database is not yet created and sets the version.
  //Note: the version is used to make upgrades of the database
  //The on create method will be executed as a transaction
  Future<void> _createDb(Database db, int version) async {
    //turns on the transaction mode
    await db.execute('PRAGMA foreign_keys=off');
    await db.execute('BEGIN TRANSACTION');

    //Create the farmers table to store farmers details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $farmersTable ($farmersId INTEGER PRIMARY KEY AUTOINCREMENT, $farmersUid INTEGER NOT NULL UNIQUE, $farmersUserUid INTEGER, $farmersFirstName TEXT, $farmersLastName TEXT, $farmersProvince TEXT, $farmersDistrict TEXT, $farmersAdministrativePost TEXT, $farmersLocality TEXT,$farmersMobileNumber TEXT, $farmersEmail TEXT, $farmersBirthDate INTEGER, $farmersBirthYear INTEGER, $farmersGender TEXT, $farmersCreatedAt INTEGER, $farmersUpdatedAt INTEGER, $farmersLastSyncAt INTEGER, $farmersSyncStatus INTEGER, $farmersStatus INTEGER)');

    //Create the plots table to store plots details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $plotsTable ($plotsId INTEGER PRIMARY KEY AUTOINCREMENT, $plotsUid INTEGER NOT NULL UNIQUE, $plotsUserUid INTEGER, $plotsFarmerUid INTEGER, $plotsName TEXT, $plotsNumberOfTrees INTEGER, $plotsNumberOfSmallTrees INTEGER, $plotsPlotType TEXT, $plotsPlotAge TEXT,$plotsOtherCrop TEXT, $plotsDeclaredArea TEXT, $plotsProvince TEXT, $plotsDistrict TEXT, $plotsAdministrativePost TEXT, $plotsCreatedAt INTEGER, $plotsUpdatedAt INTEGER, $plotsLastSyncAt INTEGER, $plotsSyncStatus INTEGER)');

    //Create the chemical acquisition table to store chemical acquisition details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $chemicalAcquisitionTable ($chemicalAcquisitionId INTEGER PRIMARY KEY AUTOINCREMENT,$chemicalAcquisitionUid INTEGER NOT NULL UNIQUE, $chemicalAcquisitionUserUid INTEGER, $chemicalAcquisitionChemicalAcquisitionMode TEXT, $chemicalAcquisitionChemicalAcquisitionPlace TEXT, $chemicalAcquisitionChemicalSupplier TEXT, $chemicalAcquisitionChemicalName TEXT, $chemicalAcquisitionChemicalQuantity REAL, $chemicalAcquisitionChemicalPrice REAL, $chemicalAcquisitionAcquiredAt INTEGER, $chemicalAcquisitionCreatedAt INTEGER, $chemicalAcquisitionUpdatedAt INTEGER, $chemicalAcquisitionLastSyncAt INTEGER, $chemicalAcquisitionSyncStatus INTEGER)');


    //Create the payment aggreement table to store payment aggreement details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $paymentAggreementTable ($paymentAggreementId INTEGER PRIMARY KEY AUTOINCREMENT, $paymentAggreementUid INTEGER NOT NULL UNIQUE, $paymentAggreementUserUid INTEGER, $paymentAggreementFarmerUid INTEGER, $paymentAggreementAggreedPayment REAL, $paymentAggreementAggreedPaymentPerSmallTrees REAL, $paymentAggreementAggreedTreesToSpray INTEGER, $paymentAggreementAggreedTreesSmallToSpray INTEGER, $paymentAggreementPaymentType TEXT, $paymentAggreementNumberOfApplications INTEGER, $paymentAggreementCreatedAt INTEGER, $paymentAggreementUpdatedAt INTEGER, $paymentAggreementLastSyncAt INTEGER, $paymentAggreementSyncStatus INTEGER)');

    //Create the payment aggreement table to store payment aggreement details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $paymentTable ($paymentId INTEGER PRIMARY KEY AUTOINCREMENT, $paymentUid INTEGER NOT NULL UNIQUE, $paymentFarmerUid INTEGER, $paymentUserUid INTEGER, $paymentPaid REAL, $paymentDiscount REAL, $paymentDescription TEXT, $paymentType TEXT, $paymentCreatedAt INTEGER, $paymentUpdatedAt INTEGER, $paymentLastSyncAt INTEGER, $paymentSyncStatus INTEGER)');

    //Create the payment aggreement table to store payment aggreement details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $expensesAndIncomeTable ($expensesAndIncomeId INTEGER PRIMARY KEY AUTOINCREMENT, $expensesAndIncomeUid INTEGER NOT NULL UNIQUE, $expensesAndIncomeUserUid INTEGER, $expensesAndIncomeCategory TEXT, $expensesAndIncomePrice REAL, $expensesAndIncomePaymentType TEXT, $expensesAndIncomeDescription TEXT, $expensesAndIncomeType TEXT, $expensesAndIncomeCreatedAt INTEGER, $expensesAndIncomeUpdatedAt INTEGER, $expensesAndIncomeLastSyncAt INTEGER, $expensesAndIncomeSyncStatus INTEGER)');

    //Create the equipments table to store equipments details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $equipmentsTable ($equipmentsId INTEGER PRIMARY KEY AUTOINCREMENT, $equipmentsUid INTEGER NOT NULL UNIQUE, $equipmentsUserUid INTEGER, $equipmentsName TEXT, $equipmentsModel TEXT, $equipmentsBrand TEXT, $equipmentsStatus TEXT, $equipmentsBuyedYear INTEGER, $equipmentsCreatedAt INTEGER, $equipmentsUpdatedAt INTEGER, $equipmentsLastSyncAt INTEGER, $equipmentsSyncStatus INTEGER)');

    //Create the preparatory activity table to store preparatory activity details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $preparatoryActivityTable ($preparatoryActivityId INTEGER PRIMARY KEY AUTOINCREMENT, $preparatoryActivityUid INTEGER NOT NULL UNIQUE, $preparatoryActivityUserUid INTEGER, $preparatoryActivityFarmerUid INTEGER, $preparatoryActivityNumberOfTreesPruned INTEGER, $preparatoryActivityNumberOfTreesCleaned INTEGER, $preparatoryActivityPruningType TEXT, $preparatoryActivityCreatedAt INTEGER, $preparatoryActivityUpdatedAt INTEGER, $preparatoryActivityLastSyncAt INTEGER, $preparatoryActivitySyncStatus INTEGER)');

    //Create the chemical application table to store chemical application details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $chemicalApplicationTable ($chemicalApplicationId INTEGER PRIMARY KEY AUTOINCREMENT,$chemicalApplicationUid INTEGER NOT NULL UNIQUE, $chemicalApplicationUserUid INTEGER, $chemicalApplicationFarmerUid INTEGER, $chemicalApplicationNumberOfTreesSprayed INTEGER, $chemicalApplicationNumberOfSmallTreesSprayed INTEGER, $chemicalApplicationNumber INTEGER, $chemicalApplicationNextApplication INTEGER, $chemicalApplicationSprayedAt INTEGER, $chemicalApplicationCreatedAt INTEGER, $chemicalApplicationUpdatedAt INTEGER, $chemicalApplicationLastSyncAt INTEGER, $chemicalApplicationSyncStatus INTEGER)');

    //Create the users table to store users details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $usersTable ($usersId INTEGER PRIMARY KEY AUTOINCREMENT, $usersUid INTEGER NOT NULL UNIQUE, $usersFirstName TEXT, $usersLastName TEXT, $usersEmail TEXT, $usersMobileNumber TEXT, $usersProvince TEXT, $usersDistrict TEXT, $usersAdministrativePost TEXT, $usersPassword TEXT, $usersSecurityQuestion TEXT, $usersSecurityAnswer TEXT, $usersProfileId INTEGER, $usersCreatedAt INTEGER, $usersUpdatedAt INTEGER, $usersLastSyncAt INTEGER, $usersSyncStatus INTEGER)');

    await db.execute(
        'CREATE TABLE IF NOT EXISTS $eventTable ($eventEventId INTEGER PRIMARY KEY AUTOINCREMENT,$eventEventUid INTEGER NOT NULL UNIQUE, $eventUserUid INTEGER, $eventType TEXT, $eventName TEXT, $eventFromDate INTEGER, $eventToDate INTEGER, $eventIsAllDay INTEGER, $eventBackgroundColor TEXT, $eventStatus INTEGER, $eventCreatedAt INTEGER, $eventUpdatedAt INTEGER, $eventLastSyncAt INTEGER, $eventSyncStatus INTEGER)');

    //Create the profile table to store profile details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $eventFarmerTable ($eventFarmerId INTEGER PRIMARY KEY AUTOINCREMENT, $eventFarmerEventUid INTEGER, $eventFarmerFarmerUid INTEGER)');

    //Create the profile table to store profile details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $profileTable ($profileId INTEGER NOT NULL UNIQUE, $profileName TEXT, $profileVisibility TEXT)');

    //Create the faq table to store profile details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $faqTable ($faqIdTable INTEGER NOT NULL UNIQUE, $faqTitleTable TEXT, $faqDescriptionTable TEXT, $faqCreatedAtTable INTEGER, $faqUpdatedAtTable INTEGER, $faqDeletedAtTable INTEGER)');

    //Create the campaigns table to store campaign details
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $campaignsTable ($campaignsIdTable INTEGER NOT NULL UNIQUE, $campaignsOpeningTable INTEGER, $campaignsClosingTable INTEGER, $campaignsDescriptionTable TEXT, $campaignsCreatedAtTable INTEGER, $campaignsUpdatedAtTable INTEGER, $campaignsDeletedAtTable INTEGER, $campaignsLastSyncAtTable INTEGER)');

    //Create the current campaign table to store the selected campaign
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $currentCampaignsTable ($currentCampaignsIdTable INTEGER NOT NULL UNIQUE, $currentCampaignsOpeningTable INTEGER, $currentCampaignsClosingTable INTEGER, $currentCampaignsDescriptionTable TEXT, $currentCampaignsCreatedAtTable INTEGER, $currentCampaignsUpdatedAtTable INTEGER)');

    //commits all transaction as atomic operation
    await db.execute('COMMIT');
    await db.execute('PRAGMA foreign_keys=on');
  }

  //executes when the current version of the database is greater or older than the latest version
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute('PRAGMA foreign_keys=off');
      await db.execute('BEGIN TRANSACTION');
      try {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $eventTable ($eventEventId INTEGER PRIMARY KEY AUTOINCREMENT,$eventEventUid INTEGER NOT NULL UNIQUE, $eventUserUid INTEGER, $eventType TEXT, $eventName TEXT, $eventFromDate INTEGER, $eventToDate INTEGER, $eventIsAllDay INTEGER, $eventStatus INTEGER, $eventCreatedAt INTEGER, $eventUpdatedAt INTEGER, $eventLastSyncAt INTEGER, $eventSyncStatus INTEGER)');
      } catch (e) {
        print(e.toString());
      }

      try {//Create the campaigns table to store campaign details
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $campaignsTable ($campaignsIdTable INTEGER NOT NULL UNIQUE, $campaignsOpeningTable INTEGER, $campaignsClosingTable INTEGER, $campaignsDescriptionTable TEXT, $campaignsCreatedAtTable INTEGER, $campaignsUpdatedAtTable INTEGER, $campaignsDeletedAtTable INTEGER, $campaignsLastSyncAtTable INTEGER)');
      } catch (e) {
        print(e.toString());
      }

      try {
        //Create the campaigns table to store campaign details
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $currentCampaignsTable ($currentCampaignsIdTable INTEGER NOT NULL UNIQUE, $currentCampaignsOpeningTable INTEGER, $currentCampaignsClosingTable INTEGER, $currentCampaignsDescriptionTable TEXT, $currentCampaignsCreatedAtTable INTEGER, $currentCampaignsUpdatedAtTable INTEGER)');

      } catch (e) {
        print(e.toString());
      }

      try {
        //Create the profile table to store profile details
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $eventFarmerTable ($eventFarmerId INTEGER PRIMARY KEY AUTOINCREMENT, $eventFarmerEventUid INTEGER, $eventFarmerFarmerUid INTEGER)');
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $chemicalApplicationTable ADD COLUMN $chemicalApplicationNextApplication INTEGER");
      } catch (e) {
        print(e.toString());
      }


      try {
        await db.execute(
            "ALTER TABLE $chemicalApplicationTable ADD COLUMN $chemicalApplicationNumberOfSmallTreesSprayed INTEGER");
      } catch (e) {
        print(e.toString());
      }


      try {
        await db.execute(
            "ALTER TABLE $preparatoryActivityTable ADD COLUMN $preparatoryActivityPruningType TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $plotsTable ADD COLUMN $plotsPlotType TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $plotsTable ADD COLUMN $plotsNumberOfSmallTrees INTEGER");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $eventTable ADD COLUMN $eventBackgroundColor TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $plotsTable ADD COLUMN $plotsOtherCrop TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $plotsTable ADD COLUMN $plotsDeclaredArea TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $farmersTable ADD COLUMN $farmersStatus INTEGER");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $usersTable ADD COLUMN $usersSecurityQuestion TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $usersTable ADD COLUMN $usersSecurityAnswer TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            "ALTER TABLE $chemicalAcquisitionTable ADD COLUMN $chemicalAcquisitionChemicalAcquisitionPlace TEXT");
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $faqTable ($faqIdTable INTEGER NOT NULL UNIQUE, $faqTitleTable TEXT, $faqDescriptionTable TEXT, $faqCreatedAtTable INTEGER, $faqUpdatedAtTable INTEGER, $faqDeletedAtTable INTEGER)');
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute('ALTER TABLE $paymentAggreementTable ADD COLUMN $paymentAggreementAggreedTreesSmallToSpray INTEGER');
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute('ALTER TABLE $paymentAggreementTable DROP COLUMN $paymentAggreementAggreedPaymentPerSmallTrees');
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute('ALTER TABLE $paymentAggreementTable ADD COLUMN $paymentAggreementAggreedPaymentPerSmallTrees REAL');
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute('ALTER TABLE $farmersTable ADD COLUMN $farmersBirthYear INTEGER');
      } catch (e) {
        print(e.toString());
      }

      try {
        await db.execute('ALTER TABLE $plotsTable ADD COLUMN $plotsPlotAge INTEGER');
      } catch (e) {
        print(e.toString());
      }

      //This is where we put the code for upgrade database
      await db.execute('COMMIT');
      await db.execute('PRAGMA foreign_keys=on');
    }
  }
}
