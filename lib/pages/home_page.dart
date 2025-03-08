import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackernews/providers/internet_provider.dart';
import 'package:hackernews/providers/top_stories_provider.dart';
import 'package:hackernews/ui/widgets/hn_appbar.dart';
import 'package:hackernews/ui/widgets/post_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hackernews/utils/network_checker.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late ScrollController _scrollController;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(topStoriesProvider.notifier).loadMorePosts();
      }
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (!NetworkChecker.networkOk(results)) {
        ref.read(isOnlineProvider.notifier).state = OnlineTypes.offline;

      } else {
        ref.read(isOnlineProvider.notifier).state = OnlineTypes.online;
      }

      // Received changes in available connectivity types!
    });
  }

  @override
  Widget build(BuildContext context) {
    final topStories = ref.watch(topStoriesProvider);

    return Scaffold(
      appBar: HNAppBar(),
      body: SafeArea(
        child: topStories.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  // ignore: unused_result
                  ref.refresh(topStoriesProvider.notifier);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      topStories.length + 1, //+1 is for the loading indicator
                  itemBuilder: (context, index) {
                    if (index == topStories.length) {
                      return const SizedBox(
                          width: 64,
                          height: 64,
                          child: Center(child: CircularProgressIndicator()));
                    }

                    final post = topStories[index];
                    return PostCard(post: post);
                  },
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    subscription.cancel();
    super.dispose();
  }
}
