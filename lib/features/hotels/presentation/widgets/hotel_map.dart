import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities.dart';

/// OpenStreetMap preview of the hotel. Tapping it opens the phone's maps app.
class HotelMap extends StatelessWidget {
  const HotelMap({super.key, required this.hotel});

  /// Turned off in widget tests, where real network calls are not possible.
  static bool networkEnabled = true;

  final Hotel hotel;

  LatLng get _position => LatLng(hotel.latitude, hotel.longitude);

  Future<void> _open(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.l10n.mapUnavailable;
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${hotel.latitude},${hotel.longitude}',
    });
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication)
        .catchError((_) => false);
    if (!opened) messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 190,
        child: Stack(
          children: [
            Positioned.fill(
              child: networkEnabled
                  ? FlutterMap(
                      options: MapOptions(
                        initialCenter: _position,
                        initialZoom: 14,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                        onTap: (_, _) => _open(context),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'dev.bekzod.hotel_booking',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _position,
                              width: 48,
                              height: 48,
                              alignment: Alignment.topCenter,
                              child: Icon(
                                Icons.location_on,
                                size: 44,
                                color: scheme.error,
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
                      color: scheme.primaryContainer,
                      child: Icon(Icons.map_outlined, color: scheme.primary),
                    ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => _open(context),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: Text(context.l10n.openInMaps),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
