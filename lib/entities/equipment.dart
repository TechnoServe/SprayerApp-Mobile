import 'package:json_annotation/json_annotation.dart';

/// This allows the `Equipment` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'equipment.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class Equipment {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "equipments_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'equipments_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int equipmentUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "name" should be
  /// mapped to this property.
  @JsonKey(name: 'name')
  final String name;

  /// Tell json_serializable that "model" should be
  /// mapped to this property.
  @JsonKey(name: 'model')
  final String? model;

  /// Tell json_serializable that "brand" should be
  /// mapped to this property.
  @JsonKey(name: 'brand')
  final String? brand;

  /// Tell json_serializable that "status" should be
  /// mapped to this property.
  @JsonKey(name: 'status')
  final String? status;

  /// Tell json_serializable that "buyed_year" should be
  /// mapped to this property.
  @JsonKey(name: 'buyed_year', defaultValue: 0, fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? buyedYear;

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

  const Equipment({
    this.id,
    required this.equipmentUid,
    required this.userUid,
    required this.name,
    this.model,
    this.brand,
    this.status,
    this.buyedYear,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
  });

  Equipment copyWith({
    int? id,
    int? equipmentUid,
    int? userUid,
    String? name,
    String? model,
    String? brand,
    String? status,
    int? buyedYear,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      Equipment(
        equipmentUid: equipmentUid ?? this.equipmentUid,
        userUid: userUid ?? this.userUid,
        name: name ?? this.name,
        model: model ?? this.model,
        brand: brand ?? this.brand,
        status: status ?? this.status,
        buyedYear: buyedYear ?? this.buyedYear,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a Equipment into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'equipments_uid': equipmentUid,
      'user_uid': userUid,
      'name': name,
      'model': model,
      'brand': brand,
      'status': status,
      'buyed_year': buyedYear,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory Equipment.fromMap(Map<String, dynamic> maps) => Equipment(
        equipmentUid: maps["equipments_uid"],
        userUid: maps["user_uid"],
        name: maps["name"],
        model: maps["model"],
        brand: maps["brand"],
        status: maps["status"],
        buyedYear: maps["buyed_year"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new Equipment instance
  /// from a map. Pass the map to the generated `_$EquipmentFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Equipment.
  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$EquipmentToJson`.
  Map<String, dynamic> toJson() => _$EquipmentToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);
  static String _stringFromIntNonNullable(int number) => number.toString();

  static int? _stringToIntNullable(String? number) => number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each equipment when using the print statement.
  @override
  String toString() {
    return '';
  }
}
