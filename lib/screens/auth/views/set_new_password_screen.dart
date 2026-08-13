import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';

/// Step 2 of password recovery: set a new password.
///
/// Reuses [passwordValidator] from constants.dart so the password rules match
/// the sign-up form exactly.
class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Password updated"),
        content: const Text(
          "Your password has been changed. Please log in with your new password.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              logInScreenRoute,
              (route) => route.isFirst,
            ),
            child: const Text("Log in"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New password")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Text(
                "Create a new password",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              Text(
                "Setting a new password for ${widget.email}. Use at least 8 characters and one special character.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: defaultPadding * 1.5),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: passwordValidator.call,
                decoration: InputDecoration(
                  hintText: "New password",
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
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if ((value ?? "").isEmpty) return "Confirm your password";
                  if (value != _passwordController.text) {
                    return pasNotMatchErrorText;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Confirm password",
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
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Save new password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
