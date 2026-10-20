import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/hotels/presentation/cubit/bookings_cubit.dart';
import 'features/hotels/presentation/cubit/hotels_cubit.dart';
import 'features/hotels/presentation/pages/hotels_page.dart';
import 'features/hotels/presentation/pages/my_bookings_page.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HotelsCubit>()),
        BlocProvider.value(value: sl<BookingsCubit>()),
      ],
      child: MaterialApp(
        title: 'Hotel Booking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF2E7D6B),
          useMaterial3: true,
        ),
        home: const _HomeShell(),
      ),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [HotelsPage(), MyBookingsPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Hotels'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_border), label: 'Bookings'),
        ],
      ),
    );
  }
}
