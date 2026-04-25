import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    final String? universityRule =
        validateUniversityEmail(_emailController.text);

    if (!isValid || universityRule != null) {
      setState(() {});
      return;
    }

    final bool success = await ref.read(authControllerProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );

    if (!mounted) {
      return;
    }

    final Role role = ref.read(currentRoleProvider);
    if (success) {
      if (role == Role.admin) {
        context.go('/admin');
      } else {
        context.go('/app/0');
      }
    }
  }

  void _fillCredentials(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authControllerProvider);
    final String? universityError = _emailController.text.isEmpty
        ? null
        : validateUniversityEmail(_emailController.text);
    final bool isWide =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;

    final Widget introPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppReveal(
          child: AppContentCard(
            tone: AppCardTone.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome to BatSeekU',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Campus gigs, errands, and peer support in one place.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                const _FeaturePoint(
                  icon: Icons.school_rounded,
                  text: 'Match with freelancers by skills and rating',
                ),
                const _FeaturePoint(
                  icon: Icons.local_shipping_rounded,
                  text: 'Post and manage campus errands quickly',
                ),
                const _FeaturePoint(
                  icon: Icons.forum_rounded,
                  text: 'Track chat threads and service progress',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppReveal(
          delay: const Duration(milliseconds: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppSectionHeader(
                title: 'Quick Fill Accounts',
                subtitle: 'Use mock credentials for each role in one tap.',
                compact: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: <Widget>[
                  _QuickFillChip(
                    label: 'Student',
                    onTap: () => _fillCredentials(
                      'student1@g.batstate-u.edu.ph',
                      '123456',
                    ),
                  ),
                  _QuickFillChip(
                    label: 'Freelancer',
                    onTap: () => _fillCredentials(
                      'tutor1@g.batstate-u.edu.ph',
                      '123456',
                    ),
                  ),
                  _QuickFillChip(
                    label: 'Admin',
                    onTap: () => _fillCredentials(
                      'admin@g.batstate-u.edu.ph',
                      'admin123',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final Widget formPanel = AppReveal(
      delay: const Duration(milliseconds: 140),
      child: AppContentCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppSectionHeader(
                title: 'Log In',
                subtitle: 'Use your university account or continue as guest.',
                compact: true,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'University Email',
                  hintText: 'student1@g.batstate-u.edu.ph',
                ),
                validator: validateUniversityEmail,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Allowed suffix: @g.batstate-u.edu.ph',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (universityError != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  universityError,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.danger),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (String? value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Password is required';
                  }
                  if ((value ?? '').trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              if (authState.error != null) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                AppStatusBadge(
                  label: authState.error!,
                  tone: AppStatusTone.danger,
                  icon: Icons.error_outline_rounded,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _attemptLogin,
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Log In'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration is mocked in this MVP.'),
                      ),
                    );
                  },
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).enterGuestMode();
                    context.go('/app/0');
                  },
                  child: const Text('Continue as Guest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            AdaptiveLayout(
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: introPanel),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: formPanel),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        introPanel,
                        const SizedBox(height: AppSpacing.lg),
                        formPanel,
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturePoint extends StatelessWidget {
  const _FeaturePoint({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Icon(icon, size: AppIconSize.sm, color: AppColors.maroon),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickFillChip extends StatelessWidget {
  const _QuickFillChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.auto_awesome_rounded, size: AppIconSize.xs),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.lineStrong),
    );
  }
}
