import 'package:flutter/material.dart';

import '../../../components/error_state_view.dart';
import '../../../route/route_constants.dart';

/// Fallback for unknown named routes.
class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen({super.key, this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ErrorStateView(
        lightIllustration: "assets/Illustration/Failed_lightTheme.png",
        darkIllustration: "assets/Illustration/Failed_darkTheme.png",
        title: "Page not found",
        description: routeName == null
            ? "This screen does not exist."
            : "We could not find the screen \"$routeName\".",
        primaryLabel: "Back to shop",
        onPrimary: () => Navigator.pushNamedAndRemoveUntil(
          context,
          entryPointScreenRoute,
          (route) => false,
        ),
      ),
    );
  }
}
