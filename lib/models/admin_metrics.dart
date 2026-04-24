class AdminMetrics {
  const AdminMetrics({
    required this.totalUsers,
    required this.activeRequests,
    required this.reports,
    required this.verifiedUsers,
    required this.flaggedUsers,
  });

  final int totalUsers;
  final int activeRequests;
  final int reports;
  final int verifiedUsers;
  final int flaggedUsers;
}
