import 'package:json_annotation/json_annotation.dart';

/// This allows the `Farmer` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'farmer.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class Farmer {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "farmer_uid" should be
  /// mapped to this property.
  @JsonKey(
      name: 'farmer_uid',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int farmerUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(
      name: 'user_uid',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "firstname" should be
  /// mapped to this property.
  @JsonKey(name: 'first_name')
  final String firstName;

  /// Tell json_serializable that "lastname" should be
  /// mapped to this property.
  @JsonKey(name: 'last_name')
  final String? lastName;

  /// Tell json_serializable that "birth_date" should be
  /// mapped to this property.
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;

  /// Tell json_serializable that "birth_year" should be
  /// mapped to this property.
  @JsonKey(
      name: 'birth_year',
      fromJson: _stringToIntNullable,
      toJson: _stringFromIntNullable)
  final int? birthYear;

  /// Tell json_serializable that "gender" should be
  /// mapped to this property.
  @JsonKey(name: 'gender')
  final String? gender;

  /// Tell json_serializable that "mobile_number" should be
  /// mapped to this property.
  @JsonKey(name: 'mobile_number')
  final String? mobileNumber;

  /// Tell json_serializable that "email" should be
  /// mapped to this property.
  @JsonKey(name: 'email')
  final String? email;

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

  /// Tell json_serializable that "created_at" should be
  /// mapped to this property.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Tell json_serializable that "updated_at" should be
  /// mapped to this property.
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Tell json_serializable that "last_sync_at" should be
  /// mapped to this property.
  @JsonKey(name: 'last_sync_at')
  final DateTime lastSyncAt;

  /// Tell json_serializable that "sync_status" should be
  /// mapped to this property.
  @JsonKey(
      name: 'sync_status',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int syncStatus;

  /// Tell json_serializable that "sync_status" should be
  /// mapped to this property.
  @JsonKey(
      name: 'status',
      defaultValue: 0,
      fromJson: _stringToIntNullable,
      toJson: _stringFromIntNullable)
  final int? status;

  ///Those properties bellow are not persisted however are need to perform different task in farmer flow
  ///related attributes for plots
  final int? numberOfPlots;
  final int? numberOfTrees;

  ///related attributes for chemical applications
  final int? treesSprayedInFirstApplication;
  final int? treesSprayedInSecondApplication;
  final int? treesSprayedInThirdApplication;

  ///related attributes for preparatory activity
  final int? treesCleaned;
  final int? treesPruned;

  ///related attributes for payment aggreement
  final int? paymentAgreementUid;
  final double? aggredPayment;
  final double? aggreedPaymentPerSmallTrees;
  final int? aggredTrees;
  final int? aggredSmallTrees;
  final String? paymentType;
  final int? numberOfApplications;

  ///related attributes for payment
  final double? totalPaid;
  final double? discount;
  final int? paymentUid;
  final DateTime? dateOfSecondApplication;
  final DateTime? dateOfThirdApplication;

  const Farmer({
    this.id,
    required this.farmerUid,
    required this.userUid,
    required this.firstName,
    this.lastName,
    this.birthDate,
    this.birthYear,
    this.gender,
    this.mobileNumber,
    this.email,
    this.province,
    this.district,
    this.administrativePost,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
    required this.status,

    ///related attributes for plots
    this.numberOfPlots,
    this.numberOfTrees,

    ///related attributes for chemical applications
    this.treesSprayedInFirstApplication,
    this.treesSprayedInSecondApplication,
    this.treesSprayedInThirdApplication,

    ///related attribues for preparatory activity
    this.treesCleaned,
    this.treesPruned,

    ///related attributes for payment aggreement
    this.paymentAgreementUid,
    this.aggredPayment,
    this.aggreedPaymentPerSmallTrees,
    this.aggredTrees,
    this.aggredSmallTrees,
    this.paymentType,
    this.numberOfApplications,

    ///related attributes for payments
    this.totalPaid,
    this.discount,
    this.paymentUid,
    this.dateOfSecondApplication,
    this.dateOfThirdApplication,
  });

  Farmer copyWith({
    int? farmerUid,
    int? userUid,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    int? birthYear,
    String? gender,
    String? mobileNumber,
    String? email,
    String? province,
    String? district,
    String? administrativePost,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
    int? status,
  }) =>
      Farmer(
        farmerUid: farmerUid ?? this.farmerUid,
        userUid: userUid ?? this.userUid,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        gender: gender ?? this.gender,
        birthDate: birthDate ?? this.birthDate,
        birthYear: birthYear ?? this.birthYear,
        province: province ?? this.province,
        district: district ?? this.district,
        administrativePost: administrativePost ?? this.administrativePost,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
        status: status ?? this.status,
      );

  // Convert a Farmer into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'farmer_uid': farmerUid,
      'user_uid': userUid,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date':
          (birthDate != null) ? birthDate!.millisecondsSinceEpoch : null,
      'birth_year': birthYear,
      'gender': gender,
      'mobile_number': mobileNumber,
      'email': email,
      'province': province,
      'district': district,
      'administrative_post': administrativePost,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus,
      'status': status,
    };
  }

  factory Farmer.fromMap(Map<String, dynamic> maps) => Farmer(
        farmerUid: maps["farmer_uid"],
        userUid: maps["user_uid"],
        firstName: maps["first_name"],
        lastName: maps["last_name"],
        email: maps["email"],
        mobileNumber: maps["mobile_number"],
        gender: maps["gender"],
        birthDate: (maps["birth_date"] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps["birth_date"])
            : null,
        birthYear: maps["birth_year"],
        province: maps["province"],
        district: maps["district"],
        administrativePost: maps["administrative_post"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
        status: maps["status"],
      );

  /// A necessary factory constructor for creating a new Farmer instance
  /// from a map. Pass the map to the generated `_$FarmerFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Farmer.
  factory Farmer.fromJson(Map<String, dynamic> json) => _$FarmerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$FarmerToJson`.
  Map<String, dynamic> toJson() => _$FarmerToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);

  static String _stringFromIntNonNullable(int number) => number.toString();

  static int? _stringToIntNullable(String? number) =>
      number == null ? null : int.tryParse(number);

  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each farmer when using the print statement.
  @override
  String toString() {
    return 'farmerUid: $farmerUid, userUid: $userUid, lastName: $lastName, status: $status, province: $province, district: $district, administrativePost: $administrativePost';
  }
}
