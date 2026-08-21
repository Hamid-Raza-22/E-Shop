import 'package:get/get.dart';

import '../models/review_model.dart';

/// In-memory review list.
///
/// Reviews are global for this demo because the UI kit has a single product
/// details flow. When an API is added, [reviews] should take a productId.
class ReviewController extends GetxController {
  ReviewController() {
    _seedDemoReviews();
  }

  static ReviewController get to => Get.find<ReviewController>();

  final List<ReviewModel> _reviews = [];
  int _sequence = 0;

  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  bool get isEmpty => _reviews.isEmpty;

  ReviewSummary get summary {
    if (_reviews.isEmpty) {
      return const ReviewSummary(average: 0, total: 0, starCounts: {});
    }

    final starCounts = <int, int>{};
    var ratingSum = 0.0;
    for (final review in _reviews) {
      ratingSum += review.rating;
      final star = review.rating.round().clamp(1, 5);
      starCounts[star] = (starCounts[star] ?? 0) + 1;
    }

    return ReviewSummary(
      average: double.parse((ratingSum / _reviews.length).toStringAsFixed(1)),
      total: _reviews.length,
      starCounts: starCounts,
    );
  }

  void add({
    required String userName,
    required double rating,
    required String review,
  }) {
    _sequence++;
    _reviews.insert(
      0,
      ReviewModel(
        id: "review_$_sequence",
        userName: userName,
        rating: rating,
        review: review,
        date: DateTime.now(),
      ),
    );
    update();
  }

  void _seedDemoReviews() {
    final now = DateTime.now();
    final seed = [
      ("Nicolas Cage", 5.0, "Perfect fit and the fabric feels premium. Would buy again."),
      ("Sepide Moqadam", 4.0, "Lovely colour, but the sleeves run slightly long for me."),
      ("Robert Fox", 5.0, "Shipped fast and looks exactly like the photos."),
      ("Jenny Wilson", 3.0, "Decent quality for the price, though it wrinkles easily."),
      ("Devon Lane", 4.5, "Great everyday piece. Washed twice with no colour loss."),
    ];

    for (var i = 0; i < seed.length; i++) {
      _sequence++;
      _reviews.add(ReviewModel(
        id: "review_$_sequence",
        userName: seed[i].$1,
        rating: seed[i].$2,
        review: seed[i].$3,
        date: now.subtract(Duration(days: (i + 1) * 3)),
      ));
    }
  }
}
