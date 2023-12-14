import 'package:json_annotation/json_annotation.dart';

/// This allows the `ChemicalAcquisition` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'chemical_acquisition.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class ChemicalAcquisition {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "chemical_acquisition_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_acquisition_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int chemicalAcquisitionUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "chemical_acquisition_mode" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_acquisition_mode')
  final String acquisitionMode;

  /// Tell json_serializable that "chemical_acquisition_mode" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_acquisition_place')
  final String whereYouAcquired;

  /// Tell json_serializable that "name" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_name')
  final String name;

  /// Tell json_serializable that "chemical_supplier" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_supplier')
  final String? supplier;

  /// Tell json_serializable that "chemical_quantity" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_quantity', defaultValue: 0.0, fromJson: _stringToDoubleNullable, toJson: _stringFromDoubleNullable)
  final double? quantity;

  /// Tell json_serializable that "chemical_price" should be
  /// mapped to this property.
  @JsonKey(name: 'chemical_price', defaultValue: 0.0, fromJson: _stringToDoubleNullable, toJson: _stringFromDoubleNullable)
  final double? price;

  /// Tell json_serializable that "acquired_at" should be
  /// mapped to this property.
  @JsonKey(name: 'acquired_at')
  final DateTime? acquiredAt;

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

  const ChemicalAcquisition({
    this.id,
    required this.chemicalAcquisitionUid,
    required this.userUid,
    required this.name,
    this.supplier,
    required this.acquisitionMode,
    required this.whereYouAcquired,
    this.quantity,
    this.price,
    this.acquiredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
  });

  ChemicalAcquisition copyWith({
    int? chemicalAcquisitionUid,
    int? userUid,
    String? name,
    String? supplier,
    String? acquisitionMode,
    String? whereYouAcquired,
    double? quantity,
    double? price,
    DateTime? acquiredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      ChemicalAcquisition(
        chemicalAcquisitionUid:
            chemicalAcquisitionUid ?? this.chemicalAcquisitionUid,
        userUid: userUid ?? this.userUid,
        name: name ?? this.name,
        supplier: supplier ?? this.supplier,
        acquisitionMode: acquisitionMode ?? this.acquisitionMode,
        whereYouAcquired: whereYouAcquired ?? this.whereYouAcquired,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        acquiredAt: acquiredAt ?? this.acquiredAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a ChemicalAcquisition into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'chemical_acquisition_uid': chemicalAcquisitionUid,
      'user_uid': userUid,
      'chemical_acquisition_mode': acquisitionMode,
      'chemical_acquisition_place': whereYouAcquired,
      'chemical_name': name,
      'chemical_supplier': supplier,
      'chemical_quantity': quantity,
      'chemical_price': price,
      'acquired_at': (acquiredAt != null) ? acquiredAt!.millisecondsSinceEpoch : null,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory ChemicalAcquisition.fromMap(Map<String, dynamic> maps) =>
      ChemicalAcquisition(
        chemicalAcquisitionUid: maps["chemical_acquisition_uid"],
        userUid: maps["user_uid"],
        acquisitionMode: maps["chemical_acquisition_mode"],
        whereYouAcquired: maps["chemical_acquisition_place"],
        name: maps["chemical_name"],
        supplier: maps["chemical_supplier"],
        quantity: maps["chemical_quantity"],
        price: maps["chemical_price"],
        acquiredAt: (maps["acquired_at"] != null)
            ? DateTime.fromMillisecondsSinceEpoch(maps["acquired_at"])
            : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new ChemicalAcquisition instance
  /// from a map. Pass the map to the generated `_$ChemicalAcquisitionFromJson()` constructor.
  /// The constructor is named after the source class, in this case, ChemicalAcquisition.
  factory ChemicalAcquisition.fromJson(Map<String, dynamic> json) =>
      _$ChemicalAcquisitionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ChemicalAcquisitionToJson`.
  Map<String, dynamic> toJson() => _$ChemicalAcquisitionToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);
  static String _stringFromIntNonNullable(int number) => number.toString();

  static int? _stringToIntNullable(String? number) => number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();
  
  static double? _stringToDoubleNullable(String? number) => number == null ? null : double.tryParse(number);
  static String? _stringFromDoubleNullable(double? number) => number?.toString();


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'chemicalAcquisitionUid: $chemicalAcquisitionUid, userUid: $userUid, acquisitionMode: $acquisitionMode, name: $name, supplier: $supplier, quantity: $quantity, price: $price, acquiredAt: $acquiredAt, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncAt: $lastSyncAt, syncStatus: $syncStatus';
  }
}
