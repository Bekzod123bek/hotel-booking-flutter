import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/l10n/l10n.dart';
import 'core/layout/breakpoints.dart';
import 'core/widgets/glass_nav.dart';
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

  List<GlassNavItem> _items(AppLocalizations l10n) {
    final favorites = context.select((FavoritesCubit c) => c.state.length);
    final bookings = context.select((BookingsCubit c) => c.state.length);
    return [
      GlassNavItem(
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        label: l10n.navExplore,
      ),
      GlassNavItem(
        icon: Icons.favorite_border,
        selectedIcon: Icons.favorite,
        label: l10n.navFavorites,
        count: favorites,
      ),
      GlassNavItem(
        icon: Icons.luggage_outlined,
        selectedIcon: Icons.luggage,
        label: l10n.navBookings,
        count: bookings,
      ),
      GlassNavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: l10n.navProfile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _items(context.l10n);
    final window = context.windowSize;

    const pages = [HomePage(), FavoritesPage(), BookingsPage(), ProfilePage()];
    final body = IndexedStack(index: _index, children: pages);

    if (window.usesSideNavigation) {
      return Scaffold(
        body: Row(
          children: [
            GlassNavRail(
              items: items,
              selectedIndex: _index,
              onSelected: _select,
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    // The bar floats inside the body rather than as `bottomNavigationBar`, so
    // the pages scroll underneath the glass; they keep room for it through the
    // bottom padding injected below.
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: MediaQuery.paddingOf(context).copyWith(
                  bottom: GlassNavBar.spaceFor(context),
                ),
              ),
              child: body,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassNavBar(
              items: items,
              selectedIndex: _index,
              onSelected: _select,
            ),
          ),
        ],
      ),
    );
  }

  void _select(int i) => setState(() => _index = i);
}
