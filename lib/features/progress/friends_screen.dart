import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class FriendItem {
  final String name;
  final String avatar;
  final int streak;
  final int totalXp;
  final bool isFollowing;

  const FriendItem({
    required this.name,
    required this.avatar,
    required this.streak,
    required this.totalXp,
    required this.isFollowing,
  });
}

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final List<FriendItem> _friends = [
    const FriendItem(name: 'Sarah Connor', avatar: '👩‍🎤', streak: 12, totalXp: 620, isFollowing: true),
    const FriendItem(name: 'Marcus Vance', avatar: '👨‍💼', streak: 8, totalXp: 410, isFollowing: true),
    const FriendItem(name: 'Yuki Takahashi', avatar: '👩‍💻', streak: 15, totalXp: 740, isFollowing: true),
    const FriendItem(name: 'Daniel Silva', avatar: '👨‍🏫', streak: 5, totalXp: 280, isFollowing: false),
    const FriendItem(name: 'Maya Lin', avatar: '👩‍🔬', streak: 3, totalXp: 195, isFollowing: false),
  ];

  void _toggleFollow(int index) {
    setState(() {
      final f = _friends[index];
      _friends[index] = FriendItem(
        name: f.name,
        avatar: f.avatar,
        streak: f.streak,
        totalXp: f.totalXp,
        isFollowing: !f.isFollowing,
      );
    });
  }

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
          'Friends & Study Buddies',
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
            // Invite Friends Banner
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.primaryTint,
                  borderRadius: AppSpacing.brCard,
                  border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Text('💌', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invite Friends to LinguaGo',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Learn together and earn 100 bonus XP for each friend who joins.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenMargin,
                  vertical: 4,
                ),
                itemCount: _friends.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final friend = _friends[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: AppSpacing.brCard,
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Text(friend.avatar, style: const TextStyle(fontSize: 30)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend.name,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    '🔥 ${friend.streak}d streak',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.mutedText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '⚡ ${friend.totalXp} XP',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => _toggleFollow(i),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: friend.isFollowing
                                ? colors.background
                                : colors.primary,
                            side: BorderSide(
                              color: friend.isFollowing
                                  ? colors.border
                                  : colors.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.brFull,
                            ),
                          ),
                          child: Text(
                            friend.isFollowing ? 'Following' : 'Follow',
                            style: TextStyle(
                              color: friend.isFollowing
                                  ? colors.text
                                  : Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
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

