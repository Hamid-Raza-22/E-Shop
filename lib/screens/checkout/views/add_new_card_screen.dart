import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../components/icon_text_form_field.dart';
import '../../../constants.dart';
import '../../../repositories/payment_repository.dart';

/// Add-card form. Only the last four digits are persisted (see
/// [PaymentRepository]); no full card number is stored anywhere.
class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String? _validateExpiry(String? value) {
    final text = (value ?? "").trim();
    if (text.isEmpty) return "Expiry date is required";

    final match = RegExp(r"^(\d{2})/(\d{2})$").firstMatch(text);
    if (match == null) return "Use MM/YY format";

    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    if (month < 1 || month > 12) return "Invalid month";

    // Card is valid through the last day of its expiry month.
    final expiresAt = DateTime(year, month + 1, 0);
    if (expiresAt.isBefore(DateTime.now())) return "Card has expired";
    return null;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    PaymentRepository.instance.addCard(
      holderName: _holderController.text.trim(),
      cardNumber: _numberController.text,
      expiryDate: _expiryController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card added")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new card")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              IconTextFormField(
                controller: _holderController,
                hintText: "Card holder name",
                svgSrc: "assets/icons/Profile.svg",
                textCapitalization: TextCapitalization.words,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Card holder name is required"),
                  MinLengthValidator(3, errorText: "Enter the full name"),
                ]).call,
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                maxLength: 19,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "Card number",
                  counterText: "",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 0.75),
                    child: SvgPicture.asset(
                      "assets/icons/card.svg",
                      height: 24,
                      width: 24,
                      colorFilter:
                          const ColorFilter.mode(greyColor, BlendMode.srcIn),
                    ),
                  ),
                ),
                validator: (value) {
                  final digits = (value ?? "").replaceAll(RegExp(r"\D"), "");
                  if (digits.isEmpty) return "Card number is required";
                  if (digits.length < 13) return "Enter a valid card number";
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      decoration: const InputDecoration(
                        hintText: "MM/YY",
                        counterText: "",
                      ),
                      validator: _validateExpiry,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: "CVV",
                        counterText: "",
                      ),
                      validator: (value) {
                        final text = (value ?? "").trim();
                        if (text.isEmpty) return "CVV is required";
                        if (text.length < 3) return "Invalid CVV";
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Text(
                "For your security only the last 4 digits of your card are saved on this device.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _save,
                child: const Text("Add card"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
