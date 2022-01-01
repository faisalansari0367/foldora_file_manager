import 'package:intl/intl.dart';

class DateFormatter {
//   var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
// var inputDate = inputFormat.parse('31/12/2000 23:59'); // <-- dd/MM 24H format
  /// 12/31/2000 11:59 PM <-- MM/dd 12H format
  static final dmytFormat = DateFormat('MM/dd/yyyy hh:mm a');

  static String formatDate(DateTime dt) {
    return dmytFormat.format(dt);
  }

  static String formatDateInDMY(DateTime dt) {
    final formatter = DateFormat('E, LLL, y hh:mm a');
    return formatter.format(dt);
  }
}
