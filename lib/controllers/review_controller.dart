import 'dart:async';

import 'package:get/get.dart';

import '../models/review_model.dart';
import '../services/review_service.dart';
import '../utils/service_locator.dart';

/// Reviews for the product currently being viewed.
///
/// [bindProduct] points the list at one product's approved reviews in Firestore,
/// so what the shopper reads is exactly what the dashboard has approved. Without
/// Firestore (tests, offline) the bundled demo reviews are used instead.
class ReviewController extends GetxController {
  ReviewController({ReviewService? service}) : _injected = service {
    _seedDemoReviews();
  }

  static ReviewController get to => Get.find<ReviewController>();

  final ReviewService? _injected;

  ReviewService? get _service => _injected ?? serviceOrNull<ReviewService>();

  final List<ReviewModel> _reviews = [];
  StreamSubscription<List<ModeratedReview>>? _subscription;
  String? _productId;
  int _sequence = 0;

  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  bool get isEmpty => _reviews.isEmpty;

  /// True when a new review has to be approved before it becomes visible.
  bool get requiresApproval => _service != null;

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

  /// The product whose reviews are currently loaded.
  String? get productId => _productId;

  /// Loads the approved reviews of [productId]. Passing null (or a product that
  /// has no Firestore id yet) restores the demo reviews.
  void bindProduct(String? productId) {
    if (_productId == productId && (productId == null) == (_subscription == null)) {
      return;
    }
    _productId = productId;
    _subscription?.cancel();
    _subscription = null;

    final service = _service;
    if (productId == null || service == null) {
      _reviews.clear();
      _seedDemoReviews();
      update();
      return;
    }

    _reviews.clear();
    update();
    _subscription =
        service.watchApprovedForProduct(productId).listen((moderated) {
      _reviews
        ..clear()
        ..addAll(moderated.map((review) => ReviewModel(
              id: review.id ?? "",
              userName: review.userName,
              rating: review.rating,
              review: review.review,
              date: review.createdAt ?? DateTime.now(),
            )));
      update();
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// Submits a review. Returns false when the write failed.
  ///
  /// Firestore reviews start unapproved, so they only reach the storefront once
  /// the dashboard approves them — [requiresApproval] tells callers which
  /// message to show.
  Future<bool> add({
    required String userName,
    required double rating,
    required String review,
  }) async {
    final service = _service;
    final productId = _productId;

    if (service != null && productId != null) {
      try {
        await service.create(
          ModeratedReview(
            productId: productId,
            userName: userName,
            rating: rating,
            review: review,
            createdAt: DateTime.now(),
          ),
        );
        return true;
      } catch (_) {
        return false;
      }
    }

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
    return true;
  }

  void _seedDemoReviews() {
    _sequence = 0;
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
