import 'package:flutter/material.dart';

import '../../../../components/check_mark.dart';
import '../../../../components/network_image_with_loader.dart';
import '../../../../constants.dart';
import '../../../../controllers/user_controller.dart';

/// Avatar chooser.
///
/// Picking from the device gallery/camera would require the `image_picker`
/// plugin, which is NOT a dependency of this project. Rather than fake a
/// platform API, the user selects from a preset avatar list
/// ([UserController.avatarOptions]). Adding `image_picker` to `pubspec.yaml`
/// is all that is needed to swap this for a real gallery picker.
class AvatarPickerSheet extends StatelessWidget {
  const AvatarPickerSheet({super.key, required this.selectedImageSrc});

  final String selectedImageSrc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Edit photo"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            "Choose one of the available photos.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              mainAxisSpacing: defaultPadding,
              crossAxisSpacing: defaultPadding,
            ),
            itemCount: UserController.avatarOptions.length,
            itemBuilder: (context, index) {
              final imageSrc = UserController.avatarOptions[index];
              final isSelected = imageSrc == selectedImageSrc;

              return InkWell(
                onTap: () => Navigator.pop(context, imageSrc),
                borderRadius: const BorderRadius.all(
                    Radius.circular(defaultBorderRadious)),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadious)),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : Theme.of(context).dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: NetworkImageWithLoader(
                          imageSrc,
                          radius: defaultBorderRadious,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Positioned(
                        top: defaultPadding / 2,
                        right: defaultPadding / 2,
                        child: CheckMark(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
