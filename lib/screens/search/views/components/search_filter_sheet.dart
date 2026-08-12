import 'package:flutter/material.dart';

import '../../../../components/check_mark.dart';
import '../../../../constants.dart';

enum SearchSortOption { relevance, priceLowToHigh, priceHighToLow }

/// Filter/sort options applied to the search results.
class SearchFilter {
  const SearchFilter({
    this.maxPrice = 1500,
    this.onlyDiscounted = false,
    this.sortOption = SearchSortOption.relevance,
  });

  static const double priceRangeMax = 1500;

  final double maxPrice;
  final bool onlyDiscounted;
  final SearchSortOption sortOption;

  bool get isDefault =>
      maxPrice == priceRangeMax &&
      !onlyDiscounted &&
      sortOption == SearchSortOption.relevance;

  SearchFilter copyWith({
    double? maxPrice,
    bool? onlyDiscounted,
    SearchSortOption? sortOption,
  }) {
    return SearchFilter(
      maxPrice: maxPrice ?? this.maxPrice,
      onlyDiscounted: onlyDiscounted ?? this.onlyDiscounted,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

/// Bottom-sheet content used by the Search screen's filter button.
/// Returns the new [SearchFilter] through `Navigator.pop`.
class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({super.key, required this.initialFilter});

  final SearchFilter initialFilter;

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late SearchFilter _filter = widget.initialFilter;

  static const Map<SearchSortOption, String> _sortLabels = {
    SearchSortOption.relevance: "Relevance",
    SearchSortOption.priceLowToHigh: "Price: low to high",
    SearchSortOption.priceHighToLow: "Price: high to low",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Filter"),
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () => setState(() => _filter = const SearchFilter()),
              child: const Text("Reset"),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Text(
                "Max price",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Slider(
                value: _filter.maxPrice,
                min: 100,
                max: SearchFilter.priceRangeMax,
                divisions: 28,
                label: "\$${_filter.maxPrice.round()}",
                onChanged: (value) =>
                    setState(() => _filter = _filter.copyWith(maxPrice: value)),
              ),
              Text(
                "Up to \$${_filter.maxPrice.round()}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: defaultPadding),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Discounted items only",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: _filter.onlyDiscounted,
                onChanged: (value) => setState(
                    () => _filter = _filter.copyWith(onlyDiscounted: value)),
              ),
              const Divider(height: defaultPadding * 2),
              Text(
                "Sort by",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              // Plain list tiles + the existing [CheckMark] component, so no
              // deprecated Radio APIs are used.
              ..._sortLabels.entries.map(
                (entry) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.value),
                  trailing: _filter.sortOption == entry.key
                      ? const CheckMark()
                      : null,
                  onTap: () => setState(
                      () => _filter = _filter.copyWith(sortOption: entry.key)),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _filter),
              child: const Text("Apply filter"),
            ),
          ),
        ),
      ],
    );
  }
}
