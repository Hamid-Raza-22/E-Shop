import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/empty_state_view.dart';
import '../../../components/review_card.dart';
import '../../../constants.dart';
import '../../../models/review_model.dart';
import '../../../repositories/review_repository.dart';
import '../../../repositories/user_repository.dart';
import 'components/add_review_sheet.dart';
import 'components/user_review_card.dart';

enum ReviewSortOption { mostRecent, highestRating, lowestRating }

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  final ReviewRepository _repository = ReviewRepository.instance;

  ReviewSortOption _sortOption = ReviewSortOption.mostRecent;

  static const Map<ReviewSortOption, String> _sortLabels = {
    ReviewSortOption.mostRecent: "Most recent",
    ReviewSortOption.highestRating: "Highest rating",
    ReviewSortOption.lowestRating: "Lowest rating",
  };

  List<ReviewModel> _sortedReviews() {
    final reviews = [..._repository.reviews];
    switch (_sortOption) {
      case ReviewSortOption.mostRecent:
        reviews.sort((a, b) => b.date.compareTo(a.date));
      case ReviewSortOption.highestRating:
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
      case ReviewSortOption.lowestRating:
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
    }
    return reviews;
  }

  Future<void> _openAddReview() async {
    final result = await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.9,
      child: const AddReviewSheet(),
    );

    if (result is! AddReviewResult || !mounted) return;

    _repository.add(
      userName: UserRepository.instance.user.name,
      rating: result.rating,
      review: result.review,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thanks! Your review has been added")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reviews")),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _repository,
          builder: (context, _) {
            final summary = _repository.summary;
            final reviews = _sortedReviews();

            return ListView(
              padding: const EdgeInsets.only(bottom: defaultPadding),
              children: [
                if (summary.total > 0)
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: ReviewCard(
                      rating: summary.average,
                      numOfReviews: summary.total,
                      numOfFiveStar: summary.countFor(5),
                      numOfFourStar: summary.countFor(4),
                      numOfThreeStar: summary.countFor(3),
                      numOfTwoStar: summary.countFor(2),
                      numOfOneStar: summary.countFor(1),
                    ),
                  ),
                const Divider(height: 1),
                ListTile(
                  onTap: _openAddReview,
                  minLeadingWidth: 24,
                  leading: SvgPicture.asset(
                    "assets/icons/Chat-add.svg",
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyLarge!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: const Text("Add Review"),
                  trailing: SvgPicture.asset(
                    "assets/icons/miniRight.svg",
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).dividerColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Divider(height: 1),
                if (reviews.isEmpty)
                  EmptyStateView(
                    title: "No reviews yet",
                    description:
                        "Be the first to share what you think about this product.",
                    actionLabel: "Add review",
                    onAction: _openAddReview,
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "User reviews",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        PopupMenuButton<ReviewSortOption>(
                          initialValue: _sortOption,
                          onSelected: (value) =>
                              setState(() => _sortOption = value),
                          itemBuilder: (context) => _sortLabels.entries
                              .map((entry) => PopupMenuItem(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          child: Row(
                            children: [
                              Text(_sortLabels[_sortOption]!),
                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...reviews.map(
                    (review) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      child: UserReviewCard(review: review),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
