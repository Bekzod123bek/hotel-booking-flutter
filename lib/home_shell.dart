import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/l10n/l10n.dart';
import 'core/layout/breakpoints.dart';
import 'features/hotels/presentation/cubit/bookings_cubit.dart';
import 'features/hotels/presentation/cubit/favorites_cubit.dart';
import 'features/hotels/presentation/pages/bookings_page.dart';
import 'features/hotels/presentation/pages/favorites_page.dart';
import 'features/hotels/presentation/pages/home_page.dart';
import 'features/profile/presentation/profile_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  /// One entry per tab; the icons and counters are shared by the bottom bar
  /// and the side rail.
  List<_Destination> _destinations(AppLocalizations l10n) {
    final favorites = context.select((FavoritesCubit c) => c.state.length);
    final bookings = context.select((BookingsCubit c) => c.state.length);
    return [
      _Destination(Icons.explore_outlined, Icons.explore, l10n.navExplore, 0),
      _Destination(
        Icons.favorite_border,
        Icons.favorite,
        l10n.navFavorites,
        favorites,
      ),
      _Destination(
        Icons.luggage_outlined,
        Icons.luggage,
        l10n.navBookings,
        bookings,
      ),
      _Destination(Icons.person_outline, Icons.person, l10n.navProfile, 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final window = context.windowSize;
    final destinations = _destinations(l10n);

    const pages = [HomePage(), FavoritesPage(), BookingsPage(), ProfilePage()];
    final body = IndexedStack(index: _index, children: pages);

    if (!window.usesSideNavigation) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _select,
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                icon: d.badged(Icon(d.icon)),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    // Wide window: the rail replaces the bottom bar, and it shows labels once
    // there is room for them.
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: _select,
            labelType: window == WindowSize.medium
                ? NavigationRailLabelType.selected
                : NavigationRailLabelType.all,
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(
                  icon: d.badged(Icon(d.icon)),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }

  void _select(int i) => setState(() => _index = i);
}

class _Destination {
  const _Destination(this.icon, this.selectedIcon, this.label, this.count);

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Shown as a badge; `0` means no badge.
  final int count;

  Widget badged(Widget child) =>
      count == 0 ? child : Badge(label: Text('$count'), child: child);
}
