import 'package:go_router/go_router.dart';
import 'package:salvation_bible_app/view/main_navigation/main_navigation_screen.dart';

enum AppRoutes { chapterSelector }

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.chapterSelector.name,
      builder: (context, state) => MainNavigationScreen(),
    ),
  ],
);
