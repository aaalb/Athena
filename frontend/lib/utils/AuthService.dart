import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';

class AuthService {
  static bool isAuthenticated = false;
  static User? userLoggedIn;

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
        AuthService.isAuthenticated = false;
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
        AuthService.isAuthenticated = true;
        userLoggedIn = await _fetchUser();
        return true;
      }
    } catch (e) {
      print('Errore durante il login: $e');
    }
    return false;
  }

  static Future<User?> _fetchUser() async {
    try {
      final response = await ApiManager.fetchData('utente/data');
      if (response != null) {
        final List<dynamic> results = json.decode(response);
        if (results.isNotEmpty) {
          return User.fromJson(results.first);
        }
      }
    } catch (e) {
      print('Errore durante il recupero dei dati dell\'utente: $e');
    }
    return null;
  }
}

class User {
  final String nome, cognome, matricola, email, dataNascita, facolta;

  User({
    required this.nome,
    required this.cognome,
    required this.matricola,
    required this.email,
    required this.dataNascita,
    required this.facolta,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nome: json['nome'] ?? '',
      cognome: json['cognome'] ?? '',
      matricola: json['matricola'] ?? '',
      email: json['email'] ?? '',
      dataNascita: json['dataNascita'] ?? '',
      facolta: json['facolta'] ?? '',
    );
  }
}
