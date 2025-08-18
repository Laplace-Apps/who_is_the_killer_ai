import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../providers/language_provider.dart';

class DecisionDialog extends StatelessWidget {
  final List<Character> characters;
  final Function(Character) onDecision;

  const DecisionDialog({
    super.key,
    required this.characters,
    required this.onDecision,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF16213e),
      title: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Text(
            languageProvider.t('final_decision'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Text(
                languageProvider.t('decision_description'),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              );
            },
          ),
          const SizedBox(height: 24),
          ...characters.map(
            (character) => _buildCharacterOption(context, character),
          ),
        ],
      ),
      actions: [
        Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                languageProvider.t('cancel'),
                style: const TextStyle(color: Colors.white70),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCharacterOption(BuildContext context, Character character) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onDecision(character);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Text(character.avatar, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      character.role,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
