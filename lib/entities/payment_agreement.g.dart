// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_agreement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentAgreement _$PaymentAgreementFromJson(Map<String, dynamic> json) =>
    PaymentAgreement(
      id: PaymentAgreement._stringToIntNullable(json['id'] as String?),
      paymentAgreementUid: PaymentAgreement._stringToIntNonNullable(
          json['payment_aggreement_uid'] as String),
      userUid:
          PaymentAgreement._stringToIntNonNullable(json['user_uid'] as String),
      farmerUid: PaymentAgreement._stringToIntNonNullable(
          json['farmer_uid'] as String),
      aggreedPayment: json['aggreed_payment'] == null
          ? 0.0
          : PaymentAgreement._stringToDoubleNullable(
              json['aggreed_payment'] as String?),
      aggreedPaymentPerSmallTrees:
          json['aggreed_payment_per_small_trees'] == null
              ? 0.0
              : PaymentAgreement._stringToDoubleNullable(
                  json['aggreed_payment_per_small_trees'] as String?),
      aggreedTreesToSpray: json['aggreed_trees_to_spray'] == null
          ? 0
          : PaymentAgreement._stringToIntNullable(
              json['aggreed_trees_to_spray'] as String?),
      aggreedSmallTreesToSpray: json['aggreed_trees_small_to_spray'] == null
          ? 0
          : PaymentAgreement._stringToIntNullable(
              json['aggreed_trees_small_to_spray'] as String?),
      paymentType: json['payment_type'] as String?,
      numberOfApplications: PaymentAgreement._stringToIntNullable(
          json['number_of_applications'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus: PaymentAgreement._stringToIntNonNullable(
          json['sync_status'] as String),
    );

Map<String, dynamic> _$PaymentAgreementToJson(PaymentAgreement instance) =>
    <String, dynamic>{
      'id': PaymentAgreement._stringFromIntNullable(instance.id),
      'payment_aggreement_uid': PaymentAgreement._stringFromIntNonNullable(
          instance.paymentAgreementUid),
      'user_uid': PaymentAgreement._stringFromIntNonNullable(instance.userUid),
      'farmer_uid':
          PaymentAgreement._stringFromIntNonNullable(instance.farmerUid),
      'aggreed_payment':
          PaymentAgreement._stringFromDoubleNullable(instance.aggreedPayment),
      'aggreed_payment_per_small_trees':
          PaymentAgreement._stringFromDoubleNullable(
              instance.aggreedPaymentPerSmallTrees),
      'aggreed_trees_to_spray':
          PaymentAgreement._stringFromIntNullable(instance.aggreedTreesToSpray),
      'aggreed_trees_small_to_spray': PaymentAgreement._stringFromIntNullable(
          instance.aggreedSmallTreesToSpray),
      'payment_type': instance.paymentType,
      'number_of_applications': PaymentAgreement._stringFromIntNullable(
          instance.numberOfApplications),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status':
          PaymentAgreement._stringFromIntNonNullable(instance.syncStatus),
    };
