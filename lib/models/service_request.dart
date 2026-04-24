import 'package:batseeku/models/payment_option.dart';

enum ServiceRequestStatus {
  pending,
  matching,
  accepted,
  completed,
}

class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.studentId,
    required this.freelancerId,
    required this.serviceType,
    required this.details,
    required this.deadline,
    required this.estimatedPrice,
    required this.paymentOption,
    required this.status,
  });

  final String id;
  final String studentId;
  final String freelancerId;
  final String serviceType;
  final String details;
  final DateTime deadline;
  final double estimatedPrice;
  final PaymentOption paymentOption;
  final ServiceRequestStatus status;
}
