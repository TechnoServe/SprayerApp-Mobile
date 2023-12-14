// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Farmer _$FarmerFromJson(Map<String, dynamic> json) => Farmer(
      id: Farmer._stringToIntNullable(json['id'] as String?),
      farmerUid: Farmer._stringToIntNonNullable(json['farmer_uid'] as String),
      userUid: Farmer._stringToIntNonNullable(json['user_uid'] as String),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      birthYear: Farmer._stringToIntNullable(json['birth_year'] as String?),
      gender: json['gender'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      email: json['email'] as String?,
      province: json['province'] as String?,
      district: json['district'] as String?,
      administrativePost: json['administrative_post'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus: Farmer._stringToIntNonNullable(json['sync_status'] as String),
      status: json['status'] == null
          ? 0
          : Farmer._stringToIntNullable(json['status'] as String?),
    );

Map<String, dynamic> _$FarmerToJson(Farmer instance) => <String, dynamic>{
      'id': Farmer._stringFromIntNullable(instance.id),
      'farmer_uid': Farmer._stringFromIntNonNullable(instance.farmerUid),
      'user_uid': Farmer._stringFromIntNonNullable(instance.userUid),
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'birth_date': instance.birthDate?.toIso8601String(),
      'birth_year': Farmer._stringFromIntNullable(instance.birthYear),
      'gender': instance.gender,
      'mobile_number': instance.mobileNumber,
      'email': instance.email,
      'province': instance.province,
      'district': instance.district,
      'administrative_post': instance.administrativePost,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status': Farmer._stringFromIntNonNullable(instance.syncStatus),
      'status': Farmer._stringFromIntNullable(instance.status),
    };
