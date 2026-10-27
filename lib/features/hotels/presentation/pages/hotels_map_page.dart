import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities.dart';
import '../cubit/hotels_cubit.dart';
import '../widgets/hotel_widgets.dart';

/// All hotels on one map. Tapping a marker opens its card at the bottom.
class HotelsMapPage extends StatefulWidget {
  const HotelsMapPage({super.key});

  /// Turned off in widget tests, where tiles cannot be downloaded.
  static bool networkEnabled = true;

  @override
  State<HotelsMapPage> createState() => _HotelsMapPageState();
}

class _HotelsMapPageState extends State<HotelsMapPage> {
  final _map = MapController();
  String? _selectedId;

  /// Fits every hotel (and the user) on screen.
  LatLngBounds? _boundsOf(List<Hotel> hotels, GeoPoint? origin) {
    final points = [
      for (final h in hotels) LatLng(h.latitude, h.longitude),
      if (origin != null) LatLng(origin.latitude, origin.longitude),
    ];
    if (points.isEmpty) return null;
    return LatLngBounds.fromPoints(points);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<HotelsCubit>().state;
    final hotels = state.results;
    final origin = state.origin;
    final selected = _selectedId == null
        ? null
        : hotels.where((h) => h.id == _selectedId).firstOrNull;
    final bounds = _boundsOf(hotels, origin);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.hotelsOnMap)),
      body: Stack(
        children: [
          Positioned.fill(
            child: HotelsMapPage.networkEnabled
                ? FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      initialCameraFit: bounds == null
                          ? null
                          : CameraFit.bounds(
                              bounds: bounds,
                              padding: const EdgeInsets.all(48),
                            ),
                      initialCenter: const LatLng(41.3111, 69.2797),
                      initialZoom: 5,
                      onTap: (_, _) => setState(() => _selectedId = null),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'dev.bekzod.hotel_booking',
                      ),
                      if (origin != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(origin.latitude, origin.longitude),
                              width: 28,
                              height: 28,
                              child: Tooltip(
                                message: l10n.youAreHere,
                                child: const _UserDot(),
                              ),
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          for (final hotel in hotels)
                            Marker(
                              point: LatLng(hotel.latitude, hotel.longitude),
                              width: 92,
                              height: 52,
                              alignment: Alignment.topCenter,
                              child: _PriceMarker(
                                hotel: hotel,
                                selected: hotel.id == _selectedId,
                                onTap: () =>
                                    setState(() => _selectedId = hotel.id),
                              ),
                            ),
                        ],
                      ),
                      const SimpleAttributionWidget(
                        source: Text('OpenStreetMap'),
                      ),
                    ],
                  )
                : ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: const Center(child: Icon(Icons.map_outlined)),
                  ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: _Note(text: l10n.sampleDataNote),
              ),
            ),
          ),
          if (selected != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: SafeArea(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: HotelTile(
                    hotel: selected,
                    heroTag: 'map-${selected.id}',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceMarker extends StatelessWidget {
  const _PriceMarker({
    required this.hotel,
    required this.selected,
    required this.onTap,
  });

  final Hotel hotel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: '${hotel.name}, \$${hotel.pricePerNight}',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: selected ? scheme.primary : scheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant,
                ),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black26),
                ],
              ),
              child: Text(
                '\$${hotel.pricePerNight}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? scheme.onPrimary : scheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: selected ? scheme.primary : scheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDot extends StatelessWidget {
  const _UserDot();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.primary,
        border: Border.all(color: scheme.onPrimary, width: 3),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black38)],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Flexible(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
