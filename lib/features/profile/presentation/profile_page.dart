import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_cubit.dart';
import '../../auth/presentation/cubit/auth_cubit.dart';
import '../../hotels/presentation/cubit/bookings_cubit.dart';
import '../../hotels/presentation/cubit/favorites_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Your favorites and bookings stay on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (ok == true) await auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AuthCubit c) => c.state.user);
    final bookings = context.watch<BookingsCubit>().state.length;
    final favorites = context.watch<FavoritesCubit>().state.length;
    final themeMode = context.watch<ThemeCubit>().state;
    final dark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && theme.brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.initials ?? '?',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Guest',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.luggage_outlined,
                  value: '$bookings',
                  label: 'Bookings',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Stat(
                  icon: Icons.favorite_border,
                  value: '$favorites',
                  label: 'Favorites',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  value: dark,
                  onChanged: context.read<ThemeCubit>().setDark,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About this app'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Hotel Booking',
                    applicationVersion: '1.0.0',
                    children: const [
                      Text(
                        'Demo project built with Flutter, Cubit, get_it and '
                        'Clean Architecture. Data is sample data and photos '
                        'are from Unsplash.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.textTheme.titleLarge),
                Text(label, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
