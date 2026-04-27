import 'package:batseeku/data/mock/seed_data.dart';
import 'package:batseeku/models/app_user.dart';
import 'package:batseeku/models/role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String universityEmailSuffix = '@g.batstate-u.edu.ph';

bool isUniversityEmail(String value) {
  return value.trim().toLowerCase().endsWith(universityEmailSuffix);
}

String? validateUniversityEmail(String? value) {
  final String email = (value ?? '').trim().toLowerCase();
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (!isUniversityEmail(email)) {
    return 'Use your BatStateU email ($universityEmailSuffix)';
  }
  return null;
}

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  final AppUser? user;
  final bool isLoading;
  final String? error;

  Role get role => user?.role ?? Role.guest;
  bool get isAuthenticated => user != null && role != Role.guest;

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MockAuthService {
  static const Map<String, String> _credentialMap = <String, String>{
    'student1@g.batstate-u.edu.ph': '123456',
    'tutor1@g.batstate-u.edu.ph': '123456',
    'admin@g.batstate-u.edu.ph': 'admin123',
  };

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final String normalizedEmail = email.trim().toLowerCase();
    if (!isUniversityEmail(normalizedEmail)) {
      throw const AuthException(
        'Only @g.batstate-u.edu.ph emails are allowed in this MVP.',
      );
    }

    final String? expectedPassword = _credentialMap[normalizedEmail];
    if (expectedPassword == null || expectedPassword != password.trim()) {
      throw const AuthException('Invalid credentials. Please try again.');
    }

    for (final AppUser user in SeedData.users) {
      if (user.email.toLowerCase() == normalizedEmail) {
        return user;
      }
    }

    throw const AuthException('No mock account mapped for this email.');
  }

  AppUser continueAsGuest() {
    return const AppUser(
      id: 'guest',
      name: 'Guest Viewer',
      email: 'guest@batseeku.local',
      role: Role.guest,
      isVerified: false,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authService) : super(const AuthState());

  final MockAuthService _authService;

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final AppUser user = await _authService.login(
        email: email,
        password: password,
      );
      state = AuthState(user: user, isLoading: false);
      return true;
    } on AuthException catch (error) {
      state = AuthState(error: error.message, isLoading: false);
      return false;
    }
  }

  void enterGuestMode() {
    state = AuthState(user: _authService.continueAsGuest());
  }

  void logout() {
    state = const AuthState();
  }

  bool switchCustomerFreelancerRole() {
    final AppUser? currentUser = state.user;
    if (currentUser == null) {
      return false;
    }

    final Role currentRole = currentUser.role;
    if (currentRole != Role.student && currentRole != Role.freelancer) {
      return false;
    }

    final Role nextRole =
        currentRole == Role.student ? Role.freelancer : Role.student;
    state = state.copyWith(
      user: currentUser.copyWith(role: nextRole),
      clearError: true,
    );
    return true;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}

final authServiceProvider = Provider<MockAuthService>(
  (Ref ref) => MockAuthService(),
);

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (Ref ref) => AuthController(ref.watch(authServiceProvider)),
);

final currentUserProvider = Provider<AppUser?>(
  (Ref ref) => ref.watch(authControllerProvider).user,
);

final currentRoleProvider = Provider<Role>(
  (Ref ref) => ref.watch(authControllerProvider).role,
);
