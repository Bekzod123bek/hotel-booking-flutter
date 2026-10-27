import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/l10n/locale_cubit.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';
import 'features/hotels/presentation/cubit/bookings_cubit.dart';
import 'features/hotels/presentation/cubit/favorites_cubit.dart';
import 'features/hotels/presentation/cubit/hotels_cubit.dart';
import 'firebase_options.dart';
import 'home_shell.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebase = await initFirebase();
  await setupDependencies(firebase: firebase);
  runApp(const HotelBookingApp());
}

/// Connects to Firebase. Returns `false` when the project is not configured
/// (see lib/firebase_options.dart), in which case the app runs in demo mode.
/// Pass `--dart-define=DEMO_MODE=true` to force demo mode.
Future<bool> initFirebase() async {
  if (const bool.fromEnvironment('DEMO_MODE')) return false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  } catch (e) {
    debugPrint('Firebase is not available, using local demo mode: $e');
    return false;
  }
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<LocaleCubit>()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<HotelsCubit>()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()),
        BlocProvider(create: (_) => sl<BookingsCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (a, b) => a.status != b.status,
        listener: (context, state) {
          final favorites = context.read<FavoritesCubit>();
          final bookings = context.read<BookingsCubit>();
          if (state.status == AuthStatus.authenticated) {
            favorites.load();
            bookings.load();
          } else {
            favorites.clear();
            bookings.clear();
          }
        },
        child: BlocBuilder<LocaleCubit, Locale?>(
          builder: (context, locale) => BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appTitle,
              debugShowCheckedModeBanner: false,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: LocaleCubit.resolve,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: mode,
              home: BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (a, b) => a.status != b.status,
                builder: (context, state) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: switch (state.status) {
                    AuthStatus.onboarding => const OnboardingPage(),
                    AuthStatus.unauthenticated => const LoginPage(),
                    AuthStatus.authenticated => const HomeShell(),
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
