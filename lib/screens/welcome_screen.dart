import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../theme/mystery_theme.dart';
import '../widgets/mystery_background.dart';
import '../widgets/pre_auth_language_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onSignIn,
    required this.onCreateAccount,
  });

  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();

    return Scaffold(
      body: MysteryBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: PreAuthLanguageButton(),
                  ),
                ),
                const Spacer(flex: 2),
                Semantics(
                  image: true,
                  label: language.t('app_title'),
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: context.mystery.accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.mystery.accent.withValues(alpha: 0.55),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.fingerprint_rounded,
                      size: 62,
                      color: context.mystery.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  language.t('game_title'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Text(
                    language.t('welcome_tagline'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.72),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _FeatureChip(
                      icon: Icons.question_answer_outlined,
                      label: language.t('welcome_feature_chat'),
                    ),
                    _FeatureChip(
                      icon: Icons.manage_search_rounded,
                      label: language.t('welcome_feature_clues'),
                    ),
                    _FeatureChip(
                      icon: Icons.gavel_outlined,
                      label: language.t('welcome_feature_decide'),
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      FilledButton(
                        key: const Key('welcome-sign-in'),
                        onPressed: onSignIn,
                        child: Text(language.t('sign_in')),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        key: const Key('welcome-create-account'),
                        onPressed: onCreateAccount,
                        child: Text(language.t('create_account')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: context.mystery.surfaceRaised.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.mystery.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: context.mystery.accent, size: 18),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
