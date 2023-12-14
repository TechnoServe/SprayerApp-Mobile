import 'package:json_annotation/json_annotation.dart';

/// This allows the `Plot` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'plot.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class Plot {
  @JsonKey(fromJson: _stringToIntNullable, toJson: _stringFromIntNullable)
  final int? id;

  /// Tell json_serializable that "plot_uid" should be
  /// mapped to this property.
  @JsonKey(
      name: 'plot_uid',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int plotUid;

  /// Tell json_serializable that "farmer_uid" should be
  /// mapped to this property.
  @JsonKey(
      name: 'farmer_uid',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int farmerUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(
      name: 'user_uid',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "name" should be
  /// mapped to this property.
  @JsonKey(name: 'name')
  final String name;

  /// Tell json_serializable that "number_of_trees" should be
  /// mapped to this property.
  @JsonKey(
      name: 'number_of_trees',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int numberOfTrees;

  /// Tell json_serializable that "number_of_trees" should be
  /// mapped to this property.
  @JsonKey(
      name: 'number_of_small_trees',
      fromJson: _stringToIntNullable,
      toJson: _stringFromIntNullable)
  final int? numberOfSmallTrees;

  /// Tell json_serializable that "province" should be
  /// mapped to this property.
  @JsonKey(name: 'plot_type')
  final String? plotType;

  /// Tell json_serializable that "province" should be
  /// mapped to this property.
  @JsonKey(name: 'plot_age')
  final String? plotAge;

  /// Tell json_serializable that "province" should be
  /// mapped to this property.
  @JsonKey(name: 'other_crop')
  final String? otherCrop;

  /// Tell json_serializable that "province" should be
  /// mapped to this property.
  @JsonKey(name: 'declared_area')
  final String? declaredArea;

  /// Tell json_serializable that "province" should be
  /// mapped to this property.
  @JsonKey(name: 'province')
  final String? province;

  /// Tell json_serializable that "district" should be
  /// mapped to this property.
  @JsonKey(name: 'district')
  final String? district;

  /// Tell json_serializable that "administrative_post" should be
  /// mapped to this property.
  @JsonKey(name: 'administrative_post')
  final String? administrativePost;

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
  @JsonKey(
      name: 'sync_status',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int syncStatus;

  const Plot({
    this.id,
    required this.plotUid,
    required this.farmerUid,
    required this.userUid,
    required this.name,
    required this.numberOfTrees,
    this.numberOfSmallTrees,
    this.plotType,
    this.plotAge,
    this.otherCrop,
    this.declaredArea,
    this.province,
    this.district,
    this.administrativePost,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
  });

  Plot copyWith({
    int? plotUid,
    int? farmerUid,
    int? userUid,
    String? name,
    int? numberOfTrees,
    int? numberOfSmallTrees,
    String? plotType,
    String? plotAge,
    String? otherCrop,
    String? declaredArea,
    String? province,
    String? district,
    String? administrativePost,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
  }) =>
      Plot(
        plotUid: plotUid ?? this.plotUid,
        farmerUid: farmerUid ?? this.farmerUid,
        userUid: userUid ?? this.userUid,
        name: name ?? this.name,
        numberOfTrees: numberOfTrees ?? this.numberOfTrees,
        numberOfSmallTrees: numberOfSmallTrees ?? this.numberOfSmallTrees,
        plotType: plotType ?? this.plotType,
        plotAge: plotAge ?? this.plotAge,
        otherCrop: otherCrop ?? this.otherCrop,
        declaredArea: declaredArea ?? this.declaredArea,
        province: province ?? this.province,
        district: district ?? this.district,
        administrativePost: administrativePost ?? this.administrativePost,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  // Convert a Plot into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'plot_uid': plotUid,
      'farmer_uid': farmerUid,
      'user_uid': userUid,
      'name': name,
      'number_of_trees': numberOfTrees,
      'number_of_small_trees': numberOfSmallTrees,
      'other_crop': otherCrop,
      'declared_area': declaredArea,
      'plot_type': plotType,
      'plot_age': plotAge,
      'province': province,
      'district': district,
      'administrative_post': administrativePost,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory Plot.fromMap(Map<String, dynamic> maps) => Plot(
        plotUid: maps['plot_uid'],
        farmerUid: maps['farmer_uid'],
        userUid: maps['user_uid'],
        name: maps['name'],
        numberOfTrees: maps['number_of_trees'],
        numberOfSmallTrees: maps['number_of_small_trees'],
        otherCrop: maps['other_crop'],
        declaredArea: maps['declared_area'],
        plotType: maps['plot_type'],
        plotAge: maps['plot_age'],
        province: maps['province'],
        district: maps['district'],
        administrativePost: maps['administrative_post'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps['updated_at']),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps['last_sync_at']),
        syncStatus: maps['sync_status'],
      );

  /// A necessary factory constructor for creating a new Plot instance
  /// from a map. Pass the map to the generated `_$PlotFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Plot.
  factory Plot.fromJson(Map<String, dynamic> json) => _$PlotFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PlotToJson`.
  Map<String, dynamic> toJson() => _$PlotToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);
  static String _stringFromIntNonNullable(int number) => number.toString();

  static int? _stringToIntNullable(String? number) =>
      number == null ? null : int.tryParse(number);
  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'plot_uid: $plotUid, farmer_uid: $farmerUid, user_uid: $userUid, name: $name, number_of_trees: $numberOfTrees, plot_type: $plotType, province: $province, district: $district, administrative_post: $administrativePost, created_at: ${createdAt.millisecondsSinceEpoch}, updated_at: ${updatedAt.millisecondsSinceEpoch}, last_sync_at: ${lastSyncAt.millisecondsSinceEpoch}, sync_status: $syncStatus';
  }
}
