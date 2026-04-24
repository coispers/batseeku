import 'package:batseeku/models/role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    this.course,
  });

  final String id;
  final String name;
  final String email;
  final Role role;
  final bool isVerified;
  final String? course;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    Role? role,
    bool? isVerified,
    String? course,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      course: course ?? this.course,
    );
  }
}
