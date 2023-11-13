import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Appello {
  final String? attivitaDidattica, data, tipologia, presidente, CFU;

  Appello({
    this.attivitaDidattica,
    this.data,
    this.tipologia,
    this.presidente,
    this.CFU,
  });

  factory Appello.fromJson(Map<String, dynamic> json) {
    return Appello(
      attivitaDidattica: json["attivitaDidattica"],
      data: json["data"],
      tipologia: json["tipologia"],
      presidente: json["presidente"],
      CFU: json["CFU"],
    );
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

List<Appello> parseData(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<Appello>((json) => Appello.fromJson(json)).toList();
}
