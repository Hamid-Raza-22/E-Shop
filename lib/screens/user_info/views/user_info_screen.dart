import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/list_tile/divider_list_tile.dart';
import '../../../components/network_image_with_loader.dart';
import '../../../constants.dart';
import '../../../repositories/user_repository.dart';
import 'edit_user_info_screen.dart';

/// Read-only profile overview with an entry point into the edit form.
class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  void _openEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditUserInfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = UserRepository.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () => _openEditScreen(context),
            tooltip: "Edit profile",
            icon: SvgPicture.asset(
              "assets/icons/Edit Square.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyLarge!.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: repository,
          builder: (context, _) {
            final user = repository.user;

            return ListView(
              children: [
                const SizedBox(height: defaultPadding),
                Center(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: NetworkImageWithLoader(user.imageSrc, radius: 100),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Center(
                  child: Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: defaultPadding / 4),
                    child: Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding * 1.5),
                const Divider(height: 1),
                _InfoTile(
                  svgSrc: "assets/icons/Profile.svg",
                  label: "Full name",
                  value: user.name,
                ),
                _InfoTile(
                  svgSrc: "assets/icons/Message.svg",
                  label: "Email address",
                  value: user.email,
                ),
                _InfoTile(
                  svgSrc: "assets/icons/Call.svg",
                  label: "Phone number",
                  value: user.phone,
                ),
                DividerListTile(
                  minLeadingWidth: 24,
                  leading: SvgPicture.asset(
                    "assets/icons/Edit Square.svg",
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyLarge!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: const Text("Edit profile"),
                  press: () => _openEditScreen(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.svgSrc,
    required this.label,
    required this.value,
  });

  final String svgSrc, label, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minLeadingWidth: 24,
          leading: SvgPicture.asset(
            svgSrc,
            height: 24,
            colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn),
          ),
          title: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: defaultPadding / 4),
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
