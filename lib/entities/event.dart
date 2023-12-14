import 'package:json_annotation/json_annotation.dart';

/// This allows the `Event` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'event.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(ignoreUnannotated: true)
class Event {
  final int? id;

  /// Tell json_serializable that "equipments_uid" should be
  /// mapped to this property.
  @JsonKey(
      name: 'event_uid',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int eventUid;

  /// Tell json_serializable that "user_uid" should be
  /// mapped to this property.
  @JsonKey(
      name: 'user_uid',
      fromJson: _stringToIntNonNullable,
      toJson: _stringFromIntNonNullable)
  final int userUid;

  /// Tell json_serializable that "name" should be
  /// mapped to this property.
  @JsonKey(name: 'event')
  final String name;

  /// Tell json_serializable that "name" should be
  /// mapped to this property.
  @JsonKey(name: 'event_type')
  final String eventType;

  /// Tell json_serializable that "fromDate" should be
  /// mapped to this property.
  @JsonKey(name: 'from_date')
  final DateTime fromDate;

  /// Tell json_serializable that "toDate" should be
  /// mapped to this property.
  @JsonKey(name: 'to_date')
  final DateTime toDate;

  /// Tell json_serializable that "backgroundColor" should be
  /// mapped to this property.
  @JsonKey(name: 'background_color')
  final String? backgroundColor;

  /// Tell json_serializable that "isAllDay" should be
  /// mapped to this property.
  @JsonKey(
      name: 'is_all_day',
      defaultValue: 0,
      fromJson: _stringToIntNullable,
      toJson: _stringFromIntNullable)
  final int? isAllDay;

  /// Tell json_serializable that "status" should be
  /// mapped to this property.
  @JsonKey(
      name: 'status',
      defaultValue: 0,
      fromJson: _stringToIntNullable,
      toJson: _stringFromIntNullable)
  final int? status;

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

  final int? numberOfParticipants;
  final int? numberOfTress;

  const Event({
    this.id,
    required this.eventUid,
    required this.userUid,
    required this.name,
    required this.eventType,
    required this.fromDate,
    required this.toDate,
    this.backgroundColor = "Colors.lightGreen",
    this.isAllDay = 0,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSyncAt,
    required this.syncStatus,
    this.numberOfParticipants,
    this.numberOfTress,
  });

  Event copyWith({
    int? id,
    int? eventUid,
    int? userUid,
    String? name,
    String? eventType,
    DateTime? fromDate,
    DateTime? toDate,
    String? backgroundColor,
    int? isAllDay,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? syncStatus,
    int? numberOfParticipants,
    int? numberOfTress,
  }) =>
      Event(
        eventUid: eventUid ?? this.eventUid,
        userUid: userUid ?? this.userUid,
        name: name ?? this.name,
        eventType: eventType ?? this.eventType,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        isAllDay: isAllDay ?? this.isAllDay,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        syncStatus: syncStatus ?? this.syncStatus,
        numberOfParticipants: numberOfParticipants ?? this.numberOfParticipants,
        numberOfTress: numberOfTress ?? this.numberOfTress,
      );

  // Convert a Event into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'event_uid': eventUid,
      'user_uid': userUid,
      'event': name,
      'event_type': eventType,
      'from_date': fromDate.millisecondsSinceEpoch,
      'to_date': toDate.millisecondsSinceEpoch,
      'background_color': backgroundColor,
      'is_all_day': isAllDay,
      'status': status,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'last_sync_at': lastSyncAt.millisecondsSinceEpoch,
      'sync_status': syncStatus
    };
  }

  factory Event.fromMap(Map<String, dynamic> maps) => Event(
        eventUid: maps["event_uid"],
        userUid: maps["user_uid"],
        name: maps["event"],
        eventType: maps["event_type"],
        fromDate: DateTime.fromMillisecondsSinceEpoch(maps["from_date"]),
        toDate: DateTime.fromMillisecondsSinceEpoch(maps["to_date"]),
        backgroundColor: maps["background_color"],
        isAllDay: maps["is_all_day"],
        status: maps["status"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(maps["created_at"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(maps["updated_at"]),
        lastSyncAt: DateTime.fromMillisecondsSinceEpoch(maps["last_sync_at"]),
        syncStatus: maps["sync_status"],
        numberOfParticipants: maps["number_of_participants"],
      );

  /// A necessary factory constructor for creating a new Event instance
  /// from a map. Pass the map to the generated `_$EventFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Event.
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$EventToJson`.
  Map<String, dynamic> toJson() => _$EventToJson(this);

  static int _stringToIntNonNullable(String number) => int.parse(number);

  static String _stringFromIntNonNullable(int number) => number.toString();

  static int? _stringToIntNullable(String? number) =>
      number == null ? null : int.tryParse(number);

  static String? _stringFromIntNullable(int? number) => number?.toString();

  // Implement toString to make it easier to see information about
  // each event when using the print statement.
  @override
  String toString() {
    return 'eventUid: $eventUid, userUid: $userUid, name: $name, fromDate: $fromDate, toDate: $toDate, backgroundColor: $backgroundColor, isAllDay: $isAllDay, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncAt: $lastSyncAt, syncStatus: $syncStatus';
  }
}
