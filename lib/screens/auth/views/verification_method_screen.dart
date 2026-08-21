import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/check_mark.dart';
import '../../../constants.dart';
import '../../../controllers/user_controller.dart';
import 'otp_screen.dart';
import 'set_new_password_screen.dart';

enum VerificationMethod { email, sms }

/// Lets the user choose how to receive the verification code.
class VerificationMethodScreen extends StatefulWidget {
  const VerificationMethodScreen({super.key});

  @override
  State<VerificationMethodScreen> createState() =>
      _VerificationMethodScreenState();
}

class _VerificationMethodScreenState extends State<VerificationMethodScreen> {
  VerificationMethod _method = VerificationMethod.email;

  String get _destination {
    final user = UserController.to.user;
    switch (_method) {
      case VerificationMethod.email:
        return user.email;
      case VerificationMethod.sms:
        return user.phone;
    }
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          destination: _destination,
          onVerified: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SetNewPasswordScreen(email: UserController.to.user.email),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification method")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(defaultPadding),
                children: [
                  Text(
                    "How should we send your code?",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    "Choose a verification method and we will send you a 4-digit code.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: defaultPadding * 1.5),
                  _MethodTile(
                    svgSrc: "assets/icons/Message.svg",
                    title: "Email",
                    subtitle: UserController.to.user.email,
                    isSelected: _method == VerificationMethod.email,
                    press: () =>
                        setState(() => _method = VerificationMethod.email),
                  ),
                  const SizedBox(height: defaultPadding),
                  _MethodTile(
                    svgSrc: "assets/icons/Call.svg",
                    title: "SMS",
                    subtitle: UserController.to.user.phone,
                    isSelected: _method == VerificationMethod.sms,
                    press: () =>
                        setState(() => _method = VerificationMethod.sms),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: ElevatedButton(
                onPressed: _continue,
                child: const Text("Send code"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.svgSrc,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.press,
  });

  final String svgSrc, title, subtitle;
  final bool isSelected;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultBorderRadious)),
          border: Border.all(
            color: isSelected ? primaryColor : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgSrc,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? primaryColor
                    : Theme.of(context).textTheme.bodyLarge!.color!,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: defaultPadding / 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected) const CheckMark(),
          ],
        ),
      ),
    );
  }
}
