import 'package:hackernews/models/post.dart';
import 'package:hackernews/utils/constants.dart';
import 'package:hackernews/utils/timer_utils.dart';

class User {
  String? about;
  String? created;
  String? id;
  int? karma;
  List<int>? submitted;
  List<Post> posts;

  User(
      {this.about,
      this.created,
      this.id,
      this.karma,
      this.submitted,
      this.posts = const []});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        about: json['about'] as String?,
        created: (TimerUtils.parseDate(json['created'])),
        id: json['id'] as String?,
        karma: json['karma'] as int?,
        submitted: (json['submitted'] as List<dynamic>?)?.cast<int>());
  }

  int maxPage({int itemCountPerPage = Constants.maxPostPerPage}) {
    if (submitted == null) return 0;

    return (submitted!.length / itemCountPerPage).ceil();
  }

  @override
  String toString() {
    return 'User{about: $about, created: $created, id: $id, karma: $karma, submitted: $submitted}';
  }
}
