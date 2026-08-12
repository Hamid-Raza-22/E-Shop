const List<String> _monthNames = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

/// e.g. "12 Aug, 2026".
///
/// Written by hand because `intl` is not a dependency of this project.
String formatDate(DateTime date) =>
    "${date.day} ${_monthNames[date.month - 1]}, ${date.year}";

/// Short relative label used in the notification list, e.g. "5h ago".
String formatTimeAgo(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inMinutes < 1) return "Just now";
  if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
  if (difference.inHours < 24) return "${difference.inHours}h ago";
  if (difference.inDays < 7) return "${difference.inDays}d ago";
  return formatDate(date);
}

/// Money is always shown with two decimals across the app.
String formatPrice(double value) => "\$${value.toStringAsFixed(2)}";
