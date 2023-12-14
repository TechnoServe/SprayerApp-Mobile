// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plot _$PlotFromJson(Map<String, dynamic> json) => Plot(
      id: Plot._stringToIntNullable(json['id'] as String?),
      plotUid: Plot._stringToIntNonNullable(json['plot_uid'] as String),
      farmerUid: Plot._stringToIntNonNullable(json['farmer_uid'] as String),
      userUid: Plot._stringToIntNonNullable(json['user_uid'] as String),
      name: json['name'] as String,
      numberOfTrees:
          Plot._stringToIntNonNullable(json['number_of_trees'] as String),
      numberOfSmallTrees:
          Plot._stringToIntNullable(json['number_of_small_trees'] as String?),
      plotType: json['plot_type'] as String?,
      plotAge: json['plot_age'] as String?,
      otherCrop: json['other_crop'] as String?,
      declaredArea: json['declared_area'] as String?,
      province: json['province'] as String?,
      district: json['district'] as String?,
      administrativePost: json['administrative_post'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus: Plot._stringToIntNonNullable(json['sync_status'] as String),
    );

Map<String, dynamic> _$PlotToJson(Plot instance) => <String, dynamic>{
      'id': Plot._stringFromIntNullable(instance.id),
      'plot_uid': Plot._stringFromIntNonNullable(instance.plotUid),
      'farmer_uid': Plot._stringFromIntNonNullable(instance.farmerUid),
      'user_uid': Plot._stringFromIntNonNullable(instance.userUid),
      'name': instance.name,
      'number_of_trees': Plot._stringFromIntNonNullable(instance.numberOfTrees),
      'number_of_small_trees':
          Plot._stringFromIntNullable(instance.numberOfSmallTrees),
      'plot_type': instance.plotType,
      'plot_age': instance.plotAge,
      'other_crop': instance.otherCrop,
      'declared_area': instance.declaredArea,
      'province': instance.province,
      'district': instance.district,
      'administrative_post': instance.administrativePost,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status': Plot._stringFromIntNonNullable(instance.syncStatus),
    };
