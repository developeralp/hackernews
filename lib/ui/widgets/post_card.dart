import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackernews/models/post.dart';
import 'package:hackernews/pages/user_page.dart';
import 'package:hackernews/providers/internet_provider.dart';
import 'package:hackernews/utils/singleton.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final bool forUser;

  const PostCard({
    super.key,
    required this.post,
    this.forUser = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            OnlineTypes onlineResult = ref.read(isOnlineProvider);

            if (onlineResult == OnlineTypes.offline) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("No internet connection"),
              ));
              return;
            }

            if (post.url != null && post.url!.isNotEmpty) {
              launchUrl(Uri.parse(post.url!));
            } else {
              launchUrl(
                  Uri.parse('https://news.ycombinator.com/item?id=${post.id}'));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!forUser) const SizedBox(height: 10),
                if (!forUser)
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: UserPart(
                          userName: post.by ?? '',
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${post.score}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_upward_rounded,
                                color: Colors.grey[600], size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Text(
                  post.time ?? '',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
        ));
  }
}

class UserPart extends ConsumerWidget {
  final String userName;
  final bool userCard;

  const UserPart({
    super.key,
    required this.userName,
    this.userCard = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        splashColor: userCard ? Colors.transparent : Colors.grey[300],
        onTap: () async {
          if (userCard) return;

          OnlineTypes onlineResult = ref.read(isOnlineProvider);

          if (onlineResult == OnlineTypes.offline) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No internet connection"),
            ));
            return;
          }

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserPage(userName),
            ),
          );

          Singleton.instance.currentUser = null;
          Singleton.instance.postIds = [];
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 16, color: Colors.grey[700]),
            ),
            const SizedBox(width: 8),
            Text(
              userName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}
