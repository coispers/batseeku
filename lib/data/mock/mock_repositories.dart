import 'package:batseeku/data/mock/seed_data.dart';
import 'package:batseeku/models/admin_metrics.dart';
import 'package:batseeku/models/admin_user_status.dart';
import 'package:batseeku/models/app_user.dart';
import 'package:batseeku/models/errand_task.dart';
import 'package:batseeku/models/freelancer_profile.dart';
import 'package:batseeku/models/message_thread.dart';
import 'package:batseeku/models/reputation.dart';
import 'package:batseeku/models/review.dart';
import 'package:batseeku/models/service_category.dart';
import 'package:batseeku/models/service_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockDataRepository {
  List<AppUser> get users => List<AppUser>.unmodifiable(SeedData.users);

  List<ServiceCategory> get categories =>
      List<ServiceCategory>.unmodifiable(SeedData.categories);

  List<FreelancerProfile> get freelancerProfiles =>
      List<FreelancerProfile>.unmodifiable(SeedData.freelancerProfiles);

  List<ErrandTask> get errands =>
      List<ErrandTask>.unmodifiable(SeedData.errands);

  List<MessageThread> get messageThreads =>
      List<MessageThread>.unmodifiable(SeedData.messageThreads);

  List<ServiceRequest> get serviceRequests =>
      List<ServiceRequest>.unmodifiable(SeedData.serviceRequests);

  AdminMetrics get adminMetrics => SeedData.adminMetrics;

  List<AdminUserStatus> get adminUserStatuses =>
      List<AdminUserStatus>.unmodifiable(SeedData.adminUserStatuses);

  List<Review> reviewsForFreelancer(String freelancerId) {
    return List<Review>.unmodifiable(
      SeedData.reviewsByFreelancer[freelancerId] ?? const <Review>[],
    );
  }

  Reputation reputationForUser(String userId) {
    return SeedData.reputationByUser[userId] ??
        const Reputation(score: 4.5, label: 'Reliable');
  }

  FreelancerProfile? getFreelancerById(String id) {
    for (final FreelancerProfile profile in SeedData.freelancerProfiles) {
      if (profile.id == id) {
        return profile;
      }
    }
    return null;
  }

  MessageThread? getThreadById(String id) {
    for (final MessageThread thread in SeedData.messageThreads) {
      if (thread.id == id) {
        return thread;
      }
    }
    return null;
  }
}

final mockDataRepositoryProvider = Provider<MockDataRepository>(
  (Ref ref) => MockDataRepository(),
);
