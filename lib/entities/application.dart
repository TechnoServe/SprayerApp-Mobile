import 'package:json_annotation/json_annotation.dart';

/// This allows the `Application` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'application.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class Application {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "chemical_application_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_application_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int chemicalApplicationUid;

  /// Tell json_serializable that "farmer_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'farmer_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int farmerUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "number_of_trees_sprayed" should be
  /// mapped to this property.
  @JsonKey(name: 'number_of_trees_sprayed', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int numberOfTreesSprayed;

  /// Tell json_serializable that "number_of_trees_sprayed" should be
  /// mapped to this property.
  @JsonKey(name: 'number_of_small_trees_sprayed', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int numberOfSmallTreesSprayed;

  /// Tell json_serializable that "application_number" should be
  /// mapped to this property.
  @JsonKey(name: 'application_number', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int applicationNumber;

  /// Tell json_serializable that "sprayed_at" should be
  /// mapped to this property.
  @JsonKey(name: 'sprayed_at')
  final DateTime sprayedAt;

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
  @JsonKey(name: 'sync_status', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int syncStatus;

  //related attributes
  final String? firstName;
  final String? lastName;

  const Application({
    this.id,
    required this.chemicalApplicationUid,
    required this.farmerUid,
    required this.userUid,
    required this.numberOfTreesSprayed,
    required this.numberOfSmallTreesSprayed,
    required this.applicationNumber,
    required this.sprayedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
    
    //related attributes
    this.firstName,
    this.lastName,
  });

  Application copyWith({
    int? chemicalApplicationUid,
    int? farmerUid,
    int? userUid,
    int? numberOfTreesSprayed,
    int? numberOfSmallTreesSprayed,
    int? applicationNumber,
    DateTime? sprayedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      Application(
        chemicalApplicationUid:
            chemicalApplicationUid ?? this.chemicalApplicationUid,
        farmerUid: farmerUid ?? this.farmerUid,
        userUid: userUid ?? this.userUid,
        numberOfTreesSprayed: numberOfTreesSprayed ?? this.numberOfTreesSprayed,
        numberOfSmallTreesSprayed: numberOfSmallTreesSprayed ?? this.numberOfSmallTreesSprayed,
        applicationNumber: applicationNumber ?? this.applicationNumber,
        sprayedAt: sprayedAt ?? this.sprayedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a Application into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'chemical_application_uid': chemicalApplicationUid,
      'farmer_uid': farmerUid,
      'user_uid': userUid,
      'number_of_trees_sprayed': numberOfTreesSprayed,
      'number_of_small_trees_sprayed': numberOfSmallTreesSprayed,
      'application_number': applicationNumber,
      'sprayed_at': sprayedAt.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory Application.fromMap(Map<String, dynamic> maps) => Application(
        chemicalApplicationUid: maps["chemical_application_uid"],
        userUid: maps["user_uid"],
        farmerUid: maps["farmer_uid"],
        numberOfTreesSprayed: maps["number_of_trees_sprayed"],
    numberOfSmallTreesSprayed: maps["number_of_small_trees_sprayed"],
        applicationNumber: maps["application_number"],
        sprayedAt: DateTime.fromMillisecondsSinceEpoch(maps["sprayed_at"]),
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new Application instance
  /// from a map. Pass the map to the generated `_$ApplicationFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Application.
  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ApplicationToJson`.
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);
  static String _stringFromIntNonNullable(int number) => number.toString();

  static int? _stringToIntNullable(String? number) => number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each application when using the print statement.
  @override
  String toString() {
    return "chemicalApplicationUid: $chemicalApplicationUid, farmerUid: $farmerUid, userUid: $userUid, numberOfTreesSprayed: $numberOfTreesSprayed, applicationNumber: $applicationNumber, sprayedAt: $sprayedAt, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncAt: $lastSyncAt, syncStatus: $syncStatus";
  }
}
