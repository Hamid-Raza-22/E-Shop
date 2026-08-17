import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import 'set_new_password_screen.dart';

/// Re-authentication step before changing a password from inside the app.
class CurrentPasswordScreen extends StatefulWidget {
  const CurrentPasswordScreen({super.key});

  @override
  State<CurrentPasswordScreen> createState() => _CurrentPasswordScreenState();
}

class _CurrentPasswordScreenState extends State<CurrentPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // No auth backend: any non-empty password is accepted here.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SetNewPasswordScreen(email: "your account"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change password")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Text(
                "Confirm your current password",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              Text(
                "For your security, please enter your current password before setting a new one.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: defaultPadding * 1.5),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                validator: (value) => (value ?? "").isEmpty
                    ? "Current password is required"
                    : null,
                decoration: InputDecoration(
                  hintText: "Current password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 0.75),
                    child: SvgPicture.asset(
                      "assets/icons/Lock.svg",
                      height: 24,
                      width: 24,
                      colorFilter:
                          const ColorFilter.mode(greyColor, BlendMode.srcIn),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(_obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
