import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import '../../../../models/review_model.dart';
import '../../../../utils/formatters.dart';

/// Single user review: initials avatar, name, time, stars and review body.
class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key, required this.review});

  final ReviewModel review;

  String get _initials {
    final parts = review.userName.trim().split(RegExp(r"\s+"));
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.035),
        borderRadius:
            const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: primaryColor,
                child: Text(
                  _initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding / 2),
              Expanded(
                child: Text(
                  review.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                formatTimeAgo(review.date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          RatingBar.builder(
            initialRating: review.rating,
            itemSize: 16,
            itemPadding: const EdgeInsets.only(right: defaultPadding / 4),
            unratedColor:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
            glow: false,
            allowHalfRating: true,
            ignoreGestures: true,
            onRatingUpdate: (_) {},
            itemBuilder: (context, index) =>
                SvgPicture.asset("assets/icons/Star_filled.svg"),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            "“${review.review}”",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
