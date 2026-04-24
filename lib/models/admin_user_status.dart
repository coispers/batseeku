import 'package:batseeku/models/role.dart';

class AdminUserStatus {
  const AdminUserStatus({
    required this.name,
    required this.role,
    required this.status,
  });

  final String name;
  final Role role;
  final String status;
}
