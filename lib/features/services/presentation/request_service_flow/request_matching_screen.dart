import 'package:batseeku/models/payment_option.dart';
import 'package:flutter/material.dart';

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

class RequestMatchingScreen extends StatefulWidget {
  const RequestMatchingScreen({
    super.key,
    required this.args,
  });

  final RequestMatchingArgs args;

  @override
  State<RequestMatchingScreen> createState() => _RequestMatchingScreenState();
}

class _RequestMatchingScreenState extends State<RequestMatchingScreen> {
  bool _matchFound = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _matchFound = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String paymentLabel = widget.args.paymentOption.label;

    return Scaffold(
      appBar: AppBar(title: const Text('Matching')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _matchFound
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 56,
                          color: Color(0xFF1F8B4C),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Freelancer Matched',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Matched with ${widget.args.freelancerName}'),
                        Text('Service: ${widget.args.serviceType}'),
                        Text(
                          'Estimated: PHP ${widget.args.estimatedPrice.toStringAsFixed(0)}',
                        ),
                        Text('Payment: $paymentLabel'),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .popUntil((Route<dynamic> route) => route.isFirst),
                            child: const Text('Back to Home'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Finding a tutor...',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Matching based on availability and rating.'),
                  ],
                ),
        ),
      ),
    );
  }
}
