import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/Libretto/components/DataClass.dart';
import 'package:frontend/models/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/constants.dart';
import 'package:frontend/models/Esame.dart';

Future<List<Esame>> _fetchLibretto() async {
  var response = await ApiManager.fetchData('libretto');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => Esame.fromJson(e)).toList();
    }
  }

  return [];
}

class LibrettoScreen extends StatefulWidget {
  const LibrettoScreen({super.key});

  @override
  State<LibrettoScreen> createState() => _LibrettoScreenState();
}

class _LibrettoScreenState extends State<LibrettoScreen> {
  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder<List<Esame>>
    (
      future: _fetchLibretto(),
      builder: (BuildContext context, AsyncSnapshot<List<Esame>> snapshot) 
      {
        if (snapshot.connectionState == ConnectionState.none ||
            !snapshot.hasData) 
        {
          return const Text('no data');
        } 
        else if (snapshot.connectionState == ConnectionState.done) 
        {
          return Container
          (
            padding: const EdgeInsets.all(defaultPadding),
            child: DataClass(dataList: snapshot.data as List<Esame>),
          );
        }
        else
        {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
