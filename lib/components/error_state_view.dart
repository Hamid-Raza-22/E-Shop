import 'package:flutter/material.dart';

import '../constants.dart';

/// Shared full-screen error layout used by the no-internet and server-error
/// screens, so both look identical to the rest of the kit.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.lightIllustration,
    required this.darkIllustration,
    required this.title,
    required this.description,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String lightIllustration, darkIllustration;
  final String title, description;
  final String? primaryLabel, secondaryLabel;
  final VoidCallback? onPrimary, onSecondary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? lightIllustration
                  : darkIllustration,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(flex: 2),
            if (primaryLabel != null && onPrimary != null)
              ElevatedButton(
                onPressed: onPrimary,
                child: Text(primaryLabel!),
              ),
            if (secondaryLabel != null && onSecondary != null)
              Padding(
                padding: const EdgeInsets.only(top: defaultPadding / 2),
                child: OutlinedButton(
                  onPressed: onSecondary,
                  child: Text(secondaryLabel!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
