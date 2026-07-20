import 'package:flutter/material.dart';

import '../theme/mystery_theme.dart';

enum AuthFeedbackTone { error, success }

class AuthFeedbackBanner extends StatelessWidget {
  const AuthFeedbackBanner({
    super.key,
    required this.message,
    required this.tone,
  });

  final String message;
  final AuthFeedbackTone tone;

  @override
  Widget build(BuildContext context) {
    final isError = tone == AuthFeedbackTone.error;
    final color = isError
        ? Theme.of(context).colorScheme.error
        : context.mystery.success;

    return Semantics(
      liveRegion: true,
      label: message,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.65)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: color,
              size: 21,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: color, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
