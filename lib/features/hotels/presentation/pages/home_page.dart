import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities.dart';
import '../cubit/hotels_cubit.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/hotel_widgets.dart';

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

  Future<void> _openFilters() async {
    final cubit = context.read<HotelsCubit>();
    final result = await showFilterSheet(context, cubit.state.filter);
    if (result != null) cubit.applyFilter(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AuthCubit c) => c.state.user);
    final firstName = (user?.name ?? 'traveller').split(' ').first;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: context.read<HotelsCubit>().load,
          child: BlocBuilder<HotelsCubit, HotelsState>(
            builder: (context, state) {
              final filter = state.filter;
              final results = state.results;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, $firstName 👋',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('Where to next?',
                                    style: theme.textTheme.headlineMedium),
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _search,
                              onChanged: context.read<HotelsCubit>().search,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: 'Search hotel or city',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: filter.query.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: 'Clear search',
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          _search.clear();
                                          context.read<HotelsCubit>().search('');
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
                              tooltip: 'Filters',
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
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 64,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                        children: [
                          _CityChip(
                            label: 'All',
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
                  else ...[
                    if (filter.isDefault && state.featured.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                        child: SectionHeader(title: 'Featured stays'),
                      ),
                      SliverToBoxAdapter(
                        child: _FeaturedCarousel(hotels: state.featured),
                      ),
                    ],
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: filter.isDefault
                            ? 'Popular hotels'
                            : '${results.length} '
                                '${results.length == 1 ? 'stay' : 'stays'} found',
                        trailing: _SortMenu(current: filter.sort),
                      ),
                    ),
                    if (results.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyState(
                          icon: Icons.search_off,
                          title: 'No hotels found',
                          message: 'Try another city or loosen the filters.',
                          action: OutlinedButton(
                            onPressed: () {
                              _search.clear();
                              context.read<HotelsCubit>()
                                ..search('')
                                ..selectCity(null)
                                ..resetFilters();
                            },
                            child: const Text('Clear all filters'),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        sliver: SliverList.separated(
                          itemCount: results.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 16),
                          itemBuilder: (_, i) => HotelCard(
                            hotel: results[i],
                            heroTag: 'list-${results[i].id}',
                          ),
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
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
      tooltip: 'Sort',
      initialValue: current,
      onSelected: context.read<HotelsCubit>().setSort,
      itemBuilder: (_) => [
        for (final s in HotelSort.values)
          PopupMenuItem(value: s, child: Text(s.label)),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert, size: 18),
            const SizedBox(width: 4),
            Text(current.label),
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
