// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      paymentUid:
          Payment._stringToIntNonNullable(json['payment_uid'] as String),
      farmerUid: Payment._stringToIntNonNullable(json['farmer_uid'] as String),
      userUid: Payment._stringToIntNonNullable(json['user_uid'] as String),
      paid: json['paid'] == null
          ? 0.0
          : Payment._stringToDoubleNullable(json['paid'] as String?),
      discount: json['discount'] == null
          ? 0.0
          : Payment._stringToDoubleNullable(json['discount'] as String?),
      description: json['description'] as String?,
      paymentType: json['payment_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus:
          Payment._stringToIntNonNullable(json['sync_status'] as String),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'payment_uid': Payment._stringFromIntNonNullable(instance.paymentUid),
      'farmer_uid': Payment._stringFromIntNonNullable(instance.farmerUid),
      'user_uid': Payment._stringFromIntNonNullable(instance.userUid),
      'paid': Payment._stringFromDoubleNullable(instance.paid),
      'discount': Payment._stringFromDoubleNullable(instance.discount),
      'description': instance.description,
      'payment_type': instance.paymentType,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status': Payment._stringFromIntNonNullable(instance.syncStatus),
    };
