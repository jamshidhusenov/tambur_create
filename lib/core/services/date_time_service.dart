class DateTimeService {
  /// Convert UTC time to local time
  static DateTime? _convertToLocal(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toLocal();
  }

  /// Format: 09:38
  static String formatTimeOnly(DateTime? dateTime) {
    if (dateTime == null) return '';
    final localTime = _convertToLocal(dateTime);
    return '${localTime?.hour.toString().padLeft(2, '0')}:${localTime?.minute.toString().padLeft(2, '0')}';
  }

  /// Format: 11 Dec, 09:38
  static String formatDayTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final localTime = _convertToLocal(dateTime);
    final months = [
      'Янв',
      'Фев',
      'Мар',
      'Апр',
      'Май',
      'Июн',
      'Июл',
      'Авг',
      'Сен',
      'Окт',
      'Ноя',
      'Дек',
    ];
    return '${localTime?.day} ${months[localTime!.month - 1]}, ${formatTimeOnly(localTime)}';
  }

  static String formatDay(DateTime? dateTime) {
    if (dateTime == null) return '';
    final localTime = _convertToLocal(dateTime);
    final months = [
      'Янв',
      'Фев',
      'Мар',
      'Апр',
      'Май',
      'Июн',
      'Июл',
      'Авг',
      'Сен',
      'Окт',
      'Ноя',
      'Дек',
    ];
    return '${localTime?.day} ${months[localTime!.month - 1]}';
  }

  /// Format: 2024-12-11 09:38
  static String formatFullDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final localTime = _convertToLocal(dateTime);
    return '${localTime?.year}-${localTime?.month.toString().padLeft(2, '0')}-${localTime?.day.toString().padLeft(2, '0')} ${formatTimeOnly(localTime)}';
  }

  /// Returns the difference in minutes between two dates
  static String differenceInMinutes(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return "0 мин";
    final difference = endDate.difference(startDate);
    return "${difference.inMinutes} мин";
  }
}
