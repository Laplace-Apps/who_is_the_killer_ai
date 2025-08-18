import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/language_provider.dart';
import '../models/character.dart';
import '../models/game_state.dart';
import '../data/game_data.dart';
import '../widgets/character_card.dart';
import '../widgets/chat_widget.dart';
import '../widgets/decision_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Oyun durumunu yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false).loadGameState();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              if (gameProvider.gameState == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final gameState = gameProvider.gameState!;

              // Oyun tamamlandıysa sonuç ekranı
              if (gameState.gameCompleted) {
                return _buildGameResult(gameProvider);
              }

              return Column(
                children: [
                  // App Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Consumer<LanguageProvider>(
                            builder: (context, languageProvider, child) {
                              return Text(
                                languageProvider.t('detective_game'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showGameInfo(context),
                          icon: const Icon(Icons.info, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Ana içerik - ScrollView ile sarılmış
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hikaye özeti
                          _buildStorySummary(gameState),

                          const SizedBox(height: 16),

                          // Karakterler
                          _buildCharactersList(gameProvider, gameState),

                          const SizedBox(height: 16),

                          // Sohbet alanı
                          if (gameProvider.currentCharacter != null) ...[
                            Container(
                              // Sabit yükseklik
                              height: 500,
                              child: ChatWidget(
                                character: gameProvider.currentCharacter!,
                                conversation: gameProvider.currentConversation,
                                isLoading: gameProvider.isLoading,
                                onSendMessage: (message) {
                                  final languageProvider =
                                      Provider.of<LanguageProvider>(
                                        context,
                                        listen: false,
                                      );
                                  gameProvider.chatWithCharacter(
                                    message,
                                    languageProvider,
                                  );
                                  _messageController.clear();
                                },
                                messageController: _messageController,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Karar verme butonu
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _showDecisionDialog(context, gameProvider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFe94560),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Consumer<LanguageProvider>(
                                  builder: (context, languageProvider, child) {
                                    return Text(
                                      languageProvider.t('make_final_decision'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStorySummary(GameState gameState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.book, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                gameState.storyTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${languageProvider.t('victim')}: ${gameState.victim}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${languageProvider.t('crime_scene')}: ${gameState.crimeScene}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharactersList(GameProvider gameProvider, GameState gameState) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gameState.characters.length,
        itemBuilder: (context, index) {
          final character = gameState.characters[index];
          final isSelected =
              gameProvider.currentCharacter?.name == character.name;

          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            child: CharacterCard(
              character: character,
              isSelected: isSelected,
              onTap: () => gameProvider.selectCharacter(character),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameResult(GameProvider gameProvider) {
    final selectedKiller = gameProvider.gameState!.selectedKiller!;
    final isCorrect = gameProvider.isCorrectGuess();
    final realKiller = gameProvider.getRealKiller();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            size: 80,
            color: isCorrect ? Colors.green : Colors.red,
          ),

          const SizedBox(height: 24),

          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Column(
                children: [
                  Text(
                    isCorrect
                        ? languageProvider.t('congratulations')
                        : languageProvider.t('wrong_guess'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    isCorrect
                        ? languageProvider.t('found_real_killer')
                        : languageProvider.t('wrong_person_selected'),
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Consumer<LanguageProvider>(
                  builder: (context, languageProvider, child) {
                    return Column(
                      children: [
                        Text(
                          '${languageProvider.t('your_choice')}: ${selectedKiller.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${languageProvider.t('role')}: ${selectedKiller.role}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          if (!isCorrect && realKiller != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) {
                      return Text(
                        languageProvider.t('real_killer'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${realKiller.name} (${realKiller.role})',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 60),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                await gameProvider.resetGame();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFe94560),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                  return Text(
                    languageProvider.t('new_game'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showDecisionDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => DecisionDialog(
        characters: gameProvider.gameState!.characters,
        onDecision: (character) {
          gameProvider.makeFinalDecision(character);
        },
      ),
    );
  }

  void _showGameInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return Text(
              languageProvider.t('game_info'),
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GameData.getGameInstructions(
                          languageProvider.currentLanguage,
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '💡 ${languageProvider.t('suggested_questions')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...GameData.getSuggestedQuestions(
                            languageProvider.currentLanguage,
                          )
                          .take(5)
                          .map(
                            (question) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '• $question',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  languageProvider.t('ok'),
                  style: const TextStyle(color: Color(0xFFe94560)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
