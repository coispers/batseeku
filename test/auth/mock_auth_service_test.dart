import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/models/role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateUniversityEmail', () {
    test('rejects non university domain', () {
      expect(
        validateUniversityEmail('student@gmail.com'),
        isNotNull,
      );
    });

    test('accepts university email domain', () {
      expect(
        validateUniversityEmail('student1@g.batstate-u.edu.ph'),
        isNull,
      );
    });
  });

  group('MockAuthService', () {
    final MockAuthService service = MockAuthService();

    test('logs in student account', () async {
      final user = await service.login(
        email: 'student1@g.batstate-u.edu.ph',
        password: '123456',
      );

      expect(user.role, Role.student);
      expect(user.email, 'student1@g.batstate-u.edu.ph');
    });

    test('throws on invalid credentials', () async {
      expect(
        () => service.login(
          email: 'student1@g.batstate-u.edu.ph',
          password: 'bad-pass',
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('returns guest account', () {
      final user = service.continueAsGuest();
      expect(user.role, Role.guest);
      expect(user.isVerified, isFalse);
    });
  });
}
