import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hackernews/models/user.dart';
import 'package:hackernews/pages/about_page.dart';
import 'package:hackernews/ui/widgets/post_card.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserPart(userName: user.id ?? '', userCard: true),
              const SizedBox(
                height: 10,
              ),
              Text('Created: ${user.created}'),
              const SizedBox(
                height: 10,
              ),
              UserAboutWidget(about: user.about ?? '', userId: user.id ?? ''),
            ],
          ),
        ));
  }
}

class UserAboutWidget extends StatelessWidget {
  final String about;
  final String userId;

  final int empty = -(8 * 1);
  final int text = 8 * 1;

  int expandedOrButton() {
    if (about.isEmpty) return empty;
    return text;
  }

  bool shouldIExpand() {
    if (about.split('<p>').length > 2 || about.length > 150) {
      return false;
    }

    return true;
  }

  const UserAboutWidget({super.key, required this.about, required this.userId});

  @override
  Widget build(BuildContext context) {
    int result = expandedOrButton();

    return Column(
      children: [
        if (result == empty)
          Text(
            "User's about is empty",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        if (result == text)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              HtmlWidget(
                about.length > 32 ? '${about.substring(0, 32)}...' : about,
              ),
              if (about.length > 32)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    side: BorderSide(
                      width: 0.75,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Text('Read all'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserAboutPage(
                          about: about,
                          userId: userId,
                        ),
                      ),
                    );
                  },
                )
            ],
          ),
      ],
    );
  }
}
