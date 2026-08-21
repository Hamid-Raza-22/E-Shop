import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import '../../../../controllers/user_controller.dart';
import 'review_product_card.dart';

/// Result returned by [AddReviewSheet].
class AddReviewResult {
  const AddReviewResult({required this.rating, required this.review});

  final double rating;
  final String review;
}

/// Add-review bottom sheet: star rating + review text with validation.
class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({super.key, this.onSubmit});

  /// Called with the validated result. Defaults to popping the route with the
  /// result (bottom-sheet usage); the full-screen route passes its own handler.
  final ValueChanged<AddReviewResult>? onSubmit;

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();

  static const int _minReviewLength = 10;

  double _rating = 0;
  bool _showRatingError = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final isRatingValid = _rating > 0;

    setState(() => _showRatingError = !isRatingValid);
    if (!isFormValid || !isRatingValid) return;

    final result = AddReviewResult(
      rating: _rating,
      review: _reviewController.text.trim(),
    );

    final onSubmit = widget.onSubmit;
    if (onSubmit != null) {
      onSubmit(result);
      return;
    }
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Add review"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(defaultPadding),
              children: [
                const ReviewProductInfoCard(
                  image: productDemoImg2,
                  title: "Sleeveless Ruffle",
                  brand: "Lipsy london",
                ),
                const Divider(height: defaultPadding * 2),
                Text(
                  "How would you rate it?",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: defaultPadding),
                Center(
                  child: RatingBar.builder(
                    initialRating: _rating,
                    itemSize: 40,
                    itemPadding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding / 4),
                    unratedColor: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withValues(alpha: 0.08),
                    glow: false,
                    allowHalfRating: true,
                    onRatingUpdate: (value) => setState(() {
                      _rating = value;
                      _showRatingError = false;
                    }),
                    itemBuilder: (context, index) =>
                        SvgPicture.asset("assets/icons/Star_filled.svg"),
                  ),
                ),
                if (_showRatingError)
                  Padding(
                    padding: const EdgeInsets.only(top: defaultPadding / 2),
                    child: Center(
                      child: Text(
                        "Please select a rating",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: errorColor),
                      ),
                    ),
                  ),
                const SizedBox(height: defaultPadding * 1.5),
                Text(
                  "Write your review",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _reviewController,
                  maxLines: 5,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: "Tell others what you think about this product",
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    final text = (value ?? "").trim();
                    if (text.isEmpty) return "Review is required";
                    if (text.length < _minReviewLength) {
                      return "Please write at least $_minReviewLength characters";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton(
              onPressed: _submit,
              child: Text("Submit as ${UserController.to.user.name}"),
            ),
          ),
        ),
      ],
    );
  }
}
