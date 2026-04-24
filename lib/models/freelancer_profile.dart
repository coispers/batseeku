class FreelancerProfile {
  const FreelancerProfile({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.bio,
    required this.skills,
    required this.portfolioSamples,
    required this.subject,
    required this.rating,
    required this.hourlyRate,
    required this.completedJobs,
    required this.availableNow,
    this.gwa,
  });

  final String id;
  final String userId;
  final String displayName;
  final String bio;
  final List<String> skills;
  final List<String> portfolioSamples;
  final String subject;
  final double rating;
  final double hourlyRate;
  final int completedJobs;
  final bool availableNow;
  final double? gwa;
}
