import 'dart:async';

import 'package:flutter/material.dart';

import '../../../components/otp_form.dart';
import '../../../constants.dart';

/// Generic OTP verification screen.
///
/// There is no auth backend, so any 4-digit code is accepted and [onVerified]
/// decides where to go next. Replace [_verify] with the real API call later.
class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.destination,
    this.title = "Verification code",
    required this.onVerified,
  });

  /// Phone/email the code was "sent" to, shown in the description.
  final String destination;
  final String title;
  final VoidCallback onVerified;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _resendSeconds = 60;

  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  Future<void> _verify(String code) async {
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isVerifying = false);
    widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/Illustration/VerificationCode_dark.png"
                  : "assets/Illustration/VerificationCode_dark.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "Enter your verification code",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              "We sent a 4-digit code to ${widget.destination}. Enter it below to continue.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: defaultPadding * 2),
            OtpForm(onCompleted: _verify),
            const SizedBox(height: defaultPadding * 2),
            if (_isVerifying)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: _secondsLeft > 0
                    ? Text(
                        "Resend code in ${_secondsLeft}s",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextButton(
                        onPressed: _startCountdown,
                        child: const Text("Resend code"),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
