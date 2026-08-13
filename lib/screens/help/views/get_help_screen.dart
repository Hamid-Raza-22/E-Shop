import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/list_tile/divider_list_tile.dart';
import '../../../constants.dart';
import '../../../screens/product/views/components/expandable_info_section.dart';

/// Help centre: contact options + FAQ.
class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

  static const List<(String, String)> _faqs = [
    (
      "Where is my order?",
      "Open Profile › Orders to see live status for every order. Once an order ships you also receive a tracking link by email."
    ),
    (
      "How do I return an item?",
      "You have 30 days from delivery. Open the order, tap the item and choose Return. Items must be unworn with original tags."
    ),
    (
      "When will I be refunded?",
      "Refunds are issued to your original payment method within 5 working days of your return arriving at our warehouse."
    ),
    (
      "Can I change my delivery address?",
      "Yes, as long as the order has not shipped. Go to Profile › Addresses to manage your saved addresses."
    ),
    (
      "Is my payment information safe?",
      "We never store full card numbers on your device — only the last four digits are kept so you can recognise your card."
    ),
  ];

  void _showContactSnackBar(BuildContext context, String channel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$channel support is not available in this demo")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get help")),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "How can we help?",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            DividerListTile(
              minLeadingWidth: 24,
              leading: _icon(context, "assets/icons/Chat.svg"),
              title: const Text("Chat with support"),
              press: () => _showContactSnackBar(context, "Live chat"),
            ),
            DividerListTile(
              minLeadingWidth: 24,
              leading: _icon(context, "assets/icons/Message.svg"),
              title: const Text("Email us"),
              press: () => _showContactSnackBar(context, "Email"),
            ),
            DividerListTile(
              minLeadingWidth: 24,
              leading: _icon(context, "assets/icons/Call.svg"),
              title: const Text("Call us"),
              press: () => _showContactSnackBar(context, "Phone"),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Frequently asked questions",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                children: _faqs
                    .map((faq) => ExpandableInfoSection(
                          title: faq.$1,
                          body: faq.$2,
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }

  Widget _icon(BuildContext context, String svgSrc) => SvgPicture.asset(
        svgSrc,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          Theme.of(context).textTheme.bodyLarge!.color!,
          BlendMode.srcIn,
        ),
      );
}
