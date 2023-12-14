// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      eventUid: Event._stringToIntNonNullable(json['event_uid'] as String),
      userUid: Event._stringToIntNonNullable(json['user_uid'] as String),
      name: json['event'] as String,
      eventType: json['event_type'] as String,
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      backgroundColor:
          json['background_color'] as String? ?? "Colors.lightGreen",
      isAllDay: json['is_all_day'] == null
          ? 0
          : Event._stringToIntNullable(json['is_all_day'] as String?),
      status: json['status'] == null
          ? 0
          : Event._stringToIntNullable(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      syncStatus: Event._stringToIntNonNullable(json['sync_status'] as String),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'event_uid': Event._stringFromIntNonNullable(instance.eventUid),
      'user_uid': Event._stringFromIntNonNullable(instance.userUid),
      'event': instance.name,
      'event_type': instance.eventType,
      'from_date': instance.fromDate.toIso8601String(),
      'to_date': instance.toDate.toIso8601String(),
      'background_color': instance.backgroundColor,
      'is_all_day': Event._stringFromIntNullable(instance.isAllDay),
      'status': Event._stringFromIntNullable(instance.status),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_sync_at': instance.lastSyncAt.toIso8601String(),
      'sync_status': Event._stringFromIntNonNullable(instance.syncStatus),
    };
