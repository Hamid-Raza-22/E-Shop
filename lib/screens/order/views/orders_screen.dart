import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/empty_state_view.dart';
import '../../../constants.dart';
import '../../../models/order_model.dart';
import '../../../controllers/order_controller.dart';
import '../../../route/route_constants.dart';
import '../../search/views/components/search_form.dart';
import 'components/order_card.dart';
import 'components/order_details_sheet.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final OrderController _repository = OrderController.to;
  final TextEditingController _searchController = TextEditingController();

  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  /// A notifier (instead of setState) keeps the search field itself out of the
  /// rebuild scope, so typing only rebuilds the order lists.
  final ValueNotifier<String> _query = ValueNotifier<String>("");

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _query.dispose();
    super.dispose();
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    final term = _query.value.trim().toLowerCase();
    if (term.isEmpty) return orders;
    return orders
        .where((order) =>
            order.id.toLowerCase().contains(term) ||
            order.items.any((item) =>
                item.product.title.toLowerCase().contains(term) ||
                item.product.brandName.toLowerCase().contains(term)))
        .toList();
  }

  Future<void> _openOrderDetails(OrderModel order) async {
    final wasCanceled = await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.85,
      child: OrderDetailsSheet(
        order: order,
        onCancel: (reason) =>
            _repository.cancelOrder(order.id, reason: reason),
      ),
    );

    if (wasCanceled == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order #${order.id} has been canceled")),
      );
      // Canceled orders live in the history tab.
      _tabController.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Current"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Outside the rebuild scope on purpose.
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SearchForm(
                controller: _searchController,
                hintText: "Find an order...",
                onChanged: (value) => _query.value = value ?? "",
                onTabFilter: () => _tabController
                    .animateTo(_tabController.index == 0 ? 1 : 0),
              ),
            ),
            Expanded(
              child: GetBuilder<OrderController>(
                builder: (controller) {
                  return ListenableBuilder(
                    listenable: _query,
                    builder: (context, _) {
                      return Column(
                        children: [
                          _OrdersHistorySummary(repository: _repository),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _OrdersList(
                                  orders:
                                      _filterOrders(_repository.activeOrders),
                                  emptyTitle: "No current orders",
                                  emptyDescription:
                                      "When you place an order it will show up here so you can track it.",
                                  onOrderTap: _openOrderDetails,
                                ),
                                _OrdersList(
                                  orders:
                                      _filterOrders(_repository.historyOrders),
                                  emptyTitle: "No order history",
                                  emptyDescription:
                                      "Delivered and canceled orders will be listed here.",
                                  onOrderTap: _openOrderDetails,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Orders history" status counters from the Orders design.
class _OrdersHistorySummary extends StatelessWidget {
  const _OrdersHistorySummary({required this.repository});

  final OrderController repository;

  @override
  Widget build(BuildContext context) {
    final entries = <(String, int, Color)>[
      (
        "Processing",
        repository.countByStatus(OrderStatus.processing),
        warningColor
      ),
      (
        "Delivered",
        repository.countByStatus(OrderStatus.delivered),
        successColor
      ),
      ("Canceled", repository.countByStatus(OrderStatus.canceled), errorColor),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: List.generate(entries.length, (index) {
          final (label, count, color) = entries[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == entries.length - 1 ? 0 : defaultPadding / 2,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding / 1.5,
                    horizontal: defaultPadding / 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(defaultBorderRadious)),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  children: [
                    Text(
                      "$count",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: color),
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.onOrderTap,
  });

  final List<OrderModel> orders;
  final String emptyTitle, emptyDescription;
  final ValueChanged<OrderModel> onOrderTap;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyStateView(
        title: emptyTitle,
        description: emptyDescription,
        actionLabel: "Continue shopping",
        onAction: () => Navigator.pushNamed(context, homeScreenRoute),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: orders.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: defaultPadding),
      itemBuilder: (context, index) => OrderCard(
        order: orders[index],
        press: () => onOrderTap(orders[index]),
      ),
    );
  }
}
