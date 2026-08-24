import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../components/custom_modal_bottom_sheet.dart';
import '../../../components/icon_text_form_field.dart';
import '../../../components/network_image_with_loader.dart';
import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../services/customer_service.dart';
import '../../../utils/service_locator.dart';
import 'components/avatar_picker_sheet.dart';

/// Editable profile form matching the "Edit profile" design.
class EditUserInfoScreen extends StatefulWidget {
  const EditUserInfoScreen({super.key});

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final UserController _repository = UserController.to;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late String _imageSrc;

  @override
  void initState() {
    super.initState();
    final user = _repository.user;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _imageSrc = user.imageSrc;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    _repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      imageSrc: _imageSrc,
    );

    // A signed-in customer's profile also lives in Firestore, where the
    // dashboard reads it.
    final customerId = AuthController.to.user?.uid;
    final customers = serviceOrNull<CustomerService>();
    var saved = true;
    if (customerId != null && customers != null) {
      try {
        await customers.saveProfile(
          id: customerId,
          name: name,
          email: email,
          phone: phone,
          photoUrl: _imageSrc,
        );
      } catch (_) {
        saved = false;
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(saved
            ? "Profile updated"
            : "Saved on this device, but we could not sync it."),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: NetworkImageWithLoader(
                            _imageSrc,
                            radius: 100,
                          ),
                        ),
                        InkWell(
                          onTap: _pickAvatar,
                          customBorder: const CircleBorder(),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _pickAvatar,
                      child: const Text("Edit photo"),
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
                controller: _emailController,
                hintText: "Email address",
                svgSrc: "assets/icons/Message.svg",
                keyboardType: TextInputType.emailAddress,
                // Reuses the shared validator from constants.dart.
                validator: emaildValidator.call,
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
                onPressed: _save,
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
