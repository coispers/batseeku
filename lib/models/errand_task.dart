enum ErrandStatus {
  open,
  accepted,
  completed,
}

class ErrandTask {
  const ErrandTask({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.distanceKm,
    required this.postedBy,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  final double budget;
  final double distanceKm;
  final String postedBy;
  final ErrandStatus status;
}
