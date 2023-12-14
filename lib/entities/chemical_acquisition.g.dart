// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chemical_acquisition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChemicalAcquisition _$ChemicalAcquisitionFromJson(Map<String, dynamic> json) =>
    ChemicalAcquisition(
      id: ChemicalAcquisition._stringToIntNullable(json['id'] as String?),
      chemicalAcquisitionUid: ChemicalAcquisition._stringToIntNonNullable(
          json['chemical_acquisition_uid'] as String),
      userUid: ChemicalAcquisition._stringToIntNonNullable(
          json['user_uid'] as String),
      name: json['chemical_name'] as String,
      supplier: json['chemical_supplier'] as String?,
      acquisitionMode: json['chemical_acquisition_mode'] as String,
      whereYouAcquired: json['chemical_acquisition_place'] as String,
      quantity: json['chemical_quantity'] == null
          ? 0.0
          : ChemicalAcquisition._stringToDoubleNullable(
              json['chemical_quantity'] as String?),
      price: json['chemical_price'] == null
          ? 0.0
          : ChemicalAcquisition._stringToDoubleNullable(
              json['chemical_price'] as String?),
      acquiredAt: json['acquired_at'] == null
          ? null
          : DateTime.parse(json['acquired_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus: ChemicalAcquisition._stringToIntNonNullable(
          json['sync_status'] as String),
    );

Map<String, dynamic> _$ChemicalAcquisitionToJson(
        ChemicalAcquisition instance) =>
    <String, dynamic>{
      'id': ChemicalAcquisition._stringFromIntNullable(instance.id),
      'chemical_acquisition_uid': ChemicalAcquisition._stringFromIntNonNullable(
          instance.chemicalAcquisitionUid),
      'user_uid':
          ChemicalAcquisition._stringFromIntNonNullable(instance.userUid),
      'chemical_acquisition_mode': instance.acquisitionMode,
      'chemical_acquisition_place': instance.whereYouAcquired,
      'chemical_name': instance.name,
      'chemical_supplier': instance.supplier,
      'chemical_quantity':
          ChemicalAcquisition._stringFromDoubleNullable(instance.quantity),
      'chemical_price':
          ChemicalAcquisition._stringFromDoubleNullable(instance.price),
      'acquired_at': instance.acquiredAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status':
          ChemicalAcquisition._stringFromIntNonNullable(instance.syncStatus),
    };
