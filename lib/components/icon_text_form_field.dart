import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

/// Text field with a leading SVG icon.
///
/// Extracted so the address and profile forms share the exact prefix-icon
/// treatment already used by [SignUpForm]/[LogInForm].
class IconTextFormField extends StatelessWidget {
  const IconTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.svgSrc,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hintText, svgSrc;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
          child: SvgPicture.asset(
            svgSrc,
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
