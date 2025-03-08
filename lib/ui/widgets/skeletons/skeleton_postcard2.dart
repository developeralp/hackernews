import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonPostCard2 extends StatelessWidget {
  const SkeletonPostCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 32,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 20,
                width: 80,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
