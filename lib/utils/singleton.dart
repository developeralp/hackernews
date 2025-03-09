import 'package:hackernews/models/user.dart';

class Singleton {
  static final Singleton _instance = Singleton._internal();
  static Singleton get instance => _instance;

  User? currentUser;
  List<int> postIds = [];

  Singleton._internal();
}
