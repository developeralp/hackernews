import 'package:flutter/material.dart';
import 'package:hackernews/ui/app_colors.dart';
import 'package:hackernews/utils/constants.dart';

class HNAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const HNAppBar(
      {super.key, this.title = Constants.appName, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
