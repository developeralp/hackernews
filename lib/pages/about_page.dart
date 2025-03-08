import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hackernews/ui/widgets/hn_appbar.dart';

class UserAboutPage extends StatelessWidget {
  final String about;
  final String userId;

  const UserAboutPage({super.key, required this.about, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HNAppBar(title: 'About: $userId'),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: HtmlWidget(
              about,
            ),
          ),
        )));
  }
}
