import 'dart:js';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static Future<bool> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString("access_token");
      final response = await http.post(
        Uri.parse('http://localhost:8000/auth/logout'),
        headers: {"Authorization": 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        await prefs.remove("access_token");
        return true;
      }
    } catch (e) {
      print('Errore durante il logout: $e');
    }
    return false;
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("access_token", data['access_token']);
        print('DEBUG AuthService: ${data["access_token"]}');
        return true;
      }
    } catch (e) {
      print('Errore durante il login: $e');
    }
    return false;
  }
}
