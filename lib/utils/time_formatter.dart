import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

String formatTimeAgo(dynamic dateTime) {
  final now = DateTime.now();

  // Convert input to DateTime if it's a String
  final date = dateTime is String ? DateTime.parse(dateTime) : dateTime as DateTime;
  final difference = now.difference(date);

  // For times less than 60 minutes ago, use timeago
  if (difference.inMinutes < 60) {
    return timeago.format(date, locale: 'ro');
  }

  // For same day (between 1 hour and 23:59)
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'astăzi la ${DateFormat('HH:mm').format(date)}';
  }

  // For yesterday
  final yesterday = now.subtract(const Duration(days: 1));
  if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
    return 'ieri la ${DateFormat('HH:mm').format(date)}';
  }

  // For older dates
  return '${DateFormat('dd.MM.yyyy').format(date)} la ${DateFormat('HH:mm').format(date)}';
}
// Usage example:
// Text(formatTimeAgo(quiz['time'])),
