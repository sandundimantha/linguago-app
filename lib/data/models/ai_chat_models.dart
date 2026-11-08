class ScenarioModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String aiRole;
  final String userRole;
  final String initialAiMessage;
  final String level; // Beginner, Intermediate, Advanced
  final String iconName;
  final String emoji;
  final String backgroundHint;

  const ScenarioModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.aiRole,
    required this.userRole,
    required this.initialAiMessage,
    required this.level,
    required this.iconName,
    required this.emoji,
    required this.backgroundHint,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'aiRole': aiRole,
      'userRole': userRole,
      'initialAiMessage': initialAiMessage,
      'level': level,
      'iconName': iconName,
      'emoji': emoji,
      'backgroundHint': backgroundHint,
    };
  }

  factory ScenarioModel.fromMap(Map<String, dynamic> map) {
    return ScenarioModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      category: map['category'] as String,
      aiRole: map['aiRole'] as String,
      userRole: map['userRole'] as String,
      initialAiMessage: map['initialAiMessage'] as String,
      level: map['level'] as String,
      iconName: map['iconName'] as String,
      emoji: map['emoji'] as String,
      backgroundHint: map['backgroundHint'] as String,
    );
  }
}

class ChatMessage {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final String? correction; // Friendly correction for single error
  final String? grammarTip;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.correction,
    this.grammarTip,
    required this.timestamp,
  });

  bool get isUser => sender == 'user';

  ChatMessage copyWith({
    String? id,
    String? sender,
    String? text,
    String? correction,
    String? grammarTip,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      text: text ?? this.text,
      correction: correction ?? this.correction,
      grammarTip: grammarTip ?? this.grammarTip,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'text': text,
      'correction': correction,
      'grammarTip': grammarTip,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      sender: map['sender'] as String,
      text: map['text'] as String,
      correction: map['correction'] as String?,
      grammarTip: map['grammarTip'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
