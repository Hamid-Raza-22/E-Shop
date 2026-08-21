import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/admin/admin_auth_controller.dart';
import '../../../l10n/app_localizations.dart';

/// Owner sign-in. Shown by the dashboard route whenever no admin is signed in.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final signedIn = await AdminAuthController.to.signIn(
      email: _email.text.trim(),
      password: _password.text,
    );

    // The dashboard route swaps itself once `isAdmin` flips, so success needs
    // no navigation here; only the failure case has to be surfaced.
    if (!signedIn && mounted) {
      final message = AdminAuthController.to.error;
      if (message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  Future<void> _resetPassword() async {
    final translations = AppLocalizations.of(context);
    final email = _email.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(translations.validationRequired)),
      );
      return;
    }

    final sent = await AdminAuthController.to.sendPasswordReset(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent
              ? "Password reset e-mail sent to $email"
              : AdminAuthController.to.error ?? translations.errorGeneric,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminAuthController.to;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: primaryColor,
                      child: Icon(Icons.storefront,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: defaultPadding),
                    Text(
                      translations.adminSignInTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Text(
                      translations.adminSignInSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: defaultPadding * 1.5),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final email = value?.trim() ?? "";
                        if (email.isEmpty) return translations.validationRequired;
                        if (!email.contains("@") || !email.contains(".")) {
                          return translations.validationInvalidEmail;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: translations.labelEmail,
                        prefixIcon: const Icon(Icons.mail_outline),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) => (value ?? "").isEmpty
                          ? translations.validationRequired
                          : null,
                      decoration: InputDecoration(
                        hintText: translations.labelPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isBusy ? null : _submit,
                        child: controller.isBusy
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(translations.actionSignIn),
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    TextButton(
                      onPressed: _resetPassword,
                      child: const Text("Forgot password?"),
                    ),
                    Obx(() {
                      final error = controller.error;
                      if (error == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: defaultPadding / 2),
                        child: Text(
                          error,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: errorColor),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
