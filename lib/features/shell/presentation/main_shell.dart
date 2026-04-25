import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/features/errands/presentation/errands_screen.dart';
import 'package:batseeku/features/home/presentation/home_screen.dart';
import 'package:batseeku/features/messages/presentation/messages_screen.dart';
import 'package:batseeku/features/profile/presentation/profile_screen.dart';
import 'package:batseeku/features/services/presentation/services_screen.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainShell extends ConsumerWidget {
  const MainShell({
    super.key,
    required this.tabIndex,
  });

  final int tabIndex;

  static const List<String> _titles = <String>[
    'Home',
    'Services',
    'Errands',
    'Messages',
    'Profile',
  ];

  static const List<String> _subtitles = <String>[
    'Campus support at a glance',
    'Find classmates ready to help',
    'Request and deliver errands',
    'Stay on top of conversations',
    'Account, reputation, and settings',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);

    final int normalizedTab = tabIndex < 0 || tabIndex > 4 ? 0 : tabIndex;
    final bool guestRestrictedTab =
        role == Role.guest && (normalizedTab == 2 || normalizedTab == 3);
    final int currentTab = guestRestrictedTab ? 0 : normalizedTab;

    final List<Widget> pages = <Widget>[
      const HomeScreen(),
      const ServicesScreen(),
      const ErrandsScreen(),
      const MessagesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.lg,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_titles[currentTab]),
            Text(
              _subtitles[currentTab],
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[AppColors.surface, AppColors.surfaceMuted],
            ),
            border: Border(
              bottom: BorderSide(color: AppColors.line),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: currentTab,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: NavigationBar(
          selectedIndex: currentTab,
          onDestinationSelected: (int nextIndex) {
            if (role == Role.guest && (nextIndex == 2 || nextIndex == 3)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Guest access is limited to Home, Services, and Profile.',
                  ),
                ),
              );
              return;
            }
            context.go('/app/$nextIndex');
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school_rounded),
              label: 'Services',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined),
              selectedIcon: Icon(Icons.local_shipping_rounded),
              label: 'Errands',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Messages',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
