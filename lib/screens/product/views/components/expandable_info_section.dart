import 'package:flutter/material.dart';

import '../../../../constants.dart';

/// Collapsible information block used by the Product Details and Shipping
/// Information bottom sheets.
class ExpandableInfoSection extends StatelessWidget {
  const ExpandableInfoSection({
    super.key,
    required this.title,
    this.body,
    this.children,
    this.isInitiallyExpanded = false,
  }) : assert(body != null || children != null,
            "Provide either a body text or child widgets");

  final String title;
  final String? body;
  final List<Widget>? children;
  final bool isInitiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Removes the default ExpansionTile divider lines so the section matches
      // the flat style used across the kit.
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: defaultPadding),
            initiallyExpanded: isInitiallyExpanded,
            iconColor: Theme.of(context).textTheme.bodyLarge!.color,
            children: children ??
                [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      body!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
