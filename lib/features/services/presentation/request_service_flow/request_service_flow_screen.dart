import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/shared/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:batseeku/models/payment_option.dart';
import 'request_matching_screen.dart';

class RequestServiceFlowScreen extends ConsumerStatefulWidget {
  const RequestServiceFlowScreen({
    super.key,
    required this.freelancerId,
  });

  final String freelancerId;

  @override
  ConsumerState<RequestServiceFlowScreen> createState() => _RequestServiceFlowScreenState();
}

class _RequestServiceFlowScreenState extends ConsumerState<RequestServiceFlowScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _notifyWhenReady = true;

  @override
  void dispose() {
    _topicController.dispose();
    _deadlineController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _confirmRequest() {
    context.push(
      '/services/request/${widget.freelancerId}/matching',
      extra: const RequestMatchingArgs(
        freelancerName: 'Marcus T.',
        serviceType: 'Python Assignment Help',
        estimatedPrice: 5.0,
        paymentOption: PaymentOption.cash,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Request Service',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.line,
            height: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Service Summary Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECEE), // faint pink
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SERVICE',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                    Text(
                      'Package',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Python Assignment Help',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Basic · \$5.00',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFFF3344),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                const Row(
                  children: [
                    AppAvatar(label: 'Marcus T.', size: 20),
                    SizedBox(width: 8),
                    Text('Marcus T.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Tell us about your task',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildLabel(context, 'Assignment Topic'),
          TextField(
            controller: _topicController,
            decoration: _minimalInputDecoration(context, 'e.g. Sorting algorithms in Python'),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildLabel(context, 'Deadline'),
          TextField(
            controller: _deadlineController,
            decoration: _minimalInputDecoration(context, 'Select a date').copyWith(
              prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textMuted),
            ),
            readOnly: true,
            onTap: () async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                // simple format example
                _deadlineController.text = "\x24{date.month}/\x24{date.day}/\x24{date.year}";
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _buildLabel(context, 'Additional Notes'),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: _minimalInputDecoration(context, 'Any specific requirements or instructions...'),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildLabel(context, 'Attach Files'),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7F8),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: const Color(0xFFFFB3B8), width: 1.0), // solid border styled to look subtle like dash
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDECEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.upload_outlined, color: Color(0xFFFF3344), size: 24),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tap to upload files',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFFF3344),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PDF, DOCX, PNG up to 10MB',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted, // #F5F5F5 normally
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Preference',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Notify me when ready',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
                Switch(
                  value: _notifyWhenReady,
                  onChanged: (val) => setState(() => _notifyWhenReady = val),
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFFFF3344),
                  inactiveThumbColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _confirmRequest,
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
                Icon(Icons.lock_outline, size: 18),
                SizedBox(width: 8),
                Text('Confirm & Place Order', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
      ),
    );
  }

  InputDecoration _minimalInputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
      filled: true,
      fillColor: const Color(0xFFF6F6F6), // slightly gray
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        borderSide: const BorderSide(color: Color(0xFFFF3344), width: 1.5),
      ),
    );
  }
}
