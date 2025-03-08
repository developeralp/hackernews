import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  static bool networkOk(List<ConnectivityResult> result) {
    if (result.any((element) =>
        element == ConnectivityResult.wifi ||
        element == ConnectivityResult.ethernet ||
        element == ConnectivityResult.mobile)) {
      return true;
    }

    return false;
  }
}
