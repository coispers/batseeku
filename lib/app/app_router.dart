import 'package:batseeku/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/features/auth/presentation/launch_screen.dart';
import 'package:batseeku/features/auth/presentation/login_screen.dart';
import 'package:batseeku/features/messages/presentation/conversation_screen.dart';
import 'package:batseeku/features/services/presentation/freelancer_profile_screen.dart';
import 'package:batseeku/features/services/presentation/request_service_flow/request_matching_screen.dart';
import 'package:batseeku/features/services/presentation/request_service_flow/request_service_flow_screen.dart';
import 'package:batseeku/features/shell/presentation/main_shell.dart';
import 'package:batseeku/models/payment_option.dart';
import 'package:batseeku/models/role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/launch',
    redirect: (context, state) {
      final String location = state.matchedLocation;
      final bool onAuthScreen = location == '/launch' || location == '/login';
      final bool hasSession = authState.user != null;
      final Role role = authState.role;

      if (!hasSession) {
        if (onAuthScreen) {
          return null;
        }
        return '/launch';
      }

      if (role == Role.admin) {
        if (location != '/admin') {
          return '/admin';
        }
        return null;
      }

      if (location == '/admin') {
        return '/app/0';
      }

      if (onAuthScreen) {
        return '/app/0';
      }

      if (role == Role.guest) {
        if (location.startsWith('/services/request') ||
            location.startsWith('/messages/')) {
          return '/app/0';
        }
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/launch',
        builder: (context, state) => const LaunchScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/app/:tab',
        builder: (context, state) {
          final int tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
          return MainShell(tabIndex: tab);
        },
      ),
      GoRoute(
        path: '/services/freelancer/:id',
        builder: (context, state) {
          final String id = state.pathParameters['id'] ?? '';
          return FreelancerProfileScreen(freelancerId: id);
        },
      ),
      GoRoute(
        path: '/services/request/:id',
        builder: (context, state) {
          final String id = state.pathParameters['id'] ?? '';
          return RequestServiceFlowScreen(freelancerId: id);
        },
      ),
      GoRoute(
        path: '/services/request/:id/matching',
        builder: (context, state) {
          final RequestMatchingArgs args = state.extra is RequestMatchingArgs
              ? state.extra! as RequestMatchingArgs
              : const RequestMatchingArgs(
                  freelancerName: 'Tutor',
                  serviceType: 'Tutoring',
                  estimatedPrice: 220,
                  paymentOption: PaymentOption.cash,
                );
          return RequestMatchingScreen(args: args);
        },
      ),
      GoRoute(
        path: '/messages/:id',
        builder: (context, state) {
          final String id = state.pathParameters['id'] ?? '';
          return ConversationScreen(threadId: id);
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
