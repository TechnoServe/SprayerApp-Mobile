import 'package:json_annotation/json_annotation.dart';

/// This allows the `Application` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'payment.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class Payment {
  final int? id;

  /// Tell json_serializable that "payment_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'payment_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int paymentUid;

  /// Tell json_serializable that "farmer_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'farmer_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int farmerUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "paid" should be
  /// mapped to this property.
  @JsonKey(name: 'paid', defaultValue: 0.0, fromJson: _stringToDoubleNullable, toJson: _stringFromDoubleNullable)
  final double? paid;

  /// Tell json_serializable that "discount" should be
  /// mapped to this property.
  @JsonKey(name: 'discount', defaultValue: 0.0, fromJson: _stringToDoubleNullable, toJson: _stringFromDoubleNullable)
  final double? discount;

  /// Tell json_serializable that "description" should be
  /// mapped to this property.
  @JsonKey(name: 'description')
  final String? description;

  /// Tell json_serializable that "payment_type" should be
  /// mapped to this property.
  @JsonKey(name: 'payment_type')
  final String? paymentType;

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

  const Payment({
    this.id,
    required this.paymentUid,
    required this.farmerUid,
    required this.userUid,
    this.paid,
    this.discount,
    this.description,
    this.paymentType,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
  });

  Payment copyWith({
    int? paymentUid,
    int? farmerUid,
    int? userUid,
    double? paid,
    double? discount,
    String? description,
    String? paymentType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      Payment(
        paymentUid: paymentUid ?? this.paymentUid,
        farmerUid: farmerUid ?? this.farmerUid,
        userUid: userUid ?? this.userUid,
        paid: paid ?? this.paid,
        discount: discount ?? this.discount,
        description: description ?? this.description,
        paymentType: paymentType ?? this.paymentType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a Payment into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'payment_uid': paymentUid,
      'farmer_uid': farmerUid,
      'user_uid': userUid,
      'paid': paid,
      'discount': discount,
      'description': description,
      'payment_type': paymentType,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory Payment.fromMap(Map<String, dynamic> maps) => Payment(
        paymentUid: maps["payment_uid"],
        farmerUid: maps["farmer_uid"],
        userUid: maps["user_uid"],
        paid: maps["paid"],
        discount: maps["discount"] ?? 0.0,
        description: maps["description"],
        paymentType: maps["payment_type"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new Payment instance
  /// from a map. Pass the map to the generated `_$PaymentFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Payment.
  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PaymentToJson`.
  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);
  static String _stringFromIntNonNullable(int number) => number.toString();

  static double _stringToDoubleNonNullable(String number) => double.parse(number);
  static String _stringFromDoubleNonNullable(double number) => number.toString();

  static int? _stringToIntNullable(String? number) => number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();

  static double? _stringToDoubleNullable(String? number) => number == null ? null : double.tryParse(number);
  static String? _stringFromDoubleNullable(double? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return '';
  }
}
