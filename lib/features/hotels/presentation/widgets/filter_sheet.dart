import 'package:flutter/material.dart';

import '../../data/sample_hotels.dart';
import '../../domain/entities.dart';
import 'hotel_widgets.dart';
import '../../../../core/l10n/l10n.dart';

/// Opens the filter sheet and returns the new filter, or `null` if dismissed.
Future<HotelFilter?> showFilterSheet(
  BuildContext context,
  HotelFilter current,
) {
  return showModalBottomSheet<HotelFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _FilterSheet(initial: current),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});

  final HotelFilter initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late RangeValues _price = RangeValues(
    widget.initial.minPrice.toDouble(),
    widget.initial.maxPrice.toDouble(),
  );
  late double _rating = widget.initial.minRating;
  late final Set<String> _amenities = {...widget.initial.amenities};
  late HotelSort _sort = widget.initial.sort;

  void _reset() => setState(() {
    _price = const RangeValues(0, HotelFilter.maxPriceLimit * 1.0);
    _rating = 0;
    _amenities.clear();
    _sort = HotelSort.recommended;
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(l10n.filtersTitle, style: theme.textTheme.titleLarge),
                const Spacer(),
                TextButton(onPressed: _reset, child: Text(l10n.reset)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                _Label(l10n.sortBy),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in HotelSort.values)
                      ChoiceChip(
                        label: Text(s.label(l10n)),
                        selected: _sort == s,
                        onSelected: (_) => setState(() => _sort = s),
                      ),
                  ],
                ),
                _Label(
                  l10n.priceRange(
                    _price.start.round(),
                    _price.end.round(),
                    _price.end >= HotelFilter.maxPriceLimit ? '+' : '',
                  ),
                ),
                RangeSlider(
                  values: _price,
                  max: HotelFilter.maxPriceLimit.toDouble(),
                  divisions: 30,
                  labels: RangeLabels(
                    '\$${_price.start.round()}',
                    '\$${_price.end.round()}',
                  ),
                  onChanged: (v) => setState(() => _price = v),
                ),
                _Label(l10n.minimumRating),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final r in const [0.0, 4.0, 4.3, 4.5, 4.7])
                      ChoiceChip(
                        avatar: r == 0
                            ? null
                            : const Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Color(0xFFFFB547),
                              ),
                        label: Text(
                          r == 0 ? l10n.any : '${r.toStringAsFixed(1)}+',
                        ),
                        selected: _rating == r,
                        onSelected: (_) => setState(() => _rating = r),
                      ),
                  ],
                ),
                _Label(l10n.amenities),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final a in allAmenities)
                      FilterChip(
                        avatar: Icon(amenityIcon(a), size: 18),
                        label: Text(amenityLabel(l10n, a)),
                        selected: _amenities.contains(a),
                        onSelected: (on) => setState(
                          () => on ? _amenities.add(a) : _amenities.remove(a),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(
                  widget.initial.copyWith(
                    minPrice: _price.start.round(),
                    maxPrice: _price.end.round(),
                    minRating: _rating,
                    amenities: {..._amenities},
                    sort: _sort,
                  ),
                ),
                child: Text(l10n.showResults),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}
