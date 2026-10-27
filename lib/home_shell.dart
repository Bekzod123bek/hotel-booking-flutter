import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/hotels/presentation/cubit/bookings_cubit.dart';
import 'features/hotels/presentation/cubit/favorites_cubit.dart';
import 'features/hotels/presentation/pages/bookings_page.dart';
import 'features/hotels/presentation/pages/favorites_page.dart';
import 'features/hotels/presentation/pages/home_page.dart';
import 'features/profile/presentation/profile_page.dart';
import 'core/l10n/l10n.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final favorites = context.select((FavoritesCubit c) => c.state.length);
    final bookings = context.select((BookingsCubit c) => c.state.length);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          FavoritesPage(),
          BookingsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: l10n.navExplore,
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: favorites > 0,
              label: Text('$favorites'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: const Icon(Icons.favorite),
            label: l10n.navFavorites,
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: bookings > 0,
              label: Text('$bookings'),
              child: const Icon(Icons.luggage_outlined),
            ),
            selectedIcon: const Icon(Icons.luggage),
            label: l10n.navBookings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
