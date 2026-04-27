import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/models/payment_option.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestMatchingArgs {
  const RequestMatchingArgs({
    required this.freelancerName,
    required this.serviceType,
    required this.estimatedPrice,
    required this.paymentOption,
  });

  final String freelancerName;
  final String serviceType;
  final double estimatedPrice;
  final PaymentOption paymentOption;
}

class RequestMatchingScreen extends StatelessWidget {
  const RequestMatchingScreen({
    super.key,
    required this.args,
  });

  final RequestMatchingArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 48),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3344), // vibrant red
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33FF3344),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 56),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order Placed!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🎉', style: TextStyle(fontSize: 28)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your request has been sent to \x24{args.freelancerName}.\nYou\'ll receive a confirmation shortly.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSummaryRow(context, 'Order ID', '#BU-20481', isHighlighted: true),
                    const Divider(height: AppSpacing.xl),
                    _buildSummaryRow(context, 'Service', args.serviceType),
                    const Divider(height: AppSpacing.xl),
                    _buildSummaryRow(context, 'Package', 'Basic'),
                    const Divider(height: AppSpacing.xl),
                    _buildSummaryRow(context, 'Price', '\$\x24{args.estimatedPrice.toStringAsFixed(2)}', boldValue: true),
                    const Divider(height: AppSpacing.xl),
                    _buildSummaryRow(context, 'Estimated Delivery', 'Within 24 hours', boldValue: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3344),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Track My Order', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.go('/app/0'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF3344),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: Color(0xFFFFEBED)), // faintest pink line
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                ),
                child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.help_outline, size: 16, color: Color(0xFFFF3344)),
                  const SizedBox(width: 4),
                  Text(
                    'Need help?',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                    child: Text(
                      'Contact Support',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFFFF3344)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isHighlighted = false, bool boldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: boldValue || isHighlighted ? FontWeight.w800 : FontWeight.w600,
                color: isHighlighted ? const Color(0xFFFF3344) : AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}
