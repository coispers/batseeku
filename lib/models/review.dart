class Review {
  const Review({
    required this.id,
    required this.reviewerName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  final String id;
  final String reviewerName;
  final String comment;
  final double rating;
  final DateTime createdAt;
}
