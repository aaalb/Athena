import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static bool isAuthenticated = false;

  static Future<bool> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString("access_token");
      http.Response response = await http.post(
        Uri.parse('http://localhost:8000/auth/logout'),
        headers: {"Authorization": 'Bearer $accessToken'},
      );

      await prefs.remove("access_token");
      AuthService.isAuthenticated = false;

      return true;
    } catch (e) {}
    return false;
  }

  static Future<bool> login(String email, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse('http://localhost:8000/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        //TO-DO: change sharedpreferences with something encrypted
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("access_token", data['access_token']);

        AuthService.isAuthenticated = true;

        return true;
      }
    } catch (e) {}

    return false;
  }
}
