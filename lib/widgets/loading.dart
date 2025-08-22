import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedLoadingIndicator extends StatefulWidget {
  const AnimatedLoadingIndicator({super.key});

  @override
  State<AnimatedLoadingIndicator> createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  final List<IconData> _icons = [
    Icons.savings,
    Icons.auto_graph_rounded,
    Icons.receipt,
    Icons.account_balance_wallet_rounded,
    Icons.lightbulb,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(_icons.length, (index) {
                        final angle = (index / _icons.length) * 2 * pi +
                            (_controller.value * 2 * pi);
                        final radius = 60.0;
                        final offset = Offset(
                          cos(angle) * radius,
                          sin(angle) * radius,
                        );
                        final scale = 1.0 + (sin(angle) * 0.15);

                        return Transform.scale(
                          scale: scale,
                          child: Transform.translate(
                            offset: offset,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // --- COLOR CHANGED HERE ---
                                color: const Color(0xFFA42A25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: Icon(
                                _icons[index],
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Processing Story...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}