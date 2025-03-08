import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackernews/api/rest_api.dart';
import 'package:hackernews/models/post.dart';

final topStoriesProvider =
    StateNotifierProvider<TopStoriesNotifier, List<Post>>((ref) {
  return TopStoriesNotifier(ref);
});

class TopStoriesNotifier extends StateNotifier<List<Post>> {
  TopStoriesNotifier(this.ref) : super([]) {
    _loadTopStories();
  }

  final Ref ref;
  int page = 0;
  bool isLoading = false;

  Future<void> _loadTopStories() async {
    if (isLoading) return;
    isLoading = true;
    final newPosts = await HackerNewsAPI().getTopStories(page: page);
    state = [...state, ...newPosts];
    page++;
    isLoading = false;
  }

  void loadMorePosts() {
    if (!isLoading) {
      _loadTopStories();
    }
  }
}
