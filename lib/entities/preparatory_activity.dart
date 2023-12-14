import 'package:json_annotation/json_annotation.dart';

/// This allows the `Application` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'preparatory_activity.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class PreparatoryActivity {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "preparatory_activity_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'preparatory_activity_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int preparatoryActivityUid;

  /// Tell json_serializable that "farmer_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'farmer_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int farmerUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "number_of_trees_pruned" should be
  /// mapped to this property.
  @JsonKey(name: 'number_of_trees_pruned', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int numberOfTreesPruned;

  /// Tell json_serializable that "number_of_trees_cleaned" should be
  /// mapped to this property.
  @JsonKey(name: 'number_of_trees_cleaned', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int numberOfTreesCleaned;

  /// Tell json_serializable that "number_of_trees_cleaned" should be
  /// mapped to this property.
  @JsonKey(name: 'pruning_type')
  final String? pruningType;

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

  const PreparatoryActivity({
    this.id,
    required this.preparatoryActivityUid,
    required this.farmerUid,
    required this.userUid,
    required this.numberOfTreesCleaned,
    required this.numberOfTreesPruned,
    this.pruningType,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,

    //related attributes
    this.firstName,
    this.lastName,
  });

  PreparatoryActivity copyWith({
    int? preparatoryActivityUid,
    int? farmerUid,
    int? userUid,
    int? numberOfTreesPruned,
    int? numberOfTreesCleaned,
    String? pruningType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      PreparatoryActivity(
        preparatoryActivityUid:
            preparatoryActivityUid ?? this.preparatoryActivityUid,
        farmerUid: farmerUid ?? this.farmerUid,
        userUid: userUid ?? this.userUid,
        numberOfTreesPruned: numberOfTreesPruned ?? this.numberOfTreesPruned,
        numberOfTreesCleaned: numberOfTreesCleaned ?? this.numberOfTreesCleaned,
        pruningType: pruningType ?? this.pruningType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a PreparatoryActivity into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'preparatory_activity_uid': preparatoryActivityUid,
      'farmer_uid': farmerUid,
      'user_uid': userUid,
      'number_of_trees_pruned': numberOfTreesPruned,
      'number_of_trees_cleaned': numberOfTreesCleaned,
      'pruning_type': pruningType,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory PreparatoryActivity.fromMap(Map<String, dynamic> maps) =>
      PreparatoryActivity(
        preparatoryActivityUid: maps["preparatory_activity_uid"],
        farmerUid: maps["farmer_uid"],
        userUid: maps["user_uid"],
        numberOfTreesPruned: maps["number_of_trees_pruned"],
        numberOfTreesCleaned: maps["number_of_trees_cleaned"],
        pruningType: maps["pruning_type"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new PreparatoryActivity instance
  /// from a map. Pass the map to the generated `_$PreparatoryActivityFromJson()` constructor.
  /// The constructor is named after the source class, in this case, PreparatoryActivity.
  factory PreparatoryActivity.fromJson(Map<String, dynamic> json) =>
      _$PreparatoryActivityFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PreparatoryActivityToJson`.
  Map<String, dynamic> toJson() => _$PreparatoryActivityToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);
  static String _stringFromIntNonNullable(int number) => number.toString();

  static int? _stringToIntNullable(String? number) => number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'preparatoryActivityUid: $preparatoryActivityUid, numberOfTreesPruned: $numberOfTreesPruned, numberOfTreesCleaned: $numberOfTreesCleaned, pruningType: $pruningType';
  }
}
