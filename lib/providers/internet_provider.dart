import 'package:flutter_riverpod/flutter_riverpod.dart';

final isOnlineProvider =
    StateProvider<OnlineTypes>((ref) => OnlineTypes.neutral);

enum OnlineTypes {
  neutral,
  online,
  offline,
}
