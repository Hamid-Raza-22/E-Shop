import 'package:flutter/material.dart';

import '../../../components/error_state_view.dart';
import '../../../route/route_constants.dart';

class ServerErrorScreen extends StatelessWidget {
  const ServerErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ErrorStateView(
        lightIllustration: "assets/Illustration/server_error.png",
        darkIllustration: "assets/Illustration/server_error_dark.png",
        title: "Something went wrong",
        description:
            "Our servers are having a moment. Please try again shortly — nothing has been charged.",
        primaryLabel: "Try again",
        onPrimary: () => Navigator.pop(context),
        secondaryLabel: "Get help",
        onSecondary: () => Navigator.pushNamed(context, getHelpScreenRoute),
      ),
    );
  }
}
