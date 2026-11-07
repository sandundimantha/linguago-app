import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/theme_preview_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ThemePreviewScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
