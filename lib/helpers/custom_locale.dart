
import 'package:timeago/timeago.dart';

// my_custom_messages.dart
class MyCustomMessages implements LookupMessages {
  @override String prefixAgo() => '';
  @override String prefixFromNow() => '';
  @override String suffixAgo() => '';
  @override String suffixFromNow() => '';
  @override String lessThanOneMinute(int seconds) => 'agora';
  @override String aboutAMinute(int minutes) => '$minutes minuto(s)';
  @override String minutes(int minutes) => '$minutes minuto(s)';
  @override String aboutAnHour(int minutes) => '$minutes minuto(s)';
  @override String hours(int hours) => '$hours hora(s)';
  @override String aDay(int hours) => '$hours hora(s)';
  @override String days(int days) => '$days dia(s)';
  @override String aboutAMonth(int days) => '$days dia(s)';
  @override String months(int months) => '$months mes(es)';
  @override String aboutAYear(int year) => '$year ano(s)';
  @override String years(int years) => '$years ano(s)';
  @override String wordSeparator() => ' ';
}