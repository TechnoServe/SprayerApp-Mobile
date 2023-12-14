import 'package:json_annotation/json_annotation.dart';

/// This allows the `Application` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'profile.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Profile {
  @JsonKey(fromJson: _stringToInt, toJson: _stringFromInt)
  final int id;
  final String name;
  final String visibility;

  Profile({
    required this.id,
    required this.name,
    required this.visibility,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "visibility": visibility,
    };
  }

   /// A necessary factory constructor for creating a new Profile instance
  /// from a map. Pass the map to the generated `_$ProfileFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Profile.
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

      
 /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ProfileToJson`.
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  static int _stringToInt(String number) => int.parse(number);
  static String _stringFromInt(int number) => number.toString();

  @override
  String toString() {
    return name;
  }   
}
