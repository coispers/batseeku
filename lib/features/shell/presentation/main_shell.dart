import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/features/errands/presentation/errands_screen.dart';
import 'package:batseeku/features/home/presentation/home_screen.dart';
import 'package:batseeku/features/messages/presentation/messages_screen.dart';
import 'package:batseeku/features/profile/presentation/profile_screen.dart';
import 'package:batseeku/features/services/presentation/services_screen.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainShell extends ConsumerWidget {
  const MainShell({
    super.key,
    required this.tabIndex,
  });

  final int tabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final _RoleShellConfig shellConfig = _configForRole(role);

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
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(shellConfig.titles[currentTab]),
                ),
                AppStatusBadge(
                  label: shellConfig.roleLabel,
                  tone: shellConfig.roleTone,
                  icon: shellConfig.roleIcon,
                ),
              ],
            ),
            Text(
              shellConfig.subtitles[currentTab],
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                shellConfig.appBarTop,
                shellConfig.appBarBottom,
              ],
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
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: shellConfig.navLabels[0],
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school_rounded),
              label: shellConfig.navLabels[1],
            ),
            NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined),
              selectedIcon: Icon(Icons.local_shipping_rounded),
              label: shellConfig.navLabels[2],
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble_rounded),
              label: shellConfig.navLabels[3],
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: shellConfig.navLabels[4],
            ),
          ],
        ),
      ),
    );
  }

  _RoleShellConfig _configForRole(Role role) {
    if (role == Role.freelancer) {
      return const _RoleShellConfig(
        roleLabel: 'Freelancer',
        roleTone: AppStatusTone.success,
        roleIcon: Icons.bolt_rounded,
        appBarTop: AppColors.successSurface,
        appBarBottom: AppColors.surface,
        titles: <String>[
          'Freelancer Hub',
          'Service Demand',
          'Job Board',
          'Client Messages',
          'Freelancer Profile',
        ],
        subtitles: <String>[
          'Track opportunities and your active status',
          'See what students are requesting right now',
          'Accept and deliver nearby campus tasks',
          'Coordinate timelines and progress updates',
          'Manage availability, ratings, and earnings',
        ],
        navLabels: <String>[
          'Hub',
          'Demand',
          'Jobs',
          'Chats',
          'Profile',
        ],
      );
    }

    if (role == Role.student) {
      return const _RoleShellConfig(
        roleLabel: 'Customer',
        roleTone: AppStatusTone.accent,
        roleIcon: Icons.shopping_bag_rounded,
        appBarTop: AppColors.maroonSoft,
        appBarBottom: AppColors.surface,
        titles: <String>[
          'Customer Home',
          'Find Services',
          'Task Requests',
          'Conversations',
          'Customer Profile',
        ],
        subtitles: <String>[
          'Start requests and discover trusted helpers',
          'Compare freelancers by skill, rating, and rate',
          'Post errands and monitor responses',
          'Keep all service updates in one place',
          'Review account details and request history',
        ],
        navLabels: <String>[
          'Home',
          'Services',
          'Requests',
          'Messages',
          'Profile',
        ],
      );
    }

    return const _RoleShellConfig(
      roleLabel: 'Guest',
      roleTone: AppStatusTone.neutral,
      roleIcon: Icons.visibility_outlined,
      appBarTop: AppColors.surface,
      appBarBottom: AppColors.surfaceMuted,
      titles: <String>[
        'Explore',
        'Services',
        'Errands',
        'Messages',
        'Profile',
      ],
      subtitles: <String>[
        'Preview what the campus marketplace offers',
        'Browse available freelancers',
        'Sign in to post or accept errands',
        'Sign in to access conversations',
        'Sign in to manage your account',
      ],
      navLabels: <String>[
        'Home',
        'Services',
        'Errands',
        'Messages',
        'Profile',
      ],
    );
  }
}

class _RoleShellConfig {
  const _RoleShellConfig({
    required this.roleLabel,
    required this.roleTone,
    required this.roleIcon,
    required this.appBarTop,
    required this.appBarBottom,
    required this.titles,
    required this.subtitles,
    required this.navLabels,
  });

  final String roleLabel;
  final AppStatusTone roleTone;
  final IconData roleIcon;
  final Color appBarTop;
  final Color appBarBottom;
  final List<String> titles;
  final List<String> subtitles;
  final List<String> navLabels;
}
