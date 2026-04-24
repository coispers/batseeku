import 'package:batseeku/models/role.dart';

bool canRequestService(Role role) => role == Role.student;

bool canAcceptRequests(Role role) => role == Role.freelancer;

bool canPostErrands(Role role) =>
    role == Role.student || role == Role.freelancer;

bool canUseMessages(Role role) =>
    role == Role.student || role == Role.freelancer;

bool isGuestRole(Role role) => role == Role.guest;
