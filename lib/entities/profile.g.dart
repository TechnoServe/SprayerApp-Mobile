// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: Profile._stringToInt(json['id'] as String),
      name: json['name'] as String,
      visibility: json['visibility'] as String,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': Profile._stringFromInt(instance.id),
      'name': instance.name,
      'visibility': instance.visibility,
    };
