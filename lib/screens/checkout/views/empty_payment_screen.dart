import 'package:flutter/material.dart';

import '../../../components/empty_state_view.dart';
import 'add_new_card_screen.dart';

class EmptyPaymentScreen extends StatelessWidget {
  const EmptyPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: SafeArea(
        child: EmptyStateView(
          title: "No payment method",
          description:
              "Add a card to check out faster next time. Only the last 4 digits are stored on this device.",
          actionLabel: "Add new card",
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewCardScreen()),
          ),
        ),
      ),
    );
  }
}
