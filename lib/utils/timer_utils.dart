class TimerUtils {
  static String parse(dynamic time) {
    if (time == null) return '';
    int timestamp = (time is int) ? time : int.tryParse(time) ?? 0;
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    final duration = DateTime.now().difference(dateTime);

    if (duration.inDays >= 365) {
      return '${(duration.inDays / 365).floor()} years ago';
    } else if (duration.inDays >= 30) {
      return '${(duration.inDays / 30).floor()} months ago';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours} hours ago';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  static String parseDate(dynamic time) {
    if (time == null) return '';
    int timestamp = (time is int) ? time : int.tryParse(time) ?? 0;
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();

    return '${dateTime.day} ${_month(dateTime.month)} ${dateTime.year}';
  }

  static String _month(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
