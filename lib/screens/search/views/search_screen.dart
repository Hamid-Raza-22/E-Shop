import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/empty_state_view.dart';
import '../../../components/product/product_card.dart';
import '../../../components/skleton/product/products_skelton.dart';
import '../../../constants.dart';
import '../../../models/product_model.dart';
import '../../../controllers/product_search_controller.dart';
import '../../../route/route_constants.dart';
import 'components/search_filter_sheet.dart';
import 'components/search_form.dart';
import 'components/search_history_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductSearchController _repository = ProductSearchController.to;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  /// Debounce keeps filtering off the critical path while the user is typing.
  static const Duration _debounceDuration = Duration(milliseconds: 300);
  Timer? _debounce;

  String _query = "";
  bool _isSearching = false;
  SearchFilter _filter = const SearchFilter();
  List<ProductModel> _results = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String? value) {
    final query = value ?? "";
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _query = "";
        _isSearching = false;
        _results = const [];
      });
      return;
    }

    setState(() {
      _query = query;
      _isSearching = true;
    });

    _debounce = Timer(_debounceDuration, () {
      if (!mounted) return;
      setState(() {
        _results = _applyFilter(_repository.search(query));
        _isSearching = false;
      });
    });
  }

  List<ProductModel> _applyFilter(List<ProductModel> products) {
    final filtered = products.where((product) {
      final effectivePrice = product.priceAfetDiscount ?? product.price;
      if (effectivePrice > _filter.maxPrice) return false;
      if (_filter.onlyDiscounted && product.priceAfetDiscount == null) {
        return false;
      }
      return true;
    }).toList();

    switch (_filter.sortOption) {
      case SearchSortOption.priceLowToHigh:
        filtered.sort((a, b) => _effectivePrice(a).compareTo(_effectivePrice(b)));
      case SearchSortOption.priceHighToLow:
        filtered.sort((a, b) => _effectivePrice(b).compareTo(_effectivePrice(a)));
      case SearchSortOption.relevance:
        break;
    }
    return filtered;
  }

  double _effectivePrice(ProductModel product) =>
      product.priceAfetDiscount ?? product.price;

  void _submitQuery(String? value) {
    final query = (value ?? "").trim();
    if (query.isEmpty) return;
    _repository.addToHistory(query);
    _searchFocusNode.unfocus();
    // Bypass the debounce so results are immediate on submit.
    _debounce?.cancel();
    setState(() {
      _query = query;
      _results = _applyFilter(_repository.search(query));
      _isSearching = false;
    });
  }

  void _selectHistoryTerm(String term) {
    _searchController.text = term;
    _submitQuery(term);
  }

  Future<void> _openFilterSheet() async {
    final result = await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.8,
      child: SearchFilterSheet(initialFilter: _filter),
    );

    if (result is! SearchFilter || !mounted) return;
    setState(() {
      _filter = result;
      _results = _query.trim().isEmpty
          ? const []
          : _applyFilter(_repository.search(_query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GOGGUZ"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SearchForm(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                onChanged: _onQueryChanged,
                onFieldSubmitted: _submitQuery,
                onTabFilter: _openFilterSheet,
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Idle: no query typed yet -> show recent searches.
    if (_query.trim().isEmpty) {
      return GetBuilder<ProductSearchController>(
        builder: (controller) {
          final history = _repository.history;
          if (history.isEmpty) {
            return const EmptyStateView(
              title: "Search the shop",
              description:
                  "Type a product name or a brand to find what you are looking for.",
            );
          }
          return SingleChildScrollView(
            child: SearchHistoryList(
              history: history,
              onSelect: _selectHistoryTerm,
              onRemove: _repository.removeFromHistory,
              onClearAll: _repository.clearHistory,
            ),
          );
        },
      );
    }

    if (_isSearching) {
      return const Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: defaultPadding),
          child: ProductsSkelton(),
        ),
      );
    }

    if (_results.isEmpty) {
      return EmptyStateView(
        title: "No results found",
        description:
            "We could not find anything for \"${_query.trim()}\". Try a different keyword or relax your filters.",
        actionLabel: _filter.isDefault ? null : "Reset filters",
        onAction: _filter.isDefault
            ? null
            : () => setState(() {
                  _filter = const SearchFilter();
                  _results = _applyFilter(_repository.search(_query));
                }),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          sliver: SliverToBoxAdapter(
            child: Text(
              "${_results.length} result${_results.length == 1 ? "" : "s"} for \"${_query.trim()}\"",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(defaultPadding),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: defaultPadding,
              crossAxisSpacing: defaultPadding,
              childAspectRatio: 0.66,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = _results[index];
                return ProductCard(
                  image: product.image,
                  brandName: product.brandName,
                  title: product.title,
                  price: product.price,
                  priceAfetDiscount: product.priceAfetDiscount,
                  dicountpercent: product.dicountpercent,
                  press: () => Navigator.pushNamed(
                      context, productDetailsScreenRoute,
                      arguments: product),
                );
              },
              childCount: _results.length,
            ),
          ),
        ),
      ],
    );
  }
}
