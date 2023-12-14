import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class User {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? userUid;

  /// Tell json_serializable that "first_name" should be
  /// mapped to this property.
  @JsonKey(name: 'first_name')
  final String? firstName;

  /// Tell json_serializable that "last_name" should be
  /// mapped to this property.
  @JsonKey(name: 'last_name')
  final String? lastName;

  /// Tell json_serializable that "email" should be
  /// mapped to this property.
  @JsonKey(name: 'email')
  final String? email;

  /// Tell json_serializable that "mobile_number" should be
  /// mapped to this property.
  @JsonKey(name: 'mobile_number')
  final String? mobileNumber;

  /// Tell json_serializable that "province" should be
  /// mapped to this property.
  @JsonKey(name: 'province')
  final String? province;

  /// Tell json_serializable that "district" should be
  /// mapped to this property.
  @JsonKey(name: 'district')
  final String? district;

  /// Tell json_serializable that "administrative_post" should be
  /// mapped to this property.
  @JsonKey(name: 'administrative_post')
  final String? administrativePost;

  /// Tell json_serializable that "password" should be
  /// mapped to this property.
  @JsonKey(name: 'password')
  final String? password;

  /// Tell json_serializable that "password" should be
  /// mapped to this property.
  @JsonKey(name: 'security_question')
  final String? securityQuestion;

  /// Tell json_serializable that "password" should be
  /// mapped to this property.
  @JsonKey(name: 'security_answer')
  final String? securityAnswer;

  /// Tell json_serializable that "profile_id" should be
  /// mapped to this property.
  @JsonKey(name: 'profile_id', fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? profileId;

  /// Tell json_serializable that "created_at" should be
  /// mapped to this property.
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Tell json_serializable that "updated_at" should be
  /// mapped to this property.
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Tell json_serializable that "last_sync_at" should be
  /// mapped to this property.
  @JsonKey(name: 'last_sync_at')
  final DateTime? lastSyncAt;

  /// Tell json_serializable that "sync_status" should be
  /// mapped to this property.
  @JsonKey(name: 'sync_status', fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? syncStatus;

  //related atributes
  final String? profile;
  final String? mobileAccess;
  final String? visibility;

  const User({
    this.id,
    this.userUid,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.province,
    this.district,
    this.administrativePost,
    this.password,
    this.securityQuestion,
    this.securityAnswer,
    this.profileId,
    this.createdAt,
    this.updatedAt,
    this.lastSyncAt,
    this.syncStatus,

    //related atributes
    this.profile,
    this.mobileAccess,
    this.visibility,
  });

  User copyWith({
    int? userUid,
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNumber,
    String? province,
    String? district,
    String? administrativePost,
    String? password,
    String? securityQuestion,
    String? securityAnswer,
    int? profileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
    String? profile,
    String? mobileAccess,
    String? visibility,
  }) =>
      User(
        userUid: userUid ?? this.userUid,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        email: email ?? this.email,
        province: province ?? this.province,
        district: district ?? this.district,
        administrativePost: administrativePost ?? this.administrativePost,
        password: password ?? this.password,
        securityQuestion: securityQuestion ?? this.securityQuestion,
        securityAnswer: securityAnswer ?? this.securityAnswer,
        profileId: profileId ?? this.profileId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
        profile: profile ?? this.profile,
        mobileAccess: mobileAccess ?? this.mobileAccess,
        visibility: visibility ?? this.visibility,
      );

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': mobileNumber,
      'email': email,
      'province': province,
      'district': district,
      'administrative_post': administrativePost,
      'password': password,
      'security_question': securityQuestion,
      'security_answer': securityAnswer,
      "profile_id": profileId,
      'created_at': createdAt!.millisecondsSinceEpoch,
      'updated_at': updatedAt!.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt!.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory User.fromMap(Map<String, dynamic> maps) => User(
        userUid: maps["user_uid"],
        firstName: maps["first_name"],
        lastName: maps["last_name"],
        mobileNumber: maps["mobile_number"],
        email: maps["email"],
        province: maps["province"],
        district: maps["district"],
        administrativePost: maps["administrative_post"],
        password: maps["password"],
        securityQuestion: maps["security_question"],
        securityAnswer: maps["security_answer"],
        profileId: maps["profile_id"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson(User instance) => _$UserToJson(this);

  static int? _stringToIntNullable(String? number) =>
      number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'userId: $id, userUid: $userUid, firstName: $firstName, lastName: $lastName, mobileNumber: $mobileNumber, email: $email, province: $province, district: $district, administrativePost: $administrativePost, password: $password, security_question: $securityQuestion, security_answer: $securityAnswer, profile: $profile, visibility: $visibility';
  }
}
