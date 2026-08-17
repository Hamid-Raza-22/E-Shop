import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/icon_text_form_field.dart';
import '../../../components/network_image_with_loader.dart';
import '../../../constants.dart';
import '../../../repositories/user_repository.dart';
import '../../../route/route_constants.dart';
import '../../user_info/views/components/avatar_picker_sheet.dart';

/// Post-signup profile completion step.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final UserRepository _repository = UserRepository.instance;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController =
      TextEditingController(text: _repository.user.name);
  late final TextEditingController _phoneController =
      TextEditingController(text: _repository.user.phone);

  late String _imageSrc = _repository.user.imageSrc;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final result = await customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.6,
      child: AvatarPickerSheet(selectedImageSrc: _imageSrc),
    );
    if (result is! String || !mounted) return;
    setState(() => _imageSrc = result);
  }

  void _finish() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _repository.update(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      imageSrc: _imageSrc,
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
      appBar: AppBar(
        title: const Text("Complete your profile"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              entryPointScreenRoute,
              (route) => false,
            ),
            child: const Text("Skip"),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Text(
                "Tell us about you",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              Text(
                "Add a photo and your details so we can personalise your experience.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: defaultPadding * 1.5),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 110,
                      width: 110,
                      child: NetworkImageWithLoader(_imageSrc, radius: 100),
                    ),
                    TextButton(
                      onPressed: _pickAvatar,
                      child: const Text("Choose photo"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              IconTextFormField(
                controller: _nameController,
                hintText: "Full name",
                svgSrc: "assets/icons/Profile.svg",
                textCapitalization: TextCapitalization.words,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Name is required"),
                  MinLengthValidator(3, errorText: "Enter at least 3 characters"),
                ]).call,
              ),
              const SizedBox(height: defaultPadding),
              IconTextFormField(
                controller: _phoneController,
                hintText: "Phone number",
                svgSrc: "assets/icons/Call.svg",
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Phone number is required"),
                  MinLengthValidator(7, errorText: "Enter a valid number"),
                ]).call,
              ),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _finish,
                child: const Text("Finish setup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
