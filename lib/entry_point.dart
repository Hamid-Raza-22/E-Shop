import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/controllers/notification_controller.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/route/screen_export.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final List _pages = const [
    HomeScreen(),
    DiscoverScreen(),
    BookmarkScreen(),
    // EmptyCartScreen(), // if Cart is empty
    CartScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ??
                Theme.of(context).iconTheme.color!.withValues(alpha: 
                    Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        // floating: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/logo/Gogguz.svg",
          colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!, BlendMode.srcIn),
          height: 20,
          width: 100,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, notificationsScreenRoute);
            },
            icon: _UnreadNotificationIcon(
              child: SvgPicture.asset(
                "assets/icons/Notification.svg",
                height: 24,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!,
                    BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
      // body: _pages[_currentIndex],
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Shop.svg"),
              activeIcon: svgIcon("assets/icons/Shop.svg", color: primaryColor),
              label: translations.navHome,
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Category.svg"),
              activeIcon:
                  svgIcon("assets/icons/Category.svg", color: primaryColor),
              label: translations.navDiscover,
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Bookmark.svg"),
              activeIcon:
                  svgIcon("assets/icons/Bookmark.svg", color: primaryColor),
              label: translations.navBookmark,
            ),
            BottomNavigationBarItem(
              // Only this icon rebuilds when the cart changes, not the screen.
              icon: _CartTabIcon(child: svgIcon("assets/icons/Bag.svg")),
              activeIcon: _CartTabIcon(
                child: svgIcon("assets/icons/Bag.svg", color: primaryColor),
              ),
              label: translations.navCart,
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Profile.svg"),
              activeIcon:
                  svgIcon("assets/icons/Profile.svg", color: primaryColor),
              label: translations.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

/// App-bar bell with a live unread-count badge.
class _UnreadNotificationIcon extends StatelessWidget {
  const _UnreadNotificationIcon({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        final count = NotificationController.to.unreadCount;
        return Badge(
          isLabelVisible: count > 0,
          label: Text("$count"),
          child: child,
        );
      },
    );
  }
}

/// Cart tab icon with a live item-count badge.
///
/// Kept as its own widget so cart updates rebuild just the badge instead of the
/// whole [EntryPoint] subtree.
class _CartTabIcon extends StatelessWidget {
  const _CartTabIcon({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        final count = CartController.to.itemCount;
        return Badge(
          isLabelVisible: count > 0,
          label: Text("$count"),
          child: child,
        );
      },
    );
  }
}
