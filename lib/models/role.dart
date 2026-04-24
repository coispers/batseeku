enum Role {
  student,
  freelancer,
  admin,
  guest,
}

extension RoleX on Role {
  String get label {
    switch (this) {
      case Role.student:
        return 'Student';
      case Role.freelancer:
        return 'Freelancer';
      case Role.admin:
        return 'Admin';
      case Role.guest:
        return 'Guest';
    }
  }

  bool get isPrivileged => this == Role.admin;
  bool get isGuest => this == Role.guest;
}
