import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// One entry of [GlassNavBar] / [GlassNavRail].
class GlassNavItem {
  const GlassNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.count = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Shown as a small badge; `0` means no badge.
  final int count;
}

/// Floating translucent navigation pill: the page scrolls behind it and is
/// blurred by it, the way iOS 26 glass controls behave.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  /// Height of the pill itself, without the margin around it.
  static const barHeight = 66.0;

  /// Margin between the pill and the window edges.
  static const _margin = 12.0;

  /// How much room the bar takes from the bottom of a page. Pages add this to
  /// their own padding, then a gap of their choosing on top.
  static double spaceFor(BuildContext context) =>
      barHeight + _margin + MediaQuery.paddingOf(context).bottom;

  final List<GlassNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, _margin),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: _GlassSurface(
              borderRadius: BorderRadius.circular(barHeight / 2),
              child: SizedBox(
                height: barHeight,
                child: Row(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: _GlassNavButton(
                          item: items[i],
                          selected: i == selectedIndex,
                          onTap: () => onSelected(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The same pill standing up, for tablet and desktop windows.
class GlassNavRail extends StatelessWidget {
  const GlassNavRail({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<GlassNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Center(
          child: _GlassSurface(
            borderRadius: BorderRadius.circular(36),
            child: SizedBox(
              width: 86,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  for (var i = 0; i < items.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: SizedBox(
                        height: 62,
                        child: _GlassNavButton(
                          item: items[i],
                          selected: i == selectedIndex,
                          onTap: () => onSelected(i),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Frosted, lightly outlined panel: the shared look of both bars.
class _GlassSurface extends StatelessWidget {
  const _GlassSurface({required this.borderRadius, required this.child});

  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: Shadows.lift(colors),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              // Tinted rather than opaque, so the page shows through.
              color: colors.glassTint,
              border: Border.all(color: colors.glassBorder, width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _GlassNavButton extends StatelessWidget {
  const _GlassNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    final icon = Icon(
      selected ? item.selectedIcon : item.icon,
      size: 23,
      color: color,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: AnimatedContainer(
          duration: Motion.normal,
          curve: Curves.easeOut,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: selected
                ? scheme.primary.withValues(alpha: 0.14)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: item.count == 0
                    ? icon
                    : Badge(label: Text('${item.count}'), child: icon),
              ),
              const SizedBox(height: 3),
              ExcludeSemantics(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
