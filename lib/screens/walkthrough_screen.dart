import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/onboarding_preferences.dart';
import '../theme/mystery_theme.dart';
import '../widgets/mystery_background.dart';
import '../widgets/pre_auth_language_button.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({
    super.key,
    required this.preferences,
    required this.onCompleted,
  });

  final OnboardingPreferences preferences;
  final VoidCallback onCompleted;

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  bool _isCompleting = false;

  static const _pages = [
    _WalkthroughPageData(
      icon: Icons.search_rounded,
      titleKey: 'walkthrough_title_1',
      descriptionKey: 'walkthrough_description_1',
    ),
    _WalkthroughPageData(
      icon: Icons.record_voice_over_rounded,
      titleKey: 'walkthrough_title_2',
      descriptionKey: 'walkthrough_description_2',
    ),
    _WalkthroughPageData(
      icon: Icons.fact_check_outlined,
      titleKey: 'walkthrough_title_3',
      descriptionKey: 'walkthrough_description_3',
    ),
    _WalkthroughPageData(
      icon: Icons.gavel_rounded,
      titleKey: 'walkthrough_title_4',
      descriptionKey: 'walkthrough_description_4',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    await widget.preferences.markCompleted();
    if (mounted) widget.onCompleted();
  }

  Future<void> _goToPage(int page) async {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _pageController.jumpToPage(page);
      return;
    }
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final isLastPage = _pageIndex == _pages.length - 1;

    return Scaffold(
      body: MysteryBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PreAuthLanguageButton(),
                    TextButton(
                      onPressed: _isCompleting ? null : _complete,
                      child: Text(language.t('skip')),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _pageIndex = index),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _WalkthroughPage(
                      icon: page.icon,
                      title: language.t(page.titleKey),
                      description: language.t(page.descriptionKey),
                    );
                  },
                ),
              ),
              Semantics(
                label: language
                    .t('walkthrough_progress')
                    .replaceAll('{current}', '${_pageIndex + 1}')
                    .replaceAll('{total}', '${_pages.length}'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    final selected = index == _pageIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: selected ? 28 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selected
                            ? context.mystery.accent
                            : context.mystery.outline,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Row(
                  children: [
                    if (_pageIndex > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _goToPage(_pageIndex - 1),
                          child: Text(language.t('back')),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: _pageIndex > 0 ? 1 : 2,
                      child: FilledButton(
                        onPressed: _isCompleting
                            ? null
                            : isLastPage
                            ? _complete
                            : () => _goToPage(_pageIndex + 1),
                        child: _isCompleting
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                language.t(isLastPage ? 'get_started' : 'next'),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalkthroughPage extends StatelessWidget {
  const _WalkthroughPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Semantics(
            excludeSemantics: true,
            child: Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                color: context.mystery.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.mystery.accent.withValues(alpha: 0.5),
                ),
              ),
              child: Icon(icon, size: 58, color: context.mystery.accent),
            ),
          ),
          const SizedBox(height: 38),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.72),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalkthroughPageData {
  const _WalkthroughPageData({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  });

  final IconData icon;
  final String titleKey;
  final String descriptionKey;
}
