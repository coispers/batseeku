import 'package:batseeku/models/admin_metrics.dart';
import 'package:batseeku/models/admin_user_status.dart';
import 'package:batseeku/models/app_user.dart';
import 'package:batseeku/models/errand_task.dart';
import 'package:batseeku/models/freelancer_profile.dart';
import 'package:batseeku/models/message_thread.dart';
import 'package:batseeku/models/payment_option.dart';
import 'package:batseeku/models/reputation.dart';
import 'package:batseeku/models/review.dart';
import 'package:batseeku/models/role.dart';
import 'package:batseeku/models/service_category.dart';
import 'package:batseeku/models/service_request.dart';

class SeedData {
  const SeedData._();

  static final List<AppUser> users = <AppUser>[
    const AppUser(
      id: 'u_student_1',
      name: 'Aira Dela Cruz',
      email: 'student1@g.batstate-u.edu.ph',
      role: Role.student,
      isVerified: true,
      course: 'BS Computer Science',
    ),
    const AppUser(
      id: 'u_freelancer_1',
      name: 'Miguel Ramos',
      email: 'tutor1@g.batstate-u.edu.ph',
      role: Role.freelancer,
      isVerified: true,
      course: 'BS Information Technology',
    ),
    const AppUser(
      id: 'u_admin_1',
      name: 'Campus Services Admin',
      email: 'admin@g.batstate-u.edu.ph',
      role: Role.admin,
      isVerified: true,
    ),
  ];

  static final List<ServiceCategory> categories = <ServiceCategory>[
    const ServiceCategory(
      id: 'tutoring',
      name: 'Tutoring',
      description: 'Subject coaching and exam prep',
    ),
    const ServiceCategory(
      id: 'programming_help',
      name: 'Programming Help',
      description: 'Debugging, coding tasks, project guidance',
    ),
    const ServiceCategory(
      id: 'math_help',
      name: 'Math Help',
      description: 'Algebra, statistics, and calculus support',
    ),
    const ServiceCategory(
      id: 'lab_assistance',
      name: 'Lab Assistance',
      description: 'Report interpretation and practical tips',
    ),
    const ServiceCategory(
      id: 'thesis_formatting',
      name: 'Thesis Formatting',
      description: 'Citation cleanup and chapter formatting',
    ),
  ];

  static final List<FreelancerProfile> freelancerProfiles = <FreelancerProfile>[
    const FreelancerProfile(
      id: 'f_1',
      userId: 'u_freelancer_1',
      displayName: 'Miguel Ramos',
      bio: 'IT senior focused on Java, Flutter, and thesis consulting.',
      skills: <String>['Flutter', 'Java', 'Database Design', 'UI Debugging'],
      portfolioSamples: <String>[
        'Built attendance tracker app for campus org',
        'Helped 12 students complete capstone prototype demos',
      ],
      subject: 'Programming Help',
      rating: 4.9,
      hourlyRate: 220,
      completedJobs: 48,
      availableNow: true,
      gwa: 1.55,
    ),
    const FreelancerProfile(
      id: 'f_2',
      userId: 'u_freelancer_2',
      displayName: 'Celine Gonzales',
      bio: 'Math tutor with strong calculus and probability background.',
      skills: <String>['Calculus', 'Statistics', 'Word Problem Coaching'],
      portfolioSamples: <String>[
        'Weekly SAT-style quantitative drills',
        'Created personalized study plans for engineering majors',
      ],
      subject: 'Math Help',
      rating: 4.7,
      hourlyRate: 180,
      completedJobs: 34,
      availableNow: true,
      gwa: 1.42,
    ),
    const FreelancerProfile(
      id: 'f_3',
      userId: 'u_freelancer_3',
      displayName: 'Andre Villanueva',
      bio: 'Lab assistant for chemistry and microbiology writeups.',
      skills: <String>['Lab Reports', 'Data Visualization', 'APA Formatting'],
      portfolioSamples: <String>[
        'Assisted in 20+ chemistry report revisions',
        'Created graph templates for biology lab outputs',
      ],
      subject: 'Lab Assistance',
      rating: 4.6,
      hourlyRate: 200,
      completedJobs: 26,
      availableNow: false,
      gwa: 1.68,
    ),
  ];

