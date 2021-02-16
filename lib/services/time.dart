// Packages:
import 'package:intl/intl.dart';

class TimeHelper {
  DateTime getLocalTimeFromSecondsSinceEpoch(timeSinceEpochInSec) {
    final dateUtc = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000, isUtc: true);
    return dateUtc.toLocal();
  }

  DateTime getCurrentTimeUpToHour() {
    DateTime now = new DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour);
  }

  DateTime getTimeUpToHour({DateTime time}) {
    return DateTime(time.year, time.month, time.day, time.hour);
  }

  String getFormattedDateTime(time) {
    // return DateFormat('hh:mm a').format(time).toLowerCase();
    return DateFormat('ha').format(time).toLowerCase();
  }
}