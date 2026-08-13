import 'package:flutter/material.dart';

import '../../../components/error_state_view.dart';

/// Offline state.
///
/// Live connectivity detection would need the `connectivity_plus` plugin,
/// which is NOT a dependency of this project. The retry button therefore just
/// pops back; wire the real check into [onPrimary] once the plugin is added.
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ErrorStateView(
        lightIllustration: "assets/Illustration/no_internet.png",
        darkIllustration: "assets/Illustration/no_internet_dark.png",
        title: "No internet connection",
        description:
            "Please check your connection and try again. Your cart and saved items are safe.",
        primaryLabel: "Try again",
        onPrimary: () => Navigator.pop(context),
      ),
    );
  }
}
