import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import '../../../route/route_constants.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: SafeArea(
        child: EmptyStateView(
          title: "Your cart is empty",
          description:
              "Looks like you have not added anything yet. Browse the shop and find something you love.",
          actionLabel: "Start shopping",
          onAction: () => Navigator.pushNamed(context, homeScreenRoute),
        ),
      ),
    );
  }
}
