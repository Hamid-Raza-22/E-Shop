import 'package:flutter/widgets.dart';

/// Layout size buckets used by the dashboard.
enum ScreenSize { mobile, tablet, desktop }

/// Breakpoints and helpers for the responsive admin layouts.
///
/// Material 3 window-size classes are used so the dashboard behaves the same on
/// a phone, a tablet and the web build:
/// * `< 720`  — compact: bottom-sheet navigation drawer, single column
/// * `< 1200` — medium: navigation rail, two columns
/// * `>=1200` — expanded: permanent sidebar, three/four columns
class Responsive {
  const Responsive._();

  static const double tabletBreakpoint = 720;
  static const double desktopBreakpoint = 1200;

  static ScreenSize of(BuildContext context) =>
      sizeOf(MediaQuery.sizeOf(context).width);

  static ScreenSize sizeOf(double width) {
    if (width >= desktopBreakpoint) return ScreenSize.desktop;
    if (width >= tabletBreakpoint) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenSize.mobile;

  static bool isTablet(BuildContext context) =>
      of(context) == ScreenSize.tablet;

  static bool isDesktop(BuildContext context) =>
      of(context) == ScreenSize.desktop;

  /// Picks the value matching the current width, falling back to the next
  /// smaller bucket when a value is not supplied.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) =>
      switch (of(context)) {
        ScreenSize.desktop => desktop ?? tablet ?? mobile,
        ScreenSize.tablet => tablet ?? mobile,
        ScreenSize.mobile => mobile,
      };

  /// Number of grid columns for KPI/metric cards.
  static int gridColumns(BuildContext context) =>
      value(context, mobile: 1, tablet: 2, desktop: 4);

  /// Keeps content readable on very wide screens.
  static double maxContentWidth(BuildContext context) =>
      value(context, mobile: double.infinity, desktop: 1440);
}

/// Builds different widget trees per size bucket without repeating MediaQuery
/// lookups at every call site.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return switch (Responsive.sizeOf(constraints.maxWidth)) {
          ScreenSize.desktop => (desktop ?? tablet ?? mobile)(context),
          ScreenSize.tablet => (tablet ?? mobile)(context),
          ScreenSize.mobile => mobile(context),
        };
      },
    );
  }
}
