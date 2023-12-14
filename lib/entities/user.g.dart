// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: User._stringToIntNullable(json['id'] as String?),
      userUid: User._stringToIntNullable(json['user_uid'] as String?),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      email: json['email'] as String?,
      province: json['province'] as String?,
      district: json['district'] as String?,
      administrativePost: json['administrative_post'] as String?,
      password: json['password'] as String?,
      securityQuestion: json['security_question'] as String?,
      securityAnswer: json['security_answer'] as String?,
      profileId: User._stringToIntNullable(json['profile_id'] as String?),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      lastSyncAt: json['last_sync_at'] == null
          ? null
          : DateTime.parse(json['last_sync_at'] as String),
      syncStatus: User._stringToIntNullable(json['sync_status'] as String?),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': User._stringFromIntNullable(instance.id),
      'user_uid': User._stringFromIntNullable(instance.userUid),
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'mobile_number': instance.mobileNumber,
      'province': instance.province,
      'district': instance.district,
      'administrative_post': instance.administrativePost,
      'password': instance.password,
      'security_question': instance.securityQuestion,
      'security_answer': instance.securityAnswer,
      'profile_id': User._stringFromIntNullable(instance.profileId),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'last_sync_at': instance.lastSyncAt?.toIso8601String(),
      'sync_status': User._stringFromIntNullable(instance.syncStatus),
    };
