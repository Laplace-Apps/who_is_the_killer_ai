import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/investigation_game.dart';
import '../models/language.dart';
import '../providers/game_provider.dart';
import '../providers/language_provider.dart';
import '../services/case_content_repository.dart';
import '../widgets/chat_widget.dart';
import '../widgets/decision_dialog.dart';
import 'home_screen.dart';

class InvestigationScreen extends StatefulWidget {
  const InvestigationScreen({super.key});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  InvestigationGame? _game;
  final TextEditingController _messageController = TextEditingController();
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrapGame());
  }

  void _bootstrapGame() {
    final gameProvider = context.read<GameProvider>();
    final languageProvider = context.read<LanguageProvider>();
    final state = gameProvider.gameState;
    if (state == null) return;

    unawaited(gameProvider.ensureCaseContent());

    final game = InvestigationGame(
      onEvent: (event) {
        gameProvider.handleInvestigationEvent(event);
        if (!mounted) return;

        final state = gameProvider.gameState;
        if (state != null) {
          _game?.syncUnlocks(
            state.unlockedLocationIds,
            state.discoveredClueIds,
          );
        }

        if (event.suspectId != null && !_sheetOpen) {
          _openInterrogation();
        }
        if (event.clueId != null) {
          _game?.markClueDiscovered(event.clueId!);
          _showClueToast(event.clueId!);
        }
      },
      characters: state.characters,
      unlockedLocationIds: state.unlockedLocationIds,
      discoveredClueIds: state.discoveredClueIds,
      isPortalAllowed: ({
        required bool requiresUnlock,
        List<String> requiredClueIds = const [],
        String? destinationRoomId,
      }) {
        return gameProvider.canEnterPortal(
          requiresUnlock: requiresUnlock,
          requiredClueIds: requiredClueIds,
          destinationRoomId: destinationRoomId,
        );
      },
      language: languageProvider.currentLanguage,
      initialRoomId: state.currentRoomId,
      initialPlayerX: state.playerX,
      initialPlayerY: state.playerY,
    );

    setState(() => _game = game);
  }

  Future<void> _openInterrogation() async {
    final gameProvider = context.read<GameProvider>();
    if (gameProvider.currentCharacter == null) return;
    _sheetOpen = true;
    _game?.pauseEngine();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121A24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer2<GameProvider, LanguageProvider>(
          builder: (context, gp, lp, _) {
            final character = gp.currentCharacter;
            if (character == null) {
              return const SizedBox(height: 200);
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: ChatWidget(
                      character: character,
                      conversation: gp.currentConversation,
                      isLoading: gp.isLoading,
                      messageController: _messageController,
                      onSendMessage: (message) {
                        gp.chatWithCharacter(message, lp);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    _sheetOpen = false;
    gameProvider.clearPendingSuspect();
    _game?.resumeEngine();
  }

  Future<void> _openNotebook() async {
    final gameProvider = context.read<GameProvider>();
    final languageProvider = context.read<LanguageProvider>();
    _game?.pauseEngine();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121A24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (context, controller) {
            return _NotebookSheet(
              scrollController: controller,
              gameProvider: gameProvider,
              language: languageProvider.currentLanguage,
              caseContent: gameProvider.caseContent,
              onAccuse: () async {
                Navigator.pop(context);
                await _openAccuse();
              },
            );
          },
        );
      },
    );

    _game?.resumeEngine();
  }

  Future<void> _openAccuse() async {
    final gameProvider = context.read<GameProvider>();
    final languageProvider = context.read<LanguageProvider>();
    final state = gameProvider.gameState;
    if (state == null) return;

    if (!state.canAccuse) {
      final missing = state.missingAccusationClues.join(', ');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            languageProvider.currentLanguage == Language.turkish
                ? 'Suçlama için eksik kanıt: $missing'
                : 'Missing evidence to accuse: $missing',
          ),
        ),
      );
      return;
    }

    _game?.pauseEngine();
    await showDialog<void>(
      context: context,
      builder: (context) => DecisionDialog(
        characters: state.characters,
        onDecision: (selected) async {
          final result = await gameProvider.makeFinalDecision(selected);
          if (!context.mounted) return;
          final isTr = languageProvider.currentLanguage == Language.turkish;
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF1A2430),
                title: Text(
                  result.isCorrect
                      ? languageProvider.t('you_win')
                      : languageProvider.t('you_lose'),
                  style: const TextStyle(color: Colors.white),
                ),
                content: Text(
                  isTr ? result.messageTr : result.messageEn,
                  style: const TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      );
                    },
                    child: Text(languageProvider.t('back_to_menu')),
                  ),
                ],
              );
            },
          );
        },
      ),
    );

    _game?.resumeEngine();
  }

  void _showClueToast(String clueId) {
    final languageProvider = context.read<LanguageProvider>();
    final caseContent = context.read<GameProvider>().caseContent;
    final clue = caseContent?.clueById(clueId);
    final label = clue?.title(languageProvider.currentLanguage) ?? clueId;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageProvider.currentLanguage == Language.turkish
              ? 'Kanıt bulundu: $label'
              : 'Clue found: $label',
        ),
        backgroundColor: const Color(0xFF2A4A3A),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameProvider, LanguageProvider>(
      builder: (context, gameProvider, languageProvider, _) {
        final state = gameProvider.gameState;
        if (state == null || _game == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B121A),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final room = _game!.currentRoom;
        final roomName = room == null
            ? ''
            : (languageProvider.currentLanguage == Language.turkish
                ? room.nameTr
                : room.nameEn);
        final isTr = languageProvider.currentLanguage == Language.turkish;

        return Scaffold(
          backgroundColor: const Color(0xFF0B121A),
          body: Stack(
            children: [
              Positioned.fill(child: GameWidget(game: _game!)),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Material(
                      color: const Color(0xCC0B121A),
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: isTr ? 'Geri' : 'Back',
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                  (_) => false,
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                roomName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            _HudIconButton(
                              icon: Icons.menu_book,
                              badge: '${state.discoveredClueIds.length}',
                              tooltip: isTr ? 'Defter' : 'Notebook',
                              onTap: _openNotebook,
                            ),
                            _HudIconButton(
                              icon: Icons.gavel,
                              tooltip: isTr ? 'Suçla' : 'Accuse',
                              onTap: _openAccuse,
                            ),
                            _HudIconButton(
                              icon: _game!.paused
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              tooltip: isTr
                                  ? (_game!.paused ? 'Devam' : 'Duraklat')
                                  : (_game!.paused ? 'Resume' : 'Pause'),
                              onTap: () {
                                final next = !_game!.paused;
                                _game!.setPaused(next);
                                setState(() {});
                              },
                            ),
                            _HudIconButton(
                              icon: Icons.language,
                              badge: isTr ? 'EN' : 'TR',
                              tooltip: isTr ? 'Dil' : 'Language',
                              onTap: () {
                                final next = isTr
                                    ? Language.english
                                    : Language.turkish;
                                languageProvider.changeLanguage(next);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 150,
                child: state.proximityPrompt == null
                    ? const SizedBox.shrink()
                    : Center(
                        child: Material(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              final prompt =
                                  state.proximityPrompt!.toLowerCase();
                              if (prompt.contains('talk') ||
                                  prompt.contains('konuş')) {
                                _game?.tryTalkNearest();
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Text(
                                state.proximityPrompt!,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              Positioned(
                left: 24,
                bottom: 28,
                child: _VirtualJoystick(
                  key: const ValueKey('investigation-joystick'),
                  onChanged: (offset) {
                    _game?.setJoystick(offset);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HudIconButton extends StatelessWidget {
  const _HudIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.badge,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              if (badge != null) ...[
                const SizedBox(width: 4),
                Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _VirtualJoystick extends StatefulWidget {
  const _VirtualJoystick({super.key, required this.onChanged});

  final ValueChanged<Offset> onChanged;

  @override
  State<_VirtualJoystick> createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<_VirtualJoystick> {
  Offset _knob = Offset.zero;
  int? _activePointer;

  @override
  void dispose() {
    // Stop the detective if the HUD rebuilds while a finger is down.
    widget.onChanged(Offset.zero);
    super.dispose();
  }

  void _reset() {
    if (!mounted) {
      widget.onChanged(Offset.zero);
      return;
    }
    _activePointer = null;
    if (_knob != Offset.zero) {
      setState(() => _knob = Offset.zero);
    }
    widget.onChanged(Offset.zero);
  }

  void _updateKnob(Offset localPosition) {
    if (!mounted) return;
    const size = 110.0;
    final center = const Offset(size / 2, size / 2);
    var delta = localPosition - center;
    if (delta.distance > 40) {
      delta = Offset.fromDirection(delta.direction, 40);
    }
    setState(() => _knob = delta);
    widget.onChanged(Offset(delta.dx / 40, delta.dy / 40));
  }

  @override
  Widget build(BuildContext context) {
    const size = 110.0;
    return SizedBox(
      width: size,
      height: size,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (!mounted) return;
          _activePointer = event.pointer;
          _updateKnob(event.localPosition);
        },
        onPointerMove: (event) {
          if (!mounted) return;
          if (_activePointer != null && event.pointer != _activePointer) {
            return;
          }
          _updateKnob(event.localPosition);
        },
        onPointerUp: (_) => _reset(),
        onPointerCancel: (_) => _reset(),
        child: CustomPaint(
          painter: _JoystickPainter(knob: _knob),
        ),
      ),
    );
  }
}

class _JoystickPainter extends CustomPainter {
  _JoystickPainter({required this.knob});

  final Offset knob;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 48, Paint()..color = Colors.white12);
    canvas.drawCircle(
      center + knob,
      22,
      Paint()..color = Colors.white54,
    );
  }

  @override
  bool shouldRepaint(covariant _JoystickPainter oldDelegate) =>
      oldDelegate.knob != knob;
}

class _NotebookSheet extends StatelessWidget {
  const _NotebookSheet({
    required this.scrollController,
    required this.gameProvider,
    required this.language,
    required this.caseContent,
    required this.onAccuse,
  });

  final ScrollController scrollController;
  final GameProvider gameProvider;
  final Language language;
  final CasePublicContent? caseContent;
  final VoidCallback onAccuse;

  @override
  Widget build(BuildContext context) {
    final state = gameProvider.gameState!;
    final isTr = language == Language.turkish;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        controller: scrollController,
        children: [
          Text(
            isTr ? 'Dedektif Defteri' : 'Detective Notebook',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTr
                ? 'Kanıtlar: ${state.discoveredClueIds.length}'
                : 'Clues: ${state.discoveredClueIds.length}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          if (state.discoveredClueIds.isEmpty)
            Text(
              isTr
                  ? 'Henüz kanıt bulmadınız. Odaları gezin.'
                  : 'No clues yet. Explore the rooms.',
              style: const TextStyle(color: Colors.white54),
            ),
          ...state.discoveredClueIds.map((id) {
            final clue = caseContent?.clueById(id);
            return Card(
              color: const Color(0xFF1C2834),
              child: ListTile(
                title: Text(
                  clue?.title(language) ?? id,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  clue?.description(language) ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Text(
            isTr
                ? 'Suçlama için gerekli: ${state.requiredAccusationClueIds.join(', ')}'
                : 'Required to accuse: ${state.requiredAccusationClueIds.join(', ')}',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: state.canAccuse ? onAccuse : null,
            icon: const Icon(Icons.gavel),
            label: Text(isTr ? 'Resmi Suçlama' : 'Formal Accusation'),
          ),
        ],
      ),
    );
  }
}
