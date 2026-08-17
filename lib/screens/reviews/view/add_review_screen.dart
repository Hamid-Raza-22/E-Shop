import 'package:flutter/material.dart';

import '../../../repositories/review_repository.dart';
import '../../../repositories/user_repository.dart';
import 'components/add_review_sheet.dart';

/// Full-screen add-review route.
///
/// Reuses [AddReviewSheet] and just handles the result, so the rating/validation
/// logic lives in one place.
class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key});

  void _save(BuildContext context, AddReviewResult result) {
    ReviewRepository.instance.add(
      userName: UserRepository.instance.user.name,
      rating: result.rating,
      review: result.review,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thanks! Your review has been added")),
    );
    Navigator.pop(context);
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
