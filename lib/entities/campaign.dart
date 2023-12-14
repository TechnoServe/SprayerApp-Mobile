import 'package:json_annotation/json_annotation.dart';

/// This allows the `Application` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'campaign.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Campaign {
  @JsonKey(fromJson: _stringToInt, toJson: _stringFromInt)
  final int id;

  /// Tell json_serializable that "created_at" should be
  /// mapped to this property.
  @JsonKey(name: 'opening')
  final DateTime opening;

  /// Tell json_serializable that "created_at" should be
  /// mapped to this property.
  @JsonKey(name: 'clossing')
  final DateTime closing;

  /// Tell json_serializable that "created_at" should be
  /// mapped to this property.
  @JsonKey(name: 'description')
  final String? description;

  /// Tell json_serializable that "created_at" should be
  /// mapped to this property.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Tell json_serializable that "updated_at" should be
  /// mapped to this property.
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Tell json_serializable that "updated_at" should be
  /// mapped to this property.
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  /// Tell json_serializable that "last_sync_at" should be
  /// mapped to this property.
  @JsonKey(name: 'last_sync_at')
  final DateTime? lastSyncAt;

  Campaign({
    required this.id,
    required this.opening,
    required this.closing,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.lastSyncAt,
  });

 factory Campaign.init() {
    return Campaign(id: 0, opening: DateTime.now(), closing: DateTime.now(), description: null, createdAt: DateTime.now(), updatedAt: DateTime.now(),);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "opening": opening.millisecondsSinceEpoch,
      "closing": closing.millisecondsSinceEpoch,
      "description": description,
      "created_at": createdAt.millisecondsSinceEpoch,
      "updated_at": updatedAt.millisecondsSinceEpoch,
      "deleted_at": deletedAt,
      "last_sync_at": lastSyncAt,
    };
  }

   /// A necessary factory constructor for creating a new Profile instance
  /// from a map. Pass the map to the generated `_$ProfileFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Profile.
  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);

      
 /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ProfileToJson`.
  Map<String, dynamic> toJson() => _$CampaignToJson(this);

  static int _stringToInt(String number) => int.parse(number);
  static String _stringFromInt(int number) => number.toString();


  @override
  String toString() {
    return 'opening: $opening, closing: $closing, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, lastSyncAt: $lastSyncAt';
  }   
}
