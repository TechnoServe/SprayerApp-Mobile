// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesIncome _$ExpensesIncomeFromJson(Map<String, dynamic> json) =>
    ExpensesIncome(
      expensesIncomeUid: ExpensesIncome._stringToIntNonNullable(
          json['expenses_income_uid'] as String),
      userUid:
          ExpensesIncome._stringToIntNonNullable(json['user_uid'] as String),
      category: json['category'] as String,
      price: ExpensesIncome._stringToDoubleNullable(json['price'] as String?),
      description: json['description'] as String?,
      expensesIncomeType: json['expenses_income_type'] as String?,
      paymentType: json['expenses_income_payment_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus:
          ExpensesIncome._stringToIntNonNullable(json['sync_status'] as String),
    );

Map<String, dynamic> _$ExpensesIncomeToJson(ExpensesIncome instance) =>
    <String, dynamic>{
      'expenses_income_uid':
          ExpensesIncome._stringFromIntNonNullable(instance.expensesIncomeUid),
      'user_uid': ExpensesIncome._stringFromIntNonNullable(instance.userUid),
      'category': instance.category,
      'price': ExpensesIncome._stringFromDoubleNullable(instance.price),
      'description': instance.description,
      'expenses_income_type': instance.expensesIncomeType,
      'expenses_income_payment_type': instance.paymentType,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status':
          ExpensesIncome._stringFromIntNonNullable(instance.syncStatus),
    };
