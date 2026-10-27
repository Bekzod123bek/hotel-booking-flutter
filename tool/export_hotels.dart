// Writes the bundled sample hotels to tool/hotels.json:
//
//   dart run tool/export_hotels.dart
import 'dart:convert';
import 'dart:io';

import 'package:hotel_booking/features/hotels/data/firebase/hotel_dto.dart';
import 'package:hotel_booking/features/hotels/data/sample_hotels.dart';

void main() {
  final out = {for (final h in sampleHotels) h.id: hotelToMap(h)};
  File('tool/hotels.json')
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(out));
  stdout.writeln('Wrote ${out.length} hotels to tool/hotels.json');
}
