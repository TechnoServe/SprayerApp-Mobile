// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipment _$EquipmentFromJson(Map<String, dynamic> json) => Equipment(
      id: Equipment._stringToIntNullable(json['id'] as String?),
      equipmentUid:
          Equipment._stringToIntNonNullable(json['equipments_uid'] as String),
      userUid: Equipment._stringToIntNonNullable(json['user_uid'] as String),
      name: json['name'] as String,
      model: json['model'] as String?,
      brand: json['brand'] as String?,
      status: json['status'] as String?,
      buyedYear: json['buyed_year'] == null
          ? 0
          : Equipment._stringToIntNullable(json['buyed_year'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus:
          Equipment._stringToIntNonNullable(json['sync_status'] as String),
    );

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      'id': Equipment._stringFromIntNullable(instance.id),
      'equipments_uid':
          Equipment._stringFromIntNonNullable(instance.equipmentUid),
      'user_uid': Equipment._stringFromIntNonNullable(instance.userUid),
      'name': instance.name,
      'model': instance.model,
      'brand': instance.brand,
      'status': instance.status,
      'buyed_year': Equipment._stringFromIntNullable(instance.buyedYear),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status': Equipment._stringFromIntNonNullable(instance.syncStatus),
    };
