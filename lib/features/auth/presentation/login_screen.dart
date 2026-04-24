import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/role.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome to BatSeekU',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Use your university account or continue in guest mode.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                        if (universityError != null) ...<Widget>[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            universityError,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.redAccent),
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
                          Text(
                            authState.error!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.redAccent),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                authState.isLoading ? null : _attemptLogin,
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
                                  content: Text(
                                    'Registration is mocked in this MVP.',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Register'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .enterGuestMode();
                              context.go('/app/0');
                            },
                            child: const Text('Continue as Guest'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Quick Fill Accounts',
                style: Theme.of(context).textTheme.titleMedium,
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
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.maroonSoft,
      side: const BorderSide(color: AppColors.line),
    );
  }
}
