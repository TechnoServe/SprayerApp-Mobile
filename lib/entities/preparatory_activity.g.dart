// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preparatory_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreparatoryActivity _$PreparatoryActivityFromJson(Map<String, dynamic> json) =>
    PreparatoryActivity(
      id: PreparatoryActivity._stringToIntNullable(json['id'] as String?),
      preparatoryActivityUid: PreparatoryActivity._stringToIntNonNullable(
          json['preparatory_activity_uid'] as String),
      farmerUid: PreparatoryActivity._stringToIntNonNullable(
          json['farmer_uid'] as String),
      userUid: PreparatoryActivity._stringToIntNonNullable(
          json['user_uid'] as String),
      numberOfTreesCleaned: PreparatoryActivity._stringToIntNonNullable(
          json['number_of_trees_cleaned'] as String),
      numberOfTreesPruned: PreparatoryActivity._stringToIntNonNullable(
          json['number_of_trees_pruned'] as String),
      pruningType: json['pruning_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus: PreparatoryActivity._stringToIntNonNullable(
          json['sync_status'] as String),
    );

Map<String, dynamic> _$PreparatoryActivityToJson(
        PreparatoryActivity instance) =>
    <String, dynamic>{
      'id': PreparatoryActivity._stringFromIntNullable(instance.id),
      'preparatory_activity_uid': PreparatoryActivity._stringFromIntNonNullable(
          instance.preparatoryActivityUid),
      'farmer_uid':
          PreparatoryActivity._stringFromIntNonNullable(instance.farmerUid),
      'user_uid':
          PreparatoryActivity._stringFromIntNonNullable(instance.userUid),
      'number_of_trees_pruned': PreparatoryActivity._stringFromIntNonNullable(
          instance.numberOfTreesPruned),
      'number_of_trees_cleaned': PreparatoryActivity._stringFromIntNonNullable(
          instance.numberOfTreesCleaned),
      'pruning_type': instance.pruningType,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status':
          PreparatoryActivity._stringFromIntNonNullable(instance.syncStatus),
    };
