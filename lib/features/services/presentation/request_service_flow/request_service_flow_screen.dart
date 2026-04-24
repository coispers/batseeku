import 'package:batseeku/app/theme/app_theme.dart';
import 'package:batseeku/data/mock/mock_repositories.dart';
import 'package:batseeku/models/payment_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'request_matching_screen.dart';

class RequestServiceFlowScreen extends ConsumerStatefulWidget {
  const RequestServiceFlowScreen({
    super.key,
    required this.freelancerId,
  });

  final String freelancerId;

  @override
  ConsumerState<RequestServiceFlowScreen> createState() =>
      _RequestServiceFlowScreenState();
}

class _RequestServiceFlowScreenState
    extends ConsumerState<RequestServiceFlowScreen> {
  final GlobalKey<FormState> _detailsFormKey = GlobalKey<FormState>();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  int _step = 0;
  String _serviceType = 'Tutoring';
  PaymentOption _paymentOption = PaymentOption.cash;

  @override
  void dispose() {
    _detailsController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  double _estimatePrice() {
    final Map<String, double> basePrices = <String, double>{
      'Tutoring': 220,
      'Programming Help': 280,
      'Math Help': 230,
      'Lab Assistance': 240,
      'Thesis Formatting': 210,
    };

    double value = basePrices[_serviceType] ?? 220;
    final String deadline = _deadlineController.text.trim().toLowerCase();
    if (deadline.contains('today') || deadline.contains('urgent')) {
      value += 80;
    }
    if (_detailsController.text.trim().length > 120) {
      value += 30;
    }
    return value;
  }

  void _nextStep() {
    if (_step == 1 && !(_detailsFormKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_step >= 2) {
      return;
    }
    setState(() {
      _step += 1;
    });
  }

  void _confirmRequest(String freelancerName) {
    context.push(
      '/services/request/${widget.freelancerId}/matching',
      extra: RequestMatchingArgs(
        freelancerName: freelancerName,
        serviceType: _serviceType,
        estimatedPrice: _estimatePrice(),
        paymentOption: _paymentOption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(mockDataRepositoryProvider);
    final freelancer = repository.getFreelancerById(widget.freelancerId);

    if (freelancer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request Service')),
        body: const Center(child: Text('Freelancer not found.')),
      );
    }

    final List<String> serviceTypes =
        repository.categories.map((category) => category.name).toList();

    if (!serviceTypes.contains(_serviceType)) {
      _serviceType = serviceTypes.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Request Service')),
      body: SafeArea(
        child: Stepper(
          currentStep: _step,
          onStepTapped: (int value) {
            if (value <= _step) {
              setState(() {
                _step = value;
              });
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final bool finalStep = _step == 2;
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: finalStep
                        ? () => _confirmRequest(freelancer.displayName)
                        : _nextStep,
                    child: Text(finalStep ? 'Confirm Request' : 'Next'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (_step > 0)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _step -= 1;
                        });
                      },
                      child: const Text('Back'),
                    ),
                ],
              ),
            );
          },
          steps: <Step>[
            Step(
              title: const Text('Service Type'),
              isActive: _step >= 0,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Requesting ${freelancer.displayName}'),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _serviceType,
                    decoration:
                        const InputDecoration(labelText: 'Service type'),
                    items: serviceTypes
                        .map(
                          (String service) => DropdownMenuItem<String>(
                            value: service,
                            child: Text(service),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _serviceType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Details'),
              isActive: _step >= 1,
              content: Form(
                key: _detailsFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _detailsController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Problem details',
                        hintText:
                            'Describe your task, context, and expected output.',
                      ),
                      validator: (String? value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Please enter details.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _deadlineController,
                      decoration: const InputDecoration(
                        labelText: 'Deadline',
                        hintText: 'Example: Tomorrow, 8:00 PM',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (String? value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Please enter a deadline.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: const Text('Estimate and Payment'),
              isActive: _step >= 2,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.payments_outlined),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Estimated Price: PHP ${_estimatePrice().toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RadioListTile<PaymentOption>(
                    value: PaymentOption.cash,
                    groupValue: _paymentOption,
                    title: const Text('Cash'),
                    onChanged: (PaymentOption? value) {
                      if (value != null) {
                        setState(() {
                          _paymentOption = value;
                        });
                      }
                    },
                  ),
                  RadioListTile<PaymentOption>(
                    value: PaymentOption.gcash,
                    groupValue: _paymentOption,
                    title: const Text('GCash (mock)'),
                    onChanged: (PaymentOption? value) {
                      if (value != null) {
                        setState(() {
                          _paymentOption = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Payment is held until the task is marked completed.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
