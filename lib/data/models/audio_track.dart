class AudioTrack {
  final String id;
  final String title;
  final String speaker;
  final String duration;
  final String audioUrl;
  final String category;
  final String level;
  final String transcript;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.speaker,
    required this.duration,
    required this.audioUrl,
    required this.category,
    required this.level,
    required this.transcript,
  });

  factory AudioTrack.fromJson(Map<String, dynamic> json) {
    return AudioTrack(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      speaker: json['speaker'] as String? ?? '',
      duration: json['duration'] as String? ?? '1:00',
      audioUrl: json['audioUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      level: json['level'] as String? ?? 'Intermediate',
      transcript: json['transcript'] as String? ?? '',
    );
  }
}

