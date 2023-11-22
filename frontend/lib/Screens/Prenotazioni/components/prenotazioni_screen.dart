import 'package:flutter/material.dart';
import 'package:frontend/models/Prenotazione.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'DataClass.dart';
import 'package:frontend/constants.dart';

import 'dart:convert';

Future<List<Prenotazione>> fetchPrenotazioni() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String accessToken = await prefs.getString("access_token") ?? "";

  http.Response response = await http.get(
    Uri.parse('http://localhost:8000/api/appelli/prenotati'),
    headers: {"Authorization": "Bearer $accessToken"},
  );

  if (response.statusCode == 200) {
    var results = json.decode(response.body) as List;
    return results.map((e) => Prenotazione.fromJson(e)).toList();
  } else {
    throw Exception(response.reasonPhrase);
  }
}

class PrenotazioniScreen extends StatefulWidget {
  const PrenotazioniScreen({super.key});

  @override
  State<PrenotazioniScreen> createState() => _PrenotazioniScreenState();
}

class _PrenotazioniScreenState extends State<PrenotazioniScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prenotazione>>(
      future: fetchPrenotazioni(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Prenotazione>> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return const Text('no data');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: DataClass(dataList: snapshot.data as List<Prenotazione>),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
