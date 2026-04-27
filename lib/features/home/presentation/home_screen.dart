import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/features/auth/domain/mock_auth_service.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Essay Writing',
    'Coding',
    'Design',
    'Math'
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final String name = authState.user?.name.split(' ').first ?? 'Alex';

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: <Widget>[
        const SizedBox(height: AppSpacing.md),
        _buildHeaderSection(context, name),
        const SizedBox(height: AppSpacing.lg),
        _buildCategoriesList(),
        const SizedBox(height: AppSpacing.lg),
        _buildTopServicesSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildFeaturedFreelancersSection(context),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hello, $name ',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const Text('👋', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'What do you need help with today?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for a service or freelancer...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.disabled,
                        ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.maroonMuted),
                    filled: true,
                    fillColor: AppColors.surface, // changed from disabled to surface, actually let's use slightly grey
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      borderSide: const BorderSide(color: AppColors.line, width: 1.0), // very subtle border or none
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      borderSide: const BorderSide(color: AppColors.line, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      borderSide: const BorderSide(color: AppColors.maroon, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.maroon,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune_rounded, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = category);
                }
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.maroon,
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : AppColors.maroon,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                side: BorderSide(
                  color: isSelected ? AppColors.maroon : AppColors.maroonSoft,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Services',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {}, // GoRouter action here
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              _TopServiceItem(
                title: 'Essay Proofreading',
                imageUrl: 'https://picsum.photos/seed/essay/300/200',
                rating: 4.8,
                reviews: 124,
                freelancerName: 'Sophie M.',
                price: 5,
              ),
              const SizedBox(width: AppSpacing.md),
              _TopServiceItem(
                title: 'Python Assignment',
                imageUrl: 'https://picsum.photos/seed/python/300/200',
                rating: 4.9,
                reviews: 208,
                freelancerName: 'Daniel K.',
                price: 10, // Assuming a price
              ),
              const SizedBox(width: AppSpacing.md),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedFreelancersSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Freelancers',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {}, // GoRouter action here
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _FeaturedFreelancerItem(
            name: 'Anisa N.',
            skill: 'UI/UX Design',
            rating: 4.9,
            reviews: 86,
            avatarUrl: 'assets/images/anisa.png', // Fallback handled by AppAvatar or a network placeholder
            useNetworkFallback: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _FeaturedFreelancerItem(
            name: 'Daniel K.',
            skill: 'Python - Coding',
            rating: 4.8,
            reviews: 142,
            avatarUrl: 'assets/images/daniel.png', // Fallback handled by AppAvatar or a network placeholder
            useNetworkFallback: true,
          ),
        ],
      ),
    );
  }
}

class _TopServiceItem extends StatelessWidget {
  const _TopServiceItem({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.freelancerName,
    required this.price,
  });

  final String title;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String freelancerName;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
            child: Image.network(
              imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: AppIconSize.md),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviews)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    AppAvatar(
                      label: freelancerName,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        freelancerName,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Starting',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'From \$${price.toInt()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.maroon,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedFreelancerItem extends StatelessWidget {
  const _FeaturedFreelancerItem({
    required this.name,
    required this.skill,
    required this.rating,
    required this.reviews,
    required this.avatarUrl,
    this.useNetworkFallback = false,
  });

  final String name;
  final String skill;
  final double rating;
  final int reviews;
  final String avatarUrl;
  final bool useNetworkFallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  useNetworkFallback ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random' : avatarUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: AppColors.maroonSoft,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Text(
                    skill,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.maroon,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: AppIconSize.sm),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviews)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 0),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
            child: const Text('Hire'),
          )
        ],
      ),
    );
  }
}
