// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      id: Application._stringToIntNullable(json['id'] as String?),
      chemicalApplicationUid: Application._stringToIntNonNullable(
          json['chemical_application_uid'] as String),
      farmerUid:
          Application._stringToIntNonNullable(json['farmer_uid'] as String),
      userUid: Application._stringToIntNonNullable(json['user_uid'] as String),
      numberOfTreesSprayed: Application._stringToIntNonNullable(
          json['number_of_trees_sprayed'] as String),
      numberOfSmallTreesSprayed: Application._stringToIntNonNullable(
          json['number_of_small_trees_sprayed'] as String),
      applicationNumber: Application._stringToIntNonNullable(
          json['application_number'] as String),
      sprayedAt: DateTime.parse(json['sprayed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus:
          Application._stringToIntNonNullable(json['sync_status'] as String),
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': Application._stringFromIntNullable(instance.id),
      'chemical_application_uid': Application._stringFromIntNonNullable(
          instance.chemicalApplicationUid),
      'farmer_uid': Application._stringFromIntNonNullable(instance.farmerUid),
      'user_uid': Application._stringFromIntNonNullable(instance.userUid),
      'number_of_trees_sprayed':
          Application._stringFromIntNonNullable(instance.numberOfTreesSprayed),
      'number_of_small_trees_sprayed': Application._stringFromIntNonNullable(
          instance.numberOfSmallTreesSprayed),
      'application_number':
          Application._stringFromIntNonNullable(instance.applicationNumber),
      'sprayed_at': instance.sprayedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status': Application._stringFromIntNonNullable(instance.syncStatus),
    };
