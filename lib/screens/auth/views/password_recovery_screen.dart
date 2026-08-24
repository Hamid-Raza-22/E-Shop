import 'package:flutter/material.dart';

import '../../../components/icon_text_form_field.dart';
import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../route/route_constants.dart';
import 'set_new_password_screen.dart';

/// Step 1 of password recovery: collect the account email and ask Firebase to
/// send the reset link.
///
/// Without Firebase the flow still continues to [SetNewPasswordScreen] so the
/// UX stays complete.
class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() =>
      _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = AuthController.to;
    final email = _emailController.text.trim();

    setState(() => _isSubmitting = true);
    final sent = auth.isAvailable
        ? await auth.sendPasswordReset(email)
        : true;
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (!sent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? "Could not send the reset link.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetNewPasswordScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot password")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/Illustration/Password.png"
                    : "assets/Illustration/Password_dark.png",
                width: MediaQuery.of(context).size.width * 0.55,
              ),
              const SizedBox(height: defaultPadding),
              Text(
                "Reset your password",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              Text(
                "Enter the email address linked to your account and we will send you a link to reset your password.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: defaultPadding * 1.5),
              IconTextFormField(
                controller: _emailController,
                hintText: "Email address",
                svgSrc: "assets/icons/Message.svg",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: emaildValidator.call,
              ),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Send reset link"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Remembered it?"),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, logInScreenRoute),
                    child: const Text("Log in"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
