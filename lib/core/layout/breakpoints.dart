import 'package:flutter/widgets.dart';

/// Material 3 window size classes, measured on the available width.
enum WindowSize {
  /// Phone in portrait.
  compact,

  /// Large phone in landscape, small tablet.
  medium,

  /// Tablet, small desktop window.
  expanded,

  /// Desktop.
  large;

  static WindowSize fromWidth(double width) {
    if (width < 600) return WindowSize.compact;
    if (width < 840) return WindowSize.medium;
    if (width < 1200) return WindowSize.expanded;
    return WindowSize.large;
  }

  bool get isCompact => this == WindowSize.compact;

  /// Navigation moves to the side as soon as the window is wider than a phone.
  bool get usesSideNavigation => this != WindowSize.compact;

  /// Hotels are shown in this many columns.
  int get hotelColumns => switch (this) {
    WindowSize.compact => 1,
    WindowSize.medium => 2,
    WindowSize.expanded => 2,
    WindowSize.large => 3,
  };

  /// Width a single column of text or cards should not exceed, so lines stay
  /// readable on a wide screen.
  double get readableWidth => switch (this) {
    WindowSize.compact => double.infinity,
    WindowSize.medium => 720,
    WindowSize.expanded => 900,
    WindowSize.large => 1100,
  };

  /// Side padding of a page.
  double get gutter => isCompact ? 20 : 28;
}

extension WindowSizeContext on BuildContext {
  /// Size class of the window. Prefer a [LayoutBuilder] inside a pane that is
  /// narrower than the window itself.
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}

/// Centers [child] and stops it from growing wider than the readable width.
class ReadableWidth extends StatelessWidget {
  const ReadableWidth({super.key, required this.child, this.maxWidth});

  final Widget child;

  /// Overrides the width taken from the window size class.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? context.windowSize.readableWidth,
        ),
        child: child,
      ),
    );
  }
}

/// Sliver version of [ReadableWidth].
class SliverReadableWidth extends StatelessWidget {
  const SliverReadableWidth({super.key, required this.sliver, this.maxWidth});

  final Widget sliver;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? context.windowSize.readableWidth;
    if (width == double.infinity) return sliver;
    final free = MediaQuery.sizeOf(context).width - width;
    final side = free > 0 ? free / 2 : 0.0;
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: side),
      sliver: sliver,
    );
  }
}
