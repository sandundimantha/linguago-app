import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class LeaderboardUser {
  final int rank;
  final String name;
  final String avatar;
  final int xp;
  final bool isCurrentUser;

  const LeaderboardUser({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.xp,
    this.isCurrentUser = false,
  });
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const List<LeaderboardUser> _board = [
    LeaderboardUser(rank: 1, name: 'Elena Rostova', avatar: '👩‍🎨', xp: 580),
    LeaderboardUser(rank: 2, name: 'Carlos Mendoza', avatar: '👨‍🚀', xp: 490),
    LeaderboardUser(rank: 3, name: 'Amina Al-Mansoor', avatar: '👩‍⚕️', xp: 460),
    LeaderboardUser(rank: 4, name: 'Sandun Dimantha', avatar: '👨‍💻', xp: 350, isCurrentUser: true),
    LeaderboardUser(rank: 5, name: 'Kenji Sato', avatar: '👨‍🎤', xp: 320),
    LeaderboardUser(rank: 6, name: 'Sophie Martin', avatar: '👩‍🏫', xp: 290),
    LeaderboardUser(rank: 7, name: 'Lucas Silva', avatar: '👨‍🎨', xp: 275),
    LeaderboardUser(rank: 8, name: 'Chloe Dubois', avatar: '👩‍🔬', xp: 240),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Sapphire League',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top 3 Podium
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PodiumSpot(user: _board[1], rank: 2, height: 110, colors: colors),
                  _PodiumSpot(user: _board[0], rank: 1, height: 140, colors: colors),
                  _PodiumSpot(user: _board[2], rank: 3, height: 95, colors: colors),
                ],
              ),
            ),

            // Ranking list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenMargin,
                  vertical: 8,
                ),
                itemCount: _board.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final user = _board[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: user.isCurrentUser
                          ? colors.primaryTint
                          : colors.card,
                      borderRadius: AppSpacing.brCard,
                      border: Border.all(
                        color: user.isCurrentUser
                            ? colors.primary
                            : colors.border,
                        width: user.isCurrentUser ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '#${user.rank}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: user.rank <= 3
                                ? colors.accent
                                : colors.mutedText,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(user.avatar, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.isCurrentUser ? '${user.name} (You)' : user.name,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: user.isCurrentUser
                                  ? FontWeight.w900
                                  : FontWeight.w700,
                              color: user.isCurrentUser
                                  ? colors.primary
                                  : colors.text,
                            ),
                          ),
                        ),
                        Text(
                          '${user.xp} XP',
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PodiumSpot extends StatelessWidget {
  final LeaderboardUser user;
  final int rank;
  final double height;
  final AppCustomColors colors;

  const _PodiumSpot({
    required this.user,
    required this.rank,
    required this.height,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final medal = rank == 1 ? '👑' : (rank == 2 ? '🥈' : '🥉');

    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(medal, style: const TextStyle(fontSize: 22)),
          Text(user.avatar, style: const TextStyle(fontSize: 34)),
          const SizedBox(height: 4),
          Text(
            user.name.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
          Text(
            '${user.xp} XP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: rank == 1 ? colors.primary : colors.card,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(color: colors.border),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: rank == 1 ? Colors.white : colors.mutedText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

