import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vocab_grammar_models.dart';
import 'spaced_repetition_scheduler.dart';

class VocabGrammarRepository {
  final SpacedRepetitionScheduler srs;
  List<VocabWord>? _cachedVocab;
  List<GrammarTopic>? _cachedGrammar;

  VocabGrammarRepository(this.srs);

  Future<List<VocabWord>> loadVocab() async {
    if (_cachedVocab != null) return _cachedVocab!;
    final raw = await rootBundle.loadString('assets/vocab.json');
    final list = (json.decode(raw) as List)
        .map((e) => VocabWord.fromJson(e as Map<String, dynamic>))
        .toList();
    _cachedVocab = list;
    return list;
  }

  Future<List<GrammarTopic>> loadGrammar() async {
    if (_cachedGrammar != null) return _cachedGrammar!;
    final raw = await rootBundle.loadString('assets/grammar.json');
    final list = (json.decode(raw) as List)
        .map((e) => GrammarTopic.fromJson(e as Map<String, dynamic>))
        .toList();
    _cachedGrammar = list;
    return list;
  }

  Future<VocabWord?> getWordById(String id) async {
    final all = await loadVocab();
    for (final w in all) {
      if (w.id == id) return w;
    }
    return null;
  }

  Future<GrammarTopic?> getGrammarTopicById(String id) async {
    final all = await loadGrammar();
    for (final t in all) {
      if (t.id == id) return t;
    }
    return null;
  }

  Future<List<VocabWord>> getDueWords() async {
    final all = await loadVocab();
    return all.where((w) => srs.isDue(w.id)).toList();
  }
}

