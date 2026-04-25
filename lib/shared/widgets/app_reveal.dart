import 'package:batseeku/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppReveal extends StatefulWidget {
  const AppReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.04),
    this.duration = AppMotion.medium,
  });

  final Widget child;
  final Duration delay;
  final Offset beginOffset;
  final Duration duration;

  @override
  State<AppReveal> createState() => _AppRevealState();
}

class _AppRevealState extends State<AppReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.beginOffset,
      duration: widget.duration,
      curve: AppMotion.emphasized,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: widget.duration,
        curve: AppMotion.emphasized,
        child: widget.child,
      ),
    );
  }
}
