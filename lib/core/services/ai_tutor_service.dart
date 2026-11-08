import '../../data/models/ai_chat_models.dart';

abstract class AiTutorService {
  /// Send user message in the context of a scenario and previous conversation
  Future<ChatMessage> sendMessage({
    required ScenarioModel scenario,
    required List<ChatMessage> conversationHistory,
    required String userText,
  });
}

