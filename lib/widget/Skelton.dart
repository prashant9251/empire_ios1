import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skelton extends StatelessWidget {
  const Skelton({key, required this.height, required this.width});
  final double height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}

class ShimmerSkelton extends StatelessWidget {
  ShimmerSkelton({key, required this.height, required this.width, this.baseColor});
  final double height, width;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.withAlpha((0.3 * 255).toInt()),
      highlightColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
      child: Skelton(height: height, width: width),
    );
  }
}

Center loadingWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 6.3,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    jsmColor.withOpacity(0.7),
                    jsmColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(jsmColor),
                  backgroundColor: Colors.deepPurple.shade50,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Loading sales data...",
          style: TextStyle(
            color: jsmColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.1,
          ),
        ),
      ],
    ),
  );
}
