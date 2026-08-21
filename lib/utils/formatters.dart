import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../config/app_env.dart';

/// Locale currently driving formatting, e.g. "de" or "en".
///
/// Falls back to the `.env` default before `GetMaterialApp` is built (unit
/// tests, background isolates) so formatting never throws.
String get _localeName => Get.locale?.toLanguageTag() ?? AppEnv.defaultLocale;

/// Money, formatted for the active locale — "$1,240.50" in en, "1.240,50 $" in
/// de. The currency itself comes from `CURRENCY_CODE` in `.env`.
String formatPrice(double value) {
  return NumberFormat.simpleCurrency(
    locale: _localeName,
    name: AppEnv.currencyCode,
  ).format(value);
}

/// Compact money for dense dashboard widgets: "$12.4K", "$1.2M".
String formatCompactPrice(double value) {
  return NumberFormat.compactSimpleCurrency(
    locale: _localeName,
    name: AppEnv.currencyCode,
  ).format(value);
}

String formatNumber(num value) =>
    NumberFormat.decimalPattern(_localeName).format(value);

/// e.g. "12 Aug 2026" in en, "12.08.2026" in de.
String formatDate(DateTime date) =>
    DateFormat.yMMMd(_localeName).format(date);

/// Day + month only, used for chart axis labels.
String formatShortDate(DateTime date) =>
    DateFormat.MEd(_localeName).format(date);

String formatDateTime(DateTime date) =>
    DateFormat.yMMMd(_localeName).add_Hm().format(date);

/// Short relative label used in the notification list, e.g. "5h ago".
///
/// Kept deliberately terse; anything older than a week falls back to the
/// localised absolute date.
String formatTimeAgo(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inMinutes < 1) return "Just now";
  if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
  if (difference.inHours < 24) return "${difference.inHours}h ago";
  if (difference.inDays < 7) return "${difference.inDays}d ago";
  return formatDate(date);
}
