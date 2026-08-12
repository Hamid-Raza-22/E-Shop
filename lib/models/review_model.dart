class ReviewModel {
  ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.review,
    required this.date,
  });

  final String id;
  final String userName, review;
  final double rating;
  final DateTime date;
}

/// Aggregated rating breakdown used by the existing [ReviewCard] component.
class ReviewSummary {
  const ReviewSummary({
    required this.average,
    required this.total,
    required this.starCounts,
  });

  final double average;
  final int total;

  /// Keyed by star value (1-5).
  final Map<int, int> starCounts;

  int countFor(int star) => starCounts[star] ?? 0;
}
