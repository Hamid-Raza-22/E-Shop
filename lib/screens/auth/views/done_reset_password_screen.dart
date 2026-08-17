import 'package:flutter/material.dart';

import '../../../components/error_state_view.dart';
import '../../../route/route_constants.dart';

/// Confirmation shown after a successful password reset.
class DoneResetPasswordScreen extends StatelessWidget {
  const DoneResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorStateView(
        lightIllustration: "assets/Illustration/Success_lightTheme.png",
        darkIllustration: "assets/Illustration/Success_darkTheme.png",
        title: "Password changed",
        description:
            "Your password has been reset successfully. You can now log in with your new password.",
        primaryLabel: "Log in",
        onPrimary: () => Navigator.pushNamedAndRemoveUntil(
          context,
          logInScreenRoute,
          (route) => false,
        ),
      ),
    );
  }
}
