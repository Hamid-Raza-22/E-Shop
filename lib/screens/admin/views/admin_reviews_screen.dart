import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/admin/admin_reviews_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/review_service.dart';
import '../../../utils/formatters.dart';

/// Moderation queue: approve, unapprove or delete customer reviews.
class AdminReviewsScreen extends StatelessWidget {
  const AdminReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminReviewsController.to;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Obx(
            () => SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: true,
                  label: Text(
                    "${translations.adminReviewsPending}"
                    " (${controller.pendingCount})",
                  ),
                ),
                ButtonSegment(value: false, label: Text(translations.labelAll)),
              ],
              selected: {controller.pendingOnly},
              onSelectionChanged: (selection) =>
                  controller.setPendingOnly(selection.first),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final reviews = controller.reviews;

            if (reviews.isEmpty) {
              return Center(child: Text(translations.adminReviewNone));
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                defaultPadding,
                0,
                defaultPadding,
                defaultPadding,
              ),
              itemCount: reviews.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: defaultPadding / 2),
              itemBuilder: (context, index) =>
                  _ReviewTile(review: reviews[index]),
            );
          }),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ModeratedReview review;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminReviewsController.to;

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Row(
                children: [
                  for (var star = 1; star <= 5; star++)
                    Icon(
                      star <= review.rating.round()
                          ? Icons.star
                          : Icons.star_border,
                      size: 14,
                      color: warningColor,
                    ),
                ],
              ),
            ],
          ),
          if (review.createdAt != null)
            Text(
              formatDate(review.createdAt!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          const SizedBox(height: defaultPadding / 2),
          Text(review.review),
          const SizedBox(height: defaultPadding / 2),
          Row(
            children: [
              if (!review.isApproved)
                TextButton.icon(
                  onPressed: () => controller.approve(review),
                  icon: const Icon(Icons.check, size: 18, color: successColor),
                  label: Text(
                    translations.adminReviewApprove,
                    style: const TextStyle(color: successColor),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: () => controller.unapprove(review),
                  icon: const Icon(Icons.undo, size: 18),
                  label: Text(translations.adminReviewsPending),
                ),
              TextButton.icon(
                onPressed: () => controller.delete(review),
                icon: const Icon(Icons.delete_outline,
                    size: 18, color: errorColor),
                label: Text(
                  translations.actionDelete,
                  style: const TextStyle(color: errorColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
