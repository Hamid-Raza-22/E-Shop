import 'package:flutter/material.dart';

import '../../../controllers/review_controller.dart';
import '../../../controllers/user_controller.dart';
import 'components/add_review_sheet.dart';

/// Feedback for a submitted review.
///
/// A Firestore review waits for moderation, so promising it is already visible
/// would be a lie.
String reviewSubmittedMessage(bool saved, ReviewController reviews) {
  if (!saved) return "We could not save your review. Please try again.";
  return reviews.requiresApproval
      ? "Thanks! Your review will appear once it is approved"
      : "Thanks! Your review has been added";
}

/// Full-screen add-review route.
///
/// Reuses [AddReviewSheet] and just handles the result, so the rating/validation
/// logic lives in one place.
class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key, this.productId});

  /// Product being reviewed. Null keeps whatever product the controller is
  /// already bound to.
  final String? productId;

  Future<void> _save(BuildContext context, AddReviewResult result) async {
    final reviews = ReviewController.to;
    if (productId != null) reviews.bindProduct(productId);

    final saved = await reviews.add(
      userName: UserController.to.user.name,
      rating: result.rating,
      review: result.review,
    );
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(reviewSubmittedMessage(saved, reviews))),
    );
    if (saved) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AddReviewSheet(
          onSubmit: (result) => _save(context, result),
        ),
      ),
    );
  }
}
