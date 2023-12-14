import 'package:json_annotation/json_annotation.dart';

/// This allows the `PaymentAggreement` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'payment_agreement.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class PaymentAgreement {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "payment_aggreement_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'payment_aggreement_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int paymentAgreementUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "farmer_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'farmer_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int farmerUid;

  /// Tell json_serializable that "aggreed_payment" should be
  /// mapped to this property.
  @JsonKey(name: 'aggreed_payment', defaultValue: 0.0, fromJson: _stringToDoubleNullable, toJson: _stringFromDoubleNullable)
  final double? aggreedPayment;

  /// Tell json_serializable that "aggreed_payment" should be
  /// mapped to this property.
  @JsonKey(name: 'aggreed_payment_per_small_trees', defaultValue: 0.0, fromJson: _stringToDoubleNullable, toJson: _stringFromDoubleNullable)
  final double? aggreedPaymentPerSmallTrees;

  /// Tell json_serializable that "aggreed_trees_to_spray" should be
  /// mapped to this property.
  @JsonKey(name: 'aggreed_trees_to_spray', defaultValue: 0, fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? aggreedTreesToSpray;

  /// Tell json_serializable that "aggreed_trees_small_to_spray" should be
  /// mapped to this property.
  @JsonKey(name: 'aggreed_trees_small_to_spray', defaultValue: 0, fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? aggreedSmallTreesToSpray;

  /// Tell json_serializable that "payment_type" should be
  /// mapped to this property.
  @JsonKey(name: 'payment_type')
  final String? paymentType;

  /// Tell json_serializable that "number_of_applications" should be
  /// mapped to this property.
  @JsonKey(name: 'number_of_applications', fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? numberOfApplications;

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

  //related attributes for farmer
  final String? farmerName;

  const PaymentAgreement({
    this.id,
    required this.paymentAgreementUid,
    required this.userUid,
    required this.farmerUid,
    this.aggreedPayment,
    this.aggreedPaymentPerSmallTrees,
    this.aggreedTreesToSpray,
    this.aggreedSmallTreesToSpray,
    this.paymentType,
    this.numberOfApplications,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,

    //related attributes
    this.farmerName,
  });

  PaymentAgreement copyWith({
    int? paymentAgreementUid,
    int? farmerUid,
    int? userUid,
    double? aggreedPayment,
    double? aggreedPaymentPerSmallTrees,
    int? aggreedTreesToSpray,
    int? aggreedSmallTreesToSpray,
    String? paymentType,
    int? numberOfApplications,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      PaymentAgreement(
        paymentAgreementUid: paymentAgreementUid ?? this.paymentAgreementUid,
        farmerUid: farmerUid ?? this.farmerUid,
        userUid: userUid ?? this.userUid,
        aggreedPayment: aggreedPayment ?? this.aggreedPayment,
        aggreedPaymentPerSmallTrees: aggreedPaymentPerSmallTrees ?? this.aggreedPaymentPerSmallTrees,
        aggreedTreesToSpray: aggreedTreesToSpray ?? this.aggreedTreesToSpray,
        aggreedSmallTreesToSpray: aggreedSmallTreesToSpray ?? this.aggreedSmallTreesToSpray,
        paymentType: paymentType ?? this.paymentType,
        numberOfApplications: numberOfApplications ?? this.numberOfApplications,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a PaymentAgreement into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'payment_aggreement_uid': paymentAgreementUid,
      'user_uid': userUid,
      'farmer_uid': farmerUid,
      'aggreed_payment': aggreedPayment,
      'aggreed_payment_per_small_trees': aggreedPaymentPerSmallTrees,
      'aggreed_trees_to_spray': aggreedTreesToSpray,
      'aggreed_trees_small_to_spray': aggreedSmallTreesToSpray,
      'payment_type': paymentType,
      'number_of_applications': numberOfApplications,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory PaymentAgreement.fromMap(Map<String, dynamic> maps) =>
      PaymentAgreement(
        paymentAgreementUid: maps["payment_aggreement_uid"],
        farmerUid: maps["farmer_uid"],
        userUid: maps["user_uid"],
        aggreedPayment: maps["aggreed_payment"],
        aggreedPaymentPerSmallTrees: maps["aggreed_payment_per_small_trees"],
        aggreedTreesToSpray: maps["aggreed_trees_to_spray"],
        aggreedSmallTreesToSpray: maps["aggreed_trees_small_to_spray"],
        paymentType: maps["payment_type"],
        numberOfApplications: maps["number_of_applications"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new Payment instance
  /// from a map. Pass the map to the generated `_$PaymentAgreementFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Payment.
  factory PaymentAgreement.fromJson(Map<String, dynamic> json) =>
      _$PaymentAgreementFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PaymentAgreementToJson`.
  Map<String, dynamic> toJson() => _$PaymentAgreementToJson(this);

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
    return '';
  }
}
