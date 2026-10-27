import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The main call to action: a pill with the brand gradient.
///
/// Falls back to a flat disabled colour when [onPressed] is `null`, so the
/// button never looks tappable when it is not.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 56,
    this.gradient,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double height;

  /// Overrides the brand gradient, for example on a destructive action.
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: enabled ? (gradient ?? AppTheme.primaryGradient) : null,
          color: enabled ? null : scheme.onSurface.withValues(alpha: 0.12),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppTheme.primaryEnd.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const StadiumBorder(),
            child: Container(
              height: height,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: enabled
                      ? Colors.white
                      : scheme.onSurface.withValues(alpha: 0.38),
                ),
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: enabled
                        ? Colors.white
                        : scheme.onSurface.withValues(alpha: 0.38),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// White circular button used over photos (back, favourite, share).
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        color: color ?? scheme.onSurface,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
