import 'package:flutter/material.dart';

import '../../../constants.dart';

/// Terms of service / privacy policy content, linked from the sign-up screen.
class TermsOfServicesScreen extends StatelessWidget {
  const TermsOfServicesScreen({super.key});

  static const List<(String, String)> _sections = [
    (
      "1. Acceptance of terms",
      "By creating an account or placing an order you agree to these terms of service and to our privacy policy. If you do not agree, please do not use the app."
    ),
    (
      "2. Your account",
      "You are responsible for keeping your login credentials secure and for all activity that happens under your account. Notify us immediately if you suspect unauthorised access."
    ),
    (
      "3. Orders and pricing",
      "All orders are subject to availability and acceptance. Prices shown include applicable VAT where indicated. We reserve the right to cancel an order if a pricing error is discovered."
    ),
    (
      "4. Shipping and delivery",
      "Estimated delivery windows are indicative and not guaranteed. Risk of loss passes to you on delivery to the address you provided."
    ),
    (
      "5. Returns and refunds",
      "Items may be returned within 30 days of delivery in unworn condition with original tags. Refunds are issued to the original payment method."
    ),
    (
      "6. Privacy",
      "We process your personal data only to fulfil your orders, provide support and, where you have opted in, to send marketing communications. You may withdraw consent at any time in notification settings."
    ),
    (
      "7. Changes to these terms",
      "We may update these terms from time to time. Continued use of the app after an update constitutes acceptance of the revised terms."
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms of service")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            Text(
              "Terms of service & privacy policy",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              "Last updated: January 2025",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: defaultPadding * 2),
            ..._sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding * 1.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.$1,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Text(
                      section.$2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("I understand"),
            ),
          ],
        ),
      ),
    );
  }
}
