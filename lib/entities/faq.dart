import 'package:json_annotation/json_annotation.dart';

/// This allows the `Equipment` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'faq.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class FAQ {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "name" should be
  /// mapped to this property.
  @JsonKey(name: 'title')
  final String title;

  /// Tell json_serializable that "model" should be
  /// mapped to this property.
  @JsonKey(name: 'description')
  final String description;

  /// Tell json_serializable that "created_at" should be
  /// mapped to this property.
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Tell json_serializable that "updated_at" should be
  /// mapped to this property.
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Tell json_serializable that "deleted_at" should be
  /// mapped to this property.
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  const FAQ({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  FAQ copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      FAQ(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  // Convert a Equipment into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory FAQ.fromMap(Map<String, dynamic> maps) => FAQ(
        id: maps["id"],
        title: maps["title"],
        description: maps["description"],
      );

  /// A necessary factory constructor for creating a new Equipment instance
  /// from a map. Pass the map to the generated `_$EquipmentFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Equipment.
  factory FAQ.fromJson(Map<String, dynamic> json) =>
      _$FAQFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$EquipmentToJson`.
  Map<String, dynamic> toJson() => _$FAQToJson(this);

  static int? _stringToIntNullable(String? number) => number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each equipment when using the print statement.
  @override
  String toString() {
    return '';
  }
}
