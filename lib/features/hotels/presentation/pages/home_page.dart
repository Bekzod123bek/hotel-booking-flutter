import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';
import '../cubit/hotels_cubit.dart';
import '../widgets/filter_sheet.dart';
import 'hotels_map_page.dart';
import '../widgets/hotel_widgets.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/breakpoints.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openMap(BuildContext context) {
    final cubit = context.read<HotelsCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            BlocProvider.value(value: cubit, child: const HotelsMapPage()),
      ),
    );
  }

  Future<void> _openFilters() async {
    final cubit = context.read<HotelsCubit>();
    final result = await showFilterSheet(context, cubit.state.filter);
    if (result != null) cubit.applyFilter(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AuthCubit c) => c.state.user);
    final l10n = context.l10n;
    final firstName = (user?.name ?? l10n.traveller).split(' ').first;
    final window = context.windowSize;
    final gutter = window.gutter;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: context.read<HotelsCubit>().load,
          child: BlocConsumer<HotelsCubit, HotelsState>(
            listenWhen: (a, b) =>
                a.locationIssue != b.locationIssue && b.locationIssue != null,
            listener: (context, state) => _showLocationIssue(context, state),
            builder: (context, state) {
              final filter = state.filter;
              final results = state.results;
              return ReadableWidth(
                maxWidth: window.readableWidth,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.helloUser(firstName),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.whereNext,
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: theme.colorScheme.primary,
                              child: Text(
                                user?.initials ?? '?',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(gutter, 20, gutter, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _search,
                                onChanged: context.read<HotelsCubit>().search,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  hintText: l10n.searchHint,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: filter.query.isEmpty
                                      ? null
                                      : IconButton(
                                          tooltip: l10n.clearSearch,
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            _search.clear();
                                            context.read<HotelsCubit>().search(
                                              '',
                                            );
                                          },
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Badge(
                              isLabelVisible: filter.activeCount > 0,
                              label: Text('${filter.activeCount}'),
                              child: IconButton.filled(
                                tooltip: l10n.filters,
                                style: IconButton.styleFrom(
                                  minimumSize: const Size(56, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: _openFilters,
                                icon: const Icon(Icons.tune),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton.filledTonal(
                              tooltip: l10n.mapView,
                              style: IconButton.styleFrom(
                                minimumSize: const Size(56, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => _openMap(context),
                              icon: const Icon(Icons.map_outlined),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 64,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.fromLTRB(
                            gutter - 4,
                            14,
                            gutter - 4,
                            6,
                          ),
                          children: [
                            _NearMeChip(
                              selected: filter.sort == HotelSort.nearest,
                              busy: state.locating,
                            ),
                            _CityChip(
                              label: l10n.all,
                              selected: filter.city == null,
                              onTap: () =>
                                  context.read<HotelsCubit>().selectCity(null),
                            ),
                            for (final c in state.cities)
                              _CityChip(
                                label: c,
                                selected: filter.city == c,
                                onTap: () =>
                                    context.read<HotelsCubit>().selectCity(c),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (state.loading && state.all.isEmpty)
                      ..._loadingSlivers()
                    else if (state.failed && state.all.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyState(
                          icon: Icons.cloud_off_outlined,
                          title: l10n.loadFailed,
                          message: l10n.errNetwork,
                          action: OutlinedButton(
                            onPressed: context.read<HotelsCubit>().load,
                            child: Text(l10n.retry),
                          ),
                        ),
                      )
                    else ...[
                      if (filter.isDefault && state.featured.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: SectionHeader(title: l10n.featuredStays),
                        ),
                        SliverToBoxAdapter(
                          child: _FeaturedCarousel(hotels: state.featured),
                        ),
                      ],
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          title: filter.isDefault
                              ? l10n.popularHotels
                              : l10n.staysFound(results.length),
                          trailing: _SortMenu(current: filter.sort),
                        ),
                      ),
                      if (results.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyState(
                            icon: Icons.search_off,
                            title: l10n.noHotelsTitle,
                            message: l10n.noHotelsMessage,
                            action: OutlinedButton(
                              onPressed: () {
                                _search.clear();
                                context.read<HotelsCubit>()
                                  ..search('')
                                  ..selectCity(null)
                                  ..resetFilters();
                              },
                              child: Text(l10n.clearAllFilters),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 24),
                          sliver: window.hotelColumns == 1
                              ? SliverList.separated(
                                  itemCount: results.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (_, i) => HotelCard(
                                    hotel: results[i],
                                    heroTag: 'list-${results[i].id}',
                                  ),
                                )
                              : SliverGrid.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: window.hotelColumns,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        mainAxisExtent: 320,
                                      ),
                                  itemCount: results.length,
                                  itemBuilder: (_, i) => HotelCard(
                                    hotel: results[i],
                                    heroTag: 'list-${results[i].id}',
                                  ),
                                ),
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLocationIssue(BuildContext context, HotelsState state) {
    final issue = state.locationIssue;
    if (issue == null) return;
    final cubit = context.read<HotelsCubit>();
    final l10n = context.l10n;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(issue.message(l10n)),
          duration: const Duration(seconds: 5),
          action: issue == LocationIssue.deniedForever
              ? SnackBarAction(
                  label: l10n.openSettings,
                  onPressed: cubit.openLocationSettings,
                )
              : null,
        ),
      );
    cubit.dismissLocationIssue();
  }

  List<Widget> _loadingSlivers() => [
    const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Skeleton(width: 160, height: 22, radius: 6),
      ),
    ),
    const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Skeleton(height: 220, radius: 24),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList.separated(
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(height: 20),
        itemBuilder: (_, _) => const HotelCardSkeleton(),
      ),
    ),
  ];
}

/// Sorts the list from the nearest hotel, asking for the location first.
class _NearMeChip extends StatelessWidget {
  const _NearMeChip({required this.selected, required this.busy});

  final bool selected;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        avatar: busy
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                selected ? Icons.my_location : Icons.near_me_outlined,
                size: 18,
              ),
        label: Text(busy ? l10n.findingLocation : l10n.nearMe),
        selected: selected,
        showCheckmark: false,
        onSelected: busy
            ? null
            : (_) => context.read<HotelsCubit>().findNearby(),
      ),
    );
  }
}

class _CityChip extends StatelessWidget {
  const _CityChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
    ),
  );
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.current});

  final HotelSort current;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HotelSort>(
      tooltip: context.l10n.sort,
      initialValue: current,
      onSelected: context.read<HotelsCubit>().setSort,
      itemBuilder: (_) => [
        for (final s in HotelSort.values)
          PopupMenuItem(value: s, child: Text(s.label(context.l10n))),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert, size: 18),
            const SizedBox(width: 4),
            Text(current.label(context.l10n)),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  const _FeaturedCarousel({required this.hotels});

  final List<Hotel> hotels;

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _controller = PageController(viewportFraction: 0.86);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.hotels.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: i == _page ? 0 : 12,
              ),
              child: FeaturedHotelCard(
                hotel: widget.hotels[i],
                heroTag: 'featured-${widget.hotels[i].id}',
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.hotels.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: i == _page ? scheme.primary : scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
