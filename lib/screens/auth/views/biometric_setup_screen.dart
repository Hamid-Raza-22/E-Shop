import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';

enum BiometricType { fingerprint, faceId }

/// Fingerprint / Face ID opt-in screen.
///
/// Real biometric authentication requires the `local_auth` plugin, which is NOT
/// a dependency of this project. Nothing is faked here: the screen records the
/// user's choice and moves on. Wire `local_auth` into [_enable] to make it real.
class BiometricSetupScreen extends StatelessWidget {
  const BiometricSetupScreen({super.key, required this.type});

  final BiometricType type;

  bool get _isFingerprint => type == BiometricType.fingerprint;

  String get _title => _isFingerprint ? "Fingerprint" : "Face ID";

  String get _illustration {
    if (_isFingerprint) return "assets/Illustration/fingerprint.png";
    return "assets/Illustration/faceId.png";
  }

  String get _illustrationDark {
    if (_isFingerprint) return "assets/Illustration/fingerprint_dark.png";
    return "assets/Illustration/faceId_dark.png";
  }

  void _enable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$_title requires the local_auth plugin to work on device"),
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      entryPointScreenRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? _illustration
                    : _illustrationDark,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              const Spacer(),
              Text(
                _isFingerprint
                    ? "Log in with your fingerprint"
                    : "Log in with Face ID",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding),
              Text(
                "Skip typing your password every time. You can turn this off later in settings.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () => _enable(context),
                child: Text("Enable $_title"),
              ),
              const SizedBox(height: defaultPadding / 2),
              OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  entryPointScreenRoute,
                  (route) => false,
                ),
                child: const Text("Maybe later"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
