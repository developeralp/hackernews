import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackernews/api/rest_api.dart';
import 'package:hackernews/models/post.dart';
import 'package:hackernews/models/user.dart';
import 'package:hackernews/providers/internet_provider.dart';
import 'package:hackernews/ui/widgets/hn_appbar.dart';
import 'package:hackernews/ui/widgets/post_card.dart';
import 'package:hackernews/ui/widgets/skeletons/skeleton_userpage.dart';
import 'package:hackernews/ui/widgets/user_card.dart';
import 'package:hackernews/utils/network_checker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final userProvider =
    FutureProvider.autoDispose.family<User?, String>((ref, userId) async {
  return await HackerNewsAPI().getUser(userId);
});

class UserPage extends ConsumerStatefulWidget {
  const UserPage(this.userId, {super.key});

  final String userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  int page = 0;

  late final _pagingController = PagingController<int, Post>(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    fetchPage: (pageKey) => HackerNewsAPI().getUserPostsEasily(pageKey),
  );

  @override
  void initState() {
    super.initState();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (!NetworkChecker.networkOk(results)) {
        ref.read(isOnlineProvider.notifier).state = OnlineTypes.offline;
      } else {
        ref.read(isOnlineProvider.notifier).state = OnlineTypes.online;
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider(widget.userId));

    return Scaffold(
      appBar: HNAppBar(
        title: widget.userId,
        showBackButton: true,
      ),
      body: user.when(
        data: (user) {
          if (user == null) return Center(child: Text('User not found..'));

          return SafeArea(
              child: Column(
            children: [
              UserCard(user: user),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              Expanded(
                  child: PagingListener(
                controller: PagingController<int, Post>(
                  getNextPageKey: (state) {
                    //We need to check if there are no more pages
                    if (state.keys != null) {
                      if (state.keys!.last > user.maxPage()) {
                        return null; //If so return null to not re-call fetchPage()
                      }
                    }
                    return (state.keys?.last ?? 0) + 1;
                  },
                  fetchPage: (pageKey) =>
                      HackerNewsAPI().getUserPostsEasily(pageKey),
                ),
                builder: (context, state, fetchNextPage) =>
                    PagedListView<int, Post>(
                  shrinkWrap: true, // Add this to avoid overflow issues
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate(
                    noMoreItemsIndicatorBuilder: (context) => Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: Text('No more posts...')),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('No posts found...'),
                          ],
                        ),
                      ),
                    ),
                    itemBuilder: (context, item, index) => PostCard(
                      post: item,
                      forUser: true,
                    ),
                  ),
                ),
              )),
            ],
          ));
        },
        error: (_, __) => Center(
          child: Text('Error fetching user'),
        ),
        loading: () => SkeletonUserPage(
          userId: widget.userId,
        ),
      ),
    );
  }
}
