// token_util.dart

import 'package:shared_preferences/shared_preferences.dart';

class TokenUtil {
  static Future<String?> fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
