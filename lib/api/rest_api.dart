import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:hackernews/models/post.dart';
import 'package:hackernews/models/user.dart';
import 'package:hackernews/utils/singleton.dart';

class HackerNewsAPI {
  static const String apiBase = "https://hacker-news.firebaseio.com/v0/";

  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  )
    ..interceptors.add(LogInterceptor(
      request: false,
      responseHeader: false,
      requestBody: false,
    ))
    ..httpClientAdapter = IOHttpClientAdapter();

  Future<List<Post>> getTopStories({int max = 30, int page = 0}) async {
    log('getTopStories page: $page, max: $max');
    try {
      final response = await dio.get('${apiBase}topstories.json');

      if (response.statusCode == 200) {
        List<int> allPostIds = List<int>.from(response.data);

        int start = page * max;
        List<int> postIds = allPostIds.sublist(start, start + max);

        List<Future<Post?>> futures =
            postIds.map((postId) => _getPost(id: postId)).toList();

        List<Post?> posts = await Future.wait(futures);

        return posts.whereType<Post>().toList();
      }
    } catch (e) {
      log('Error fetching top stories: $e');
      return [];
    }
    return [];
  }

  Future<User?> getUser(String userId) async {
    log('getUser: $userId');
    try {
      final response =
          await Dio().get('${apiBase}user/$userId.json?print=pretty');

      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        Singleton.instance.currentUser = user;
        return user;
      }
    } catch (e) {
      log('Error fetching user $userId: $e');
    }
    return null;
  }

  Future<List<Post>> getUserPostsEasily(int page) async {
    if (Singleton.instance.currentUser == null) {
      return [];
    }

    log('Singleton.instance.currentUser: ${Singleton.instance.currentUser?.id ?? ''}');

    return await getUserPosts(Singleton.instance.currentUser!, page);
  }

  final int postsPerPage = 30;

  Future<List<Post>> getUserPosts(User user, int page) async {
    log('getUserPosts(${user.id}), page: $page, total submitted length: ${user.submitted?.length ?? 0}');

    if (user.submitted != null) {
      List<int> postsAll = user.submitted!;

      int start = (page - 1) * postsPerPage;
      int end = start + postsPerPage;

      log('endless scroll log=> start: $start, end: $end');

      if (start >= postsAll.length) {
        log('start >= postsAll.length, came to end');
        return [];
      }

      end = end > postsAll.length ? postsAll.length : end;

      List<int> postIds = postsAll.sublist(start, end);

      List<Future<Post?>> futures =
          postIds.map((postId) => _getPost(id: postId, page: page)).toList();

      List<Post?> posts = await Future.wait(futures, eagerError: true);

      int successCount = posts.whereType<Post>().length;
      int failureCount = posts.length - successCount;
      log('Successful posts: $successCount, Failed posts: $failureCount');

      if (failureCount == posts.length) {
        log('Page empty... status: A16');
        // return getUserPosts(user, page + 1);
      }

      return posts.whereType<Post>().toList();
    }

    return [];
  }

  Future<Post?> _getPost({required int id, int page = 0}) async {
    try {
      final response = await dio.get('${apiBase}item/$id.json?print=pretty');

      if (response.statusCode == 200 &&
          response.data['type'] == 'story' &&
          response.data['url'] != null &&
          response.data['title'] != null) {
        return Post.fromJson(response.data);
      }
    } catch (e) {
      log('Error fetching post $id: $e');
    }
    return null;
  }
}
