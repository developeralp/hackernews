// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackernews/pages/home_page.dart';
import 'package:hackernews/providers/internet_provider.dart';
import 'package:hackernews/ui/app_colors.dart';
import 'package:hackernews/utils/network_checker.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!NetworkChecker.networkOk(connectivityResult)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection...')));

      ref.read(isOnlineProvider.notifier).state = OnlineTypes.offline;
    } else {
      ref.read(isOnlineProvider.notifier).state = OnlineTypes.online;

      await Future.delayed(const Duration(milliseconds: 50));
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);

    return Scaffold(
        body: Center(
      child: online == OnlineTypes.offline
          ? Text(
              'Unfortunately this app needs network connection.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryColor),
            )
          : const CircularProgressIndicator(),
    ));
  }
}
