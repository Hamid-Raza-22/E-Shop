import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';

/// Order confirmation screen shown after a successful checkout.
class ThanksForOrderScreen extends StatelessWidget {
  const ThanksForOrderScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/Illustration/Success_lightTheme.png"
                    : "assets/Illustration/Success_darkTheme.png",
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const Spacer(),
              Text(
                "Thanks for your order!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding),
              Text(
                orderId == null
                    ? "Your order has been placed. We will email you the tracking details as soon as it ships."
                    : "Your order #$orderId has been placed. We will email you the tracking details as soon as it ships.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, ordersScreenRoute),
                child: const Text("Track my order"),
              ),
              const SizedBox(height: defaultPadding / 2),
              OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  entryPointScreenRoute,
                  (route) => false,
                ),
                child: const Text("Continue shopping"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
