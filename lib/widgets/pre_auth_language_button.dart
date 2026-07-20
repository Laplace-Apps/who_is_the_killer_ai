import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/language.dart';
import '../providers/language_provider.dart';

class PreAuthLanguageButton extends StatelessWidget {
  const PreAuthLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Semantics(
          button: true,
          label: languageProvider.t('language'),
          child: PopupMenuButton<Language>(
            tooltip: languageProvider.t('language'),
            initialValue: languageProvider.currentLanguage,
            onSelected: languageProvider.changeLanguage,
            itemBuilder: (context) {
              return languageProvider.supportedLanguages.map((language) {
                return PopupMenuItem(
                  value: language,
                  child: Row(
                    children: [
                      Icon(
                        language == languageProvider.currentLanguage
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(language.displayName),
                    ],
                  ),
                );
              }).toList();
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, size: 19),
                    const SizedBox(width: 7),
                    Text(
                      languageProvider.currentLanguage.code.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
