import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat short = DateFormat('dd MMM yyyy');

  static String format(DateTime date) => short.format(date);
}

