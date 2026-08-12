import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

/// "Recent Searches" block from the Search design.
class SearchHistoryList extends StatelessWidget {
  const SearchHistoryList({
    super.key,
    required this.history,
    required this.onSelect,
    required this.onRemove,
    required this.onClearAll,
  });

  final List<String> history;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Searches",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: onClearAll,
                child: const Text("Clear All"),
              ),
            ],
          ),
        ),
        ...history.map(
          (term) => Column(
            children: [
              ListTile(
                onTap: () => onSelect(term),
                minLeadingWidth: 24,
                leading: SvgPicture.asset(
                  "assets/icons/Clock.svg",
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    greyColor,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text(term),
                trailing: IconButton(
                  onPressed: () => onRemove(term),
                  tooltip: "Remove from history",
                  icon: SvgPicture.asset(
                    "assets/icons/Close.svg",
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      greyColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
            ],
          ),
        ),
      ],
    );
  }
}
