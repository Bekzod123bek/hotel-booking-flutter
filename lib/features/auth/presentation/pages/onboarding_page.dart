import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/breakpoints.dart';

const _images = [
  'https://images.unsplash.com/photo-1549294413-26f195200c16?w=900&q=80',
  'https://images.unsplash.com/photo-1625244724120-1fd1d34d00f6?w=900&q=80',
  'https://images.unsplash.com/photo-1551918120-9739cb430c6d?w=900&q=80',
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  bool get _last => _page == _images.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_last) {
      context.read<AuthCubit>().completeOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final titles = [l10n.onb1Title, l10n.onb2Title, l10n.onb3Title];
    final texts = [l10n.onb1Text, l10n.onb2Text, l10n.onb3Text];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => AppImage(_images[i]),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.35, 0.85],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ReadableWidth(
                maxWidth: 560,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: context.read<AuthCubit>().completeOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: Text(l10n.skip),
                    ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(_page),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titles[_page],
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          texts[_page],
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      for (var i = 0; i < _images.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          width: i == _page ? 26 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _page ? Colors.white : Colors.white38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      const Spacer(),
                      SizedBox(
                        width: 150,
                        child: GradientButton(
                          onPressed: _next,
                          child: Text(_last ? l10n.getStarted : l10n.next),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
