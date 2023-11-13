import 'package:flutter/material.dart';
import 'package:frontend/Screens/Libretto/components/DataClass.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/constants.dart';
import 'package:frontend/models/Esame.dart';

import 'dart:convert';

Future<List<Esame>> fetchLibretto() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String access_token = await prefs.getString("access_token") ?? "";

  http.Response response = await http.get(
    Uri.parse('http://localhost:8000/api/libretto'),
    headers: {"Authorization": "Bearer $access_token"},
  );

  if (response.statusCode == 200) {
    var results = json.decode(response.body) as List;
    return results.map((e) => Esame.fromJson(e)).toList();
  } else {
    throw Exception(response.reasonPhrase);
  }
}

class LibrettoScreen extends StatefulWidget {
  const LibrettoScreen({super.key});

  @override
  State<LibrettoScreen> createState() => _LibrettoScreenState();
}

class _LibrettoScreenState extends State<LibrettoScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Esame>>(
      future: fetchLibretto(),
      builder: (BuildContext context, AsyncSnapshot<List<Esame>> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return const Text('no data');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: DataClass(dataList: snapshot.data as List<Esame>),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
