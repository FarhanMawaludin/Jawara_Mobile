class DateFormatter {
  DateFormatter._();

  static const List<String> _monthsIndo = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  static String formatDate(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';
    
    try {
      return '${date.day} ${_monthsIndo[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';
    
    try {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '${date.day} ${_monthsIndo[date.month - 1]} ${date.year}, $hour:$minute';
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }

  static String formatTimeAgo(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}