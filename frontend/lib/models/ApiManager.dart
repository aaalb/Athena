import 'package:frontend/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:frontend/models/Prenotazione.dart';
import 'package:frontend/models/Appello.dart';

User? currentUser;

Future<bool> logout() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString("access_token");
    http.Response response = await http.post(
      Uri.parse('http://localhost:8000/auth/logout'),
      headers: {"Authorization": 'Bearer $accessToken'},
    );

    await prefs.remove("access_token");
    return true;
  } catch (e) {}
  return false;
}

Future<bool> login(String email, String password) async {
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

      response = await http.get(
        Uri.parse('http://localhost:8000/api/utente/data'),
        headers: {"Authorization": "Bearer ${data['access_token']}"},
      );

      var userData = jsonDecode(response.body);
      currentUser = User.fromJson(userData);

      return true;
    }
  } catch (e) {}

  return false;
}

Future<List<Prenotazione>> fetchPrenotazioni() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String accessToken = await prefs.getString("access_token") ?? "";

  http.Response response = await http.get(
    Uri.parse('http://localhost:8000/api/appelli/prenotazioni'),
    headers: {"Authorization": "Bearer $accessToken"},
  );

  if (response.statusCode == 200) {
    var results = json.decode(response.body) as List;
    return results.map((e) => Prenotazione.fromJson(e)).toList();
  } else {
    throw Exception(response.reasonPhrase);
  }
}

Future<List<Appello>> fetchData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String access_token = prefs.getString("access_token") ?? "";
  http.Response response = await http.post(
    Uri.parse('http://localhost:8000/api/appelli'),
    headers: {"Authorization": "bearer $access_token"},
  );

  return parseData(response.body);
}

Future<bool> deleteAppello(String idProva, String data) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String access_token = prefs.getString("access_token") ?? "";
    http.Response response = await http.post(
        Uri.parse('http://localhost:8000/api/appelli/sprenota'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $access_token"
        },
        body: json.encode({'idprova': idProva, 'data': data}));
    if (response.statusCode == 200) {
      return true;
    }
  } catch (e) {}
  return false;
}
