import 'package:flutter/material.dart';
import 'package:hackernews/ui/widgets/skeletons/skeleton_postcard2.dart';
import 'package:hackernews/ui/widgets/skeletons/skeleton_usercard.dart';

class SkeletonUserPage extends StatelessWidget {
  final String userId;

  const SkeletonUserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SkeletonUserCard(),
          Divider(),
          ...List.generate(
              10,
              (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SkeletonPostCard2(),
                  ))
        ],
      ),
    );
  }
}
