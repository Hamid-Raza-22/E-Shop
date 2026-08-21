import 'package:flutter/material.dart';

import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../controllers/order_controller.dart';
import 'components/order_details_sheet.dart';

/// Full-screen cancel flow: pick a reason, optionally add a note, confirm.
class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final TextEditingController _noteController = TextEditingController();

  String? _selectedReason;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _confirm() {
    final reason = _selectedReason;
    if (reason == null) return;

    final note = _noteController.text.trim();
    OrderController.to.cancelOrder(
      widget.orderId,
      reason: note.isEmpty ? reason : "$reason — $note",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order #${widget.orderId} has been canceled")),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cancel order")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      "Select a reason for cancelling order #${widget.orderId}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Divider(height: 1),
                  ...OrderDetailsSheet.cancelReasons.map(
                    (reason) => Column(
                      children: [
                        ListTile(
                          onTap: () =>
                              setState(() => _selectedReason = reason),
                          title: Text(reason),
                          trailing: _selectedReason == reason
                              ? const CheckMark()
                              : null,
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 4,
                      maxLength: 300,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: "Add a note (optional)",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: ElevatedButton(
                // Disabled until a reason is chosen.
                onPressed: _selectedReason == null ? null : _confirm,
                style: ElevatedButton.styleFrom(backgroundColor: errorColor),
                child: const Text("Confirm cancellation"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
