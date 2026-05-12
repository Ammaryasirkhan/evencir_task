import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/mood/presentation/mood_page.dart';
import '../../features/nutrition/presentation/nutrition_page.dart';
import '../../features/plan/presentation/plan_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../utils/app_assets.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/nutrition',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/nutrition',
              name: 'nutrition',
              builder: (context, state) => const NutritionPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/plan',
              name: 'plan',
              builder: (context, state) => const PlanPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mood',
              name: 'mood',
              builder: (context, state) => const MoodPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<_NavItemData> _items = [
    _NavItemData(label: 'Nutrition', iconPath: AppAssets.nutrition),
    _NavItemData(label: 'Plan', iconPath: AppAssets.plan),
    _NavItemData(label: 'Mood', iconPath: AppAssets.mood),
    _NavItemData(label: 'Profile', iconPath: AppAssets.profile),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF0C0F17),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          indicatorColor: Colors.transparent,
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          destinations: _items
              .map(
                (item) => NavigationDestination(
                  icon: ImageIcon(
                    AssetImage(item.iconPath),
                    color: Colors.white60,
                  ),
                  selectedIcon: ImageIcon(
                    AssetImage(item.iconPath),
                    color: Colors.white,
                  ),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.label, required this.iconPath});

  final String label;
  final String iconPath;
}
