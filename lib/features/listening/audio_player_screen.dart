import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../app/providers.dart';

class AudioPlayerScreen extends ConsumerStatefulWidget {
  final String trackId;

  const AudioPlayerScreen({super.key, required this.trackId});

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen> {
  late final AudioPlayer _player;
  bool _showTranscript = true;
  double _playbackSpeed = 1.0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    final tracks = await ref.read(audioTracksProvider.future);
    final track = tracks.firstWhere(
      (t) => t.id == widget.trackId,
      orElse: () => tracks.first,
    );

    try {
      await _player.setUrl(track.audioUrl);
    } catch (_) {
      // Offline fallback: set synthetic duration
      if (mounted) {
        setState(() {
          _duration = const Duration(minutes: 1, seconds: 15);
        });
      }
    }

    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
      }
    });

    _player.positionStream.listen((pos) {
      if (mounted) {
        setState(() => _position = pos);
      }
    });

    _player.durationStream.listen((dur) {
      if (dur != null && mounted) {
        setState(() => _duration = dur);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _changeSpeed() {
    final speeds = [0.75, 1.0, 1.25, 1.5];
    final nextIndex = (speeds.indexOf(_playbackSpeed) + 1) % speeds.length;
    final nextSpeed = speeds[nextIndex];
    _player.setSpeed(nextSpeed);
    setState(() => _playbackSpeed = nextSpeed);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final tracksAsync = ref.watch(audioTracksProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Audio Player',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: tracksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tracks) {
          final track = tracks.firstWhere(
            (t) => t.id == widget.trackId,
            orElse: () => tracks.first,
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.vGapMd,

                  // Player Hero Card
                  AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6)
                                .withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.headphones_rounded,
                            size: 44,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          track.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          track.speaker,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.mutedText,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Progress slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF8B5CF6),
                            inactiveTrackColor: colors.border,
                            thumbColor: const Color(0xFF8B5CF6),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _duration.inMilliseconds > 0
                                ? (_position.inMilliseconds /
                                        _duration.inMilliseconds)
                                    .clamp(0.0, 1.0)
                                : 0.0,
                            onChanged: (val) {
                              final newPos = Duration(
                                  milliseconds:
                                      (val * _duration.inMilliseconds).round());
                              _player.seek(newPos);
                            },
                          ),
                        ),

                        // Timestamps row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_position),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.mutedText,
                                ),
                              ),
                              Text(
                                _formatDuration(_duration),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Controls Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Speed Button
                            TextButton(
                              onPressed: _changeSpeed,
                              style: TextButton.styleFrom(
                                backgroundColor: colors.background,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppSpacing.brFull,
                                  side: BorderSide(color: colors.border),
                                ),
                              ),
                              child: Text(
                                '${_playbackSpeed}x',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Rewind 10s
                            IconButton(
                              icon: const Icon(Icons.replay_10_rounded),
                              iconSize: 32,
                              color: colors.text,
                              onPressed: () {
                                final target = _position -
                                    const Duration(seconds: 10);
                                _player.seek(target < Duration.zero
                                    ? Duration.zero
                                    : target);
                              },
                            ),
                            const SizedBox(width: 16),

                            // Play / Pause FAB
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8B5CF6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Forward 10s
                            IconButton(
                              icon: const Icon(Icons.forward_10_rounded),
                              iconSize: 32,
                              color: colors.text,
                              onPressed: () {
                                final target = _position +
                                    const Duration(seconds: 10);
                                _player.seek(
                                    target > _duration ? _duration : target);
                              },
                            ),
                            const SizedBox(width: 24),

                            // Transcript toggle icon
                            IconButton(
                              icon: Icon(
                                _showTranscript
                                    ? Icons.subtitles_rounded
                                    : Icons.subtitles_off_rounded,
                                color: _showTranscript
                                    ? const Color(0xFF8B5CF6)
                                    : colors.mutedText,
                              ),
                              onPressed: () => setState(
                                  () => _showTranscript = !_showTranscript),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapLg,

                  // Transcript Section
                  if (_showTranscript) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Interactive Transcript',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primaryTint,
                            borderRadius: AppSpacing.brFull,
                          ),
                          child: Text(
                            'Synchronized',
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGapMd,
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: AppSpacing.brCard,
                        border: Border.all(color: colors.border),
                      ),
                      child: SelectableText(
                        track.transcript,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.text,
                          height: 1.8,
                        ),
                      ),
                    ),
                    AppSpacing.vGapLg,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

