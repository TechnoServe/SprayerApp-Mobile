import 'package:json_annotation/json_annotation.dart';

/// This allows the `ExpensesIncome` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'expenses_income.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class ExpensesIncome {
  final int? id;

  /// Tell json_serializable that "expenses_income_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'expenses_income_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int expensesIncomeUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(name: 'user_uid', fromJson: _stringToIntNonNullable, toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "category" should be
  /// mapped to this property.
  @JsonKey(name: 'category')
  final String category;

  /// Tell json_serializable that "price" should be
  /// mapped to this property.
  @JsonKey(name: 'price', fromJson: _stringToDoubleNullable, toJson: _stringFromDoubleNullable)
  final double? price;

  /// Tell json_serializable that "description" should be
  /// mapped to this property.
  @JsonKey(name: 'description')
  final String? description;

  /// Tell json_serializable that "expenses_income_type" should be
  /// mapped to this property.
  @JsonKey(name: 'expenses_income_type')
  final String? expensesIncomeType;

  /// Tell json_serializable that "expenses_income_payment_type" should be
  /// mapped to this property.
  @JsonKey(name: 'expenses_income_payment_type')
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

  const ExpensesIncome({
    this.id,
    required this.expensesIncomeUid,
    required this.userUid,
    required this.category,
    this.price,
    this.description,
    this.expensesIncomeType,
    this.paymentType,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
    chemicalAppliactionUid,
  });

  ExpensesIncome copyWith({
    int? expensesIncomeUid,
    int? userUid,
    String? category,
    double? price,
    String? description,
    String? expensesIncomeType,
    String? paymentType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      ExpensesIncome(
        expensesIncomeUid: expensesIncomeUid ?? this.expensesIncomeUid,
        userUid: userUid ?? this.userUid,
        category: category ?? this.category,
        price: price ?? this.price,
        description: description ?? this.description,
        expensesIncomeType: expensesIncomeType ?? this.expensesIncomeType,
        paymentType: paymentType ?? this.paymentType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a ExpensesIncome into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'expenses_income_uid': expensesIncomeUid,
      'user_uid': userUid,
      'category': category,
      'price': price,
      'description': description,
      'expenses_income_type': expensesIncomeType,
      'expenses_income_payment_type': paymentType,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory ExpensesIncome.fromMap(Map<String, dynamic> maps) => ExpensesIncome(
        expensesIncomeUid: maps["expenses_income_uid"],
        userUid: maps["user_uid"],
        category: maps["category"],
        price: maps["price"],
        description: maps["description"],
        expensesIncomeType: maps["expenses_income_type"],
        paymentType: maps["expenses_income_payment_type"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
      );

  /// A necessary factory constructor for creating a new Payment instance
  /// from a map. Pass the map to the generated `_$ExpensesIncomeFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Payment.
  factory ExpensesIncome.fromJson(Map<String, dynamic> json) =>
      _$ExpensesIncomeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ExpensesIncomeToJson`.
  Map<String, dynamic> toJson() => _$ExpensesIncomeToJson(this);

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
