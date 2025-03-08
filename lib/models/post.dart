import 'package:hackernews/utils/timer_utils.dart';

class Post {
  String? by;
  int? descendants;
  int? id;
  List<int>? kids;
  int? score;
  String? time;
  String? title;
  String? type;
  String? url;

  Post({
    this.by,
    this.descendants,
    this.id,
    this.kids,
    this.score,
    this.time,
    this.title,
    this.type,
    this.url,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      by: json['by'] as String?,
      descendants: json['descendants'] as int?,
      id: json['id'] as int?,
      kids: (json['kids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      score: json['score'] as int?,
      time: TimerUtils.parse(json['time']),
      title: json['title'] as String?,
      type: json['type'] as String?,
      url: json['url'] as String?,
    );
  }

  @override
  String toString() {
    return 'Post(by: $by, descendants: $descendants, id: $id, kids: $kids, score: $score, time: $time, title: $title, type: $type, url: $url)';
  }
}
