import 'package:batseeku/app/role_capabilities.dart';
import 'package:batseeku/models/role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('student capabilities', () {
    expect(canRequestService(Role.student), isTrue);
    expect(canPostErrands(Role.student), isTrue);
    expect(canUseMessages(Role.student), isTrue);
  });

  test('freelancer capabilities', () {
    expect(canRequestService(Role.freelancer), isFalse);
    expect(canAcceptRequests(Role.freelancer), isTrue);
    expect(canPostErrands(Role.freelancer), isTrue);
    expect(canUseMessages(Role.freelancer), isTrue);
  });

  test('guest capabilities', () {
    expect(canRequestService(Role.guest), isFalse);
    expect(canAcceptRequests(Role.guest), isFalse);
    expect(canPostErrands(Role.guest), isFalse);
    expect(canUseMessages(Role.guest), isFalse);
    expect(isGuestRole(Role.guest), isTrue);
  });
}
