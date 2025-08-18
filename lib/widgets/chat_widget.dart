import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../data/game_data.dart';
import '../providers/language_provider.dart';

class ChatWidget extends StatefulWidget {
  final Character character;
  final List<String> conversation;
  final bool isLoading;
  final Function(String) onSendMessage;
  final TextEditingController messageController;

  const ChatWidget({
    super.key,
    required this.character,
    required this.conversation,
    required this.isLoading,
    required this.onSendMessage,
    required this.messageController,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Karakter başlığı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.character.avatar,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.character.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.character.role,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showCharacterInfo(context),
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  iconSize: 20,
                ),
              ],
            ),
          ),

          // Sohbet alanı
          Expanded(
            child: widget.conversation.isEmpty
                ? _buildWelcomeMessage()
                : _buildConversationList(),
          ),

          // Mesaj gönderme alanı
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.character.avatar, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return Column(
                  children: [
                    Text(
                      '${widget.character.name} ${languageProvider.t('start_chat_with_character')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      languageProvider.t('ask_questions_for_clues'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return Column(
                  children: [
                    Text(
                      '💡 ${languageProvider.t('suggested_questions')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...GameData.getSuggestedQuestions(
                          languageProvider.currentLanguage,
                        )
                        .take(2)
                        .map(
                          (question) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: GestureDetector(
                              onTap: () => widget.onSendMessage(question),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  question,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
    );
  }

  Widget _buildConversationList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.conversation.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.conversation.length && widget.isLoading) {
          return _buildLoadingMessage();
        }

        final message = widget.conversation[index];
        final languageProvider = Provider.of<LanguageProvider>(
          context,
          listen: false,
        );
        final isUserMessage = message.startsWith(
          '${languageProvider.t('detective')}:',
        );

        return _buildMessageBubble(message, isUserMessage, languageProvider);
      },
    );
  }

  Widget _buildMessageBubble(
    String message,
    bool isUserMessage,
    LanguageProvider languageProvider,
  ) {
    final cleanMessage = message.replaceFirst(
      isUserMessage
          ? '${languageProvider.t('detective')}: '
          : '${widget.character.name}: ',
      '',
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            Text(widget.character.avatar, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? const Color(0xFFe94560)
                    : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUserMessage
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUserMessage
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Text(
                cleanMessage,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          if (isUserMessage) ...[
            const SizedBox(width: 8),
            const Icon(Icons.person, color: Colors.white, size: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(widget.character.avatar, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                16,
              ).copyWith(bottomLeft: const Radius.circular(4)),
            ),
            child: Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      languageProvider.t('character_typing'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return TextField(
                  controller: widget.messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: languageProvider.t('type_message'),
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xFFe94560)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (message) {
                    if (message.trim().isNotEmpty) {
                      widget.onSendMessage(message.trim());
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFe94560),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                final message = widget.messageController.text.trim();
                if (message.isNotEmpty) {
                  widget.onSendMessage(message);
                }
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showCharacterInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: Row(
          children: [
            Text(widget.character.avatar, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.character.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInfoRow(
                        languageProvider.t('role'),
                        widget.character.role,
                      ),
                      _buildInfoRow(
                        languageProvider.t('background'),
                        widget.character.background,
                      ),
                      _buildInfoRow(
                        languageProvider.t('personality'),
                        widget.character.personality,
                      ),
                      _buildInfoRow(
                        languageProvider.t('alibi'),
                        widget.character.alibi,
                      ),
                      _buildInfoRow(
                        languageProvider.t('motive'),
                        widget.character.motive,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
