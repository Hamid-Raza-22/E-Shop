import 'package:flutter/material.dart';

import '../../../repositories/user_repository.dart';
import '../../../route/route_constants.dart';
import 'otp_screen.dart';

/// Email verification step right after sign-up.
class SignUpVerificationScreen extends StatelessWidget {
  const SignUpVerificationScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return OtpScreen(
      title: "Verify your account",
      destination: email ?? UserRepository.instance.user.email,
      onVerified: () =>
          Navigator.pushNamed(context, profileSetupScreenRoute),
    );
  }
}
