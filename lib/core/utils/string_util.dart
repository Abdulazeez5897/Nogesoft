

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text; // Return the same if empty
  return text[0].toUpperCase() + text.substring(1);
}

String formatDate(dynamic date) {
  if (date == null) return "N/A"; // Handle null values
  if (date is String) {
    try {
      DateTime parsedDate = DateTime.parse(date).toLocal();
      return DateFormat("dd MMM, yyyy").format(parsedDate); // Example: 12 Mar, 2024
    } catch (e) {
      return "Invalid Date";
    }
  } else if (date is DateTime) {
    return DateFormat("dd MMM, yyyy").format(date);
  }
  return "N/A"; // Default fallback
}

String formatDateTime(dynamic datetime){
  if (datetime == null) return "N/A"; // Handle null values
  if (datetime is String) {
    try {
      DateTime parsedDate = DateTime.parse(datetime).toLocal();
      return DateFormat("dd MMM, yyyy HH:mm").format(parsedDate); // Example: 12 Mar, 2024 14:30
    } catch (e) {
      return "Invalid Date";
    }
  } else if (datetime is DateTime) {
    return DateFormat("dd MMM, yyyy HH:mm").format(datetime);
  }
  return "N/A"; // Default fallback
}

String timeAgoFromTimestamp(Timestamp timestamp) {
  final now = DateTime.now();
  final postDate = timestamp.toDate();
  final diff = now.difference(postDate);

  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min${diff.inMinutes == 1 ? '' : 's'} ago';
  if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} week${(diff.inDays / 7).floor() == 1 ? '' : 's'} ago';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() == 1 ? '' : 's'} ago';
  return '${(diff.inDays / 365).floor()} year${(diff.inDays / 365).floor() == 1 ? '' : 's'} ago';
}


