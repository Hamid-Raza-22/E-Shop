import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/empty_state_view.dart';
import '../../../controllers/product_search_controller.dart';
import 'components/search_history_list.dart';
import 'search_screen.dart';

/// Full "Recent searches" list (the Search screen shows the same widget inline).
class SearchHistoryScreen extends StatelessWidget {
  const SearchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProductSearchController.to;

    return Scaffold(
      appBar: AppBar(title: const Text("Recent searches")),
      body: SafeArea(
        child: GetBuilder<ProductSearchController>(
          builder: (controller) {
            if (repository.history.isEmpty) {
              return EmptyStateView(
                title: "No recent searches",
                description:
                    "Products you search for will show up here so you can find them again quickly.",
                actionLabel: "Search now",
                onAction: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()),
                ),
              );
            }

            return SingleChildScrollView(
              child: SearchHistoryList(
                history: repository.history,
                onSelect: (term) {
                  repository.addToHistory(term);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()),
                  );
                },
                onRemove: repository.removeFromHistory,
                onClearAll: repository.clearHistory,
              ),
            );
          },
        ),
      ),
    );
  }
}
