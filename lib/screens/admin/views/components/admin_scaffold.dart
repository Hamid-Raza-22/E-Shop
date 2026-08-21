import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../../../controllers/admin/admin_auth_controller.dart';
import '../../../../controllers/localization_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/responsive.dart';

/// One entry in the dashboard navigation.
class AdminDestination {
  const AdminDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount = 0,
  });

  final String label;
  final IconData icon, selectedIcon;

  /// Small counter drawn on the icon, e.g. open orders or pending reviews.
  final int badgeCount;
}

/// Responsive chrome shared by every dashboard section.
///
/// * mobile  — hamburger + [Drawer]
/// * tablet  — [NavigationRail] (icons only)
/// * desktop — permanent extended sidebar
///
/// The section content itself is passed in as [child]; the parent keeps the
/// selected index so section state survives navigation.
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
    this.actions = const [],
    this.floatingActionButton,
  });

  final String title;
  final List<AdminDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;
  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final isMobile = size == ScreenSize.mobile;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...actions,
          const _LanguageMenu(),
          const _AccountMenu(),
          const SizedBox(width: defaultPadding / 2),
        ],
      ),
      drawer: isMobile
          ? Drawer(
              child: SafeArea(
                child: _SidebarContent(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    Navigator.pop(context);
                    onDestinationSelected(index);
                  },
                ),
              ),
            )
          : null,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Row(
          children: [
            if (size == ScreenSize.tablet)
              _NavigationRail(
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
              ),
            if (size == ScreenSize.desktop)
              SizedBox(
                width: 260,
                child: _SidebarContent(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                ),
              ),
            if (!isMobile) const VerticalDivider(width: 1),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context),
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationRail extends StatelessWidget {
  const _NavigationRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AdminDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: destinations
          .map(
            (destination) => NavigationRailDestination(
              icon: _BadgedIcon(
                icon: destination.icon,
                count: destination.badgeCount,
              ),
              selectedIcon: _BadgedIcon(
                icon: destination.selectedIcon,
                count: destination.badgeCount,
              ),
              label: Text(destination.label),
            ),
          )
          .toList(),
    );
  }
}

class _SidebarContent extends StatelessWidget {
  const _SidebarContent({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AdminDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor,
                child: Icon(Icons.storefront, color: Colors.white, size: 20),
              ),
              const SizedBox(width: defaultPadding / 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translations.appTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      translations.adminDashboard,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              final isSelected = index == selectedIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: 2,
                ),
                child: ListTile(
                  selected: isSelected,
                  selectedTileColor: primaryColor.withValues(alpha: 0.08),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(defaultBorderRadious)),
                  ),
                  leading: _BadgedIcon(
                    icon: isSelected
                        ? destination.selectedIcon
                        : destination.icon,
                    count: destination.badgeCount,
                    color: isSelected ? primaryColor : null,
                  ),
                  title: Text(
                    destination.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? primaryColor : null,
                    ),
                  ),
                  onTap: () => onDestinationSelected(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  const _BadgedIcon({required this.icon, this.count = 0, this.color});

  final IconData icon;
  final int count;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final child = Icon(icon, color: color);
    if (count <= 0) return child;

    return Badge.count(count: count, child: child);
  }
}

/// Language switcher available from every dashboard screen.
class _LanguageMenu extends StatelessWidget {
  const _LanguageMenu();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (controller) {
        return PopupMenuButton<String>(
          tooltip: AppLocalizations.of(context).settingsSelectLanguage,
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.language.flag,
                  style: const TextStyle(fontSize: 18)),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
          onSelected: controller.setLanguage,
          itemBuilder: (context) => LocalizationController.supportedLanguages
              .map(
                (language) => PopupMenuItem<String>(
                  value: language.code,
                  child: Row(
                    children: [
                      Text(language.flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: defaultPadding / 2),
                      Text(language.nativeName),
                      if (language.code == controller.language.code) ...[
                        const Spacer(),
                        const Icon(Icons.check, size: 16, color: primaryColor),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AccountMenu extends StatelessWidget {
  const _AccountMenu();

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final controller = AdminAuthController.to;

    return Obx(
      () => PopupMenuButton<String>(
        tooltip: controller.user?.email ?? "",
        icon: const Icon(Icons.account_circle_outlined),
        onSelected: (value) {
          if (value == "signOut") controller.signOut();
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            enabled: false,
            child: Text(controller.user?.email ?? ""),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: "signOut",
            child: Row(
              children: [
                const Icon(Icons.logout, size: 18),
                const SizedBox(width: defaultPadding / 2),
                Text(translations.actionSignOut),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