  static final Map<String, List<Review>> reviewsByFreelancer =
      <String, List<Review>>{
    'f_1': <Review>[
      Review(
        id: 'r_1',
        reviewerName: 'Paolo E.',
        comment: 'Clear explanations and fast turnaround on code review.',
        rating: 5,
        createdAt: DateTime(2026, 4, 3),
      ),
      Review(
        id: 'r_2',
        reviewerName: 'Mika R.',
        comment: 'Great for debugging Flutter layout issues.',
        rating: 4.8,
        createdAt: DateTime(2026, 4, 8),
      ),
    ],
    'f_2': <Review>[
      Review(
        id: 'r_3',
        reviewerName: 'Lance G.',
        comment: 'Made statistics much easier to understand.',
        rating: 4.7,
        createdAt: DateTime(2026, 4, 10),
      ),
    ],
    'f_3': <Review>[
      Review(
        id: 'r_4',
        reviewerName: 'Trina C.',
        comment: 'Helped me improve my lab report significantly.',
        rating: 4.6,
        createdAt: DateTime(2026, 4, 9),
      ),
    ],
  };

  static final List<ErrandTask> errands = <ErrandTask>[
    const ErrandTask(
      id: 'e_1',
      title: 'Print 3 thesis chapters',
      description: 'Need hard copies from near Main Campus before 5 PM.',
      budget: 150,
      distanceKm: 1.2,
      postedBy: 'Aira Dela Cruz',
      status: ErrandStatus.open,
    ),
    const ErrandTask(
      id: 'e_2',
      title: 'Pick up lab supplies',
      description: 'From local bookstore, reimbursement included.',
      budget: 220,
      distanceKm: 2.8,
      postedBy: 'Theo Manalo',
      status: ErrandStatus.accepted,
    ),
    const ErrandTask(
      id: 'e_3',
      title: 'Queue for registrar request',
      description: 'Need assistance getting TOR request slip.',
      budget: 300,
      distanceKm: 0.9,
      postedBy: 'Janna Paredes',
      status: ErrandStatus.open,
    ),
  ];

  static final List<ServiceRequest> serviceRequests = <ServiceRequest>[
    ServiceRequest(
      id: 'sr_1',
      studentId: 'u_student_1',
      freelancerId: 'u_freelancer_1',
      serviceType: 'Programming Help',
      details: 'Need assistance with state management in Flutter.',
      deadline: DateTime(2026, 4, 27, 19),
      estimatedPrice: 350,
      paymentOption: PaymentOption.gcash,
      status: ServiceRequestStatus.matching,
    ),
  ];

  static final List<MessageThread> messageThreads = <MessageThread>[
    MessageThread(
      id: 'm_1',
      participants: <String>['Aira Dela Cruz', 'Miguel Ramos'],
      lastMessage: 'I sent a sample repo. Please check branch two.',
      status: MessageThreadStatus.active,
      messages: <ChatMessage>[
        ChatMessage(
          id: 'cm_1',
          sender: 'Aira Dela Cruz',
          text: 'Hi Kuya Miguel, available for a Flutter session tonight?',
          sentAt: DateTime(2026, 4, 12, 20, 0),
        ),
        ChatMessage(
          id: 'cm_2',
          sender: 'Miguel Ramos',
          text: 'Yes, send your current code and target output.',
          sentAt: DateTime(2026, 4, 12, 20, 2),
        ),
      ],
    ),
    MessageThread(
      id: 'm_2',
      participants: <String>['Aira Dela Cruz', 'Celine Gonzales'],
      lastMessage: 'Session completed. Thank you!',
      status: MessageThreadStatus.completed,
      messages: <ChatMessage>[
        ChatMessage(
          id: 'cm_3',
          sender: 'Celine Gonzales',
          text: 'Great work today. You solved all the practice items.',
          sentAt: DateTime(2026, 4, 1, 18, 10),
        ),
      ],
    ),
  ];

  static const AdminMetrics adminMetrics = AdminMetrics(
    totalUsers: 1284,
    activeRequests: 43,
    reports: 7,
    verifiedUsers: 1210,
    flaggedUsers: 12,
  );

  static final List<AdminUserStatus> adminUserStatuses = <AdminUserStatus>[
    const AdminUserStatus(
      name: 'Aira Dela Cruz',
      role: Role.student,
      status: 'Verified',
    ),
    const AdminUserStatus(
      name: 'Miguel Ramos',
      role: Role.freelancer,
      status: 'Verified',
    ),
    const AdminUserStatus(
      name: 'Theo Manalo',
      role: Role.student,
      status: 'Flagged',
    ),
    const AdminUserStatus(
      name: 'Celine Gonzales',
      role: Role.freelancer,
      status: 'Verified',
    ),
  ];

  static final Map<String, Reputation> reputationByUser = <String, Reputation>{
    'u_student_1': const Reputation(score: 4.8, label: 'Trusted Client'),
    'u_freelancer_1': const Reputation(score: 4.9, label: 'Top Tutor'),
    'guest': const Reputation(score: 0, label: 'Guest Mode'),
  };
}
