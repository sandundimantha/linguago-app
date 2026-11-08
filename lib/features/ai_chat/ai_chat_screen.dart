import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import '../../app/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/ai_chat_models.dart';
import '../../core/services/ai_tutor_service.dart';

final aiTutorServiceProvider = Provider<AiTutorService>((ref) {
  // Configurable backend URL via environment or options
  return ref.watch(aiTutorServiceImplementationProvider);
});

class AiChatScreen extends ConsumerStatefulWidget {
  final ScenarioModel scenario;

  const AiChatScreen({
    super.key,
    required this.scenario,
  });

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    // Add initial message from scenario
    _messages.add(
      ChatMessage(
        id: 'initial_ai',
        sender: 'ai',
        text: widget.scenario.initialAiMessage,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.48);
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> _sendUserMessage() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'user',
      text: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _textCtrl.clear();
    });
    _scrollToBottom();

    try {
      final tutorService = ref.read(aiTutorServiceProvider);
      final reply = await tutorService.sendMessage(
        scenario: widget.scenario,
        conversationHistory: _messages,
        userText: text,
      );

      if (mounted) {
        setState(() {
          _messages.add(reply);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _messages.add(
            ChatMessage(
              id: 'err_${DateTime.now().millisecondsSinceEpoch}',
              sender: 'ai',
              text: 'Sorry, I missed that. Could you repeat that in another way?',
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.text),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(widget.scenario.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.scenario.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'AI Tutor: ${widget.scenario.aiRole}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.mutedText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Scenario Details',
            icon: Icon(Icons.info_outline_rounded, color: colors.mutedText),
            onPressed: () => _showScenarioDialog(context, colors, textTheme),
          ),
        ],
      ),
      body: Column(
        children: [
          // Background scenario banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colors.primary.withValues(alpha: 0.08),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    color: colors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.scenario.backgroundHint,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message, colors, textTheme);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tutor is typing...',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.mutedText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Bottom message input field
          _buildInputBar(colors, textTheme),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    AppCustomColors colors,
    TextTheme textTheme,
  ) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colors.primary.withValues(alpha: 0.15),
                  child: const Text('🤖', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? colors.primary : colors.card,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    border: Border.all(
                      color: isUser ? colors.primary : colors.border,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: isUser ? Colors.white : colors.text,
                          fontSize: 15,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isUser) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.volume_up_rounded,
                      size: 20, color: colors.mutedText),
                  onPressed: () => _speak(message.text),
                  tooltip: 'Listen',
                ),
              ],
            ],
          ),

          // Gentle correction banner if present
          if (message.correction != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 36, right: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_fix_high_rounded,
                            size: 16, color: colors.accent),
                        const SizedBox(width: 6),
                        Text(
                          'Tutor Suggestion',
                          style: TextStyle(
                            color: colors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.correction!,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (message.grammarTip != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        message.grammarTip!,
                        style: TextStyle(
                          color: colors.mutedText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputBar(AppCustomColors colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(
          top: BorderSide(color: colors.border, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textCtrl,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: colors.text, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    color: colors.mutedText.withValues(alpha: 0.7),
                  ),
                  filled: true,
                  fillColor: colors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
                onSubmitted: (_) => _sendUserMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: _sendUserMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScenarioDialog(
    BuildContext context,
    AppCustomColors colors,
    TextTheme textTheme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        title: Text(
          widget.scenario.title,
          style: TextStyle(color: colors.text, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scenario Details:',
                style: TextStyle(
                    color: colors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
            const SizedBox(height: 6),
            Text(widget.scenario.subtitle,
                style: TextStyle(color: colors.mutedText, fontSize: 13)),
            const SizedBox(height: 12),
            Text('Your Role: ${widget.scenario.userRole}',
                style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(height: 4),
            Text('AI Role: ${widget.scenario.aiRole}',
                style: TextStyle(
                    color: colors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: colors.primary)),
          ),
        ],
      ),
    );
  }
}

