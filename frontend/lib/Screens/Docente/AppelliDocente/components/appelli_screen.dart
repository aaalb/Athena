import 'package:flutter/material.dart';
import './DataClass.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/constants.dart';
import 'package:frontend/Screens/Docente/models/Appello.dart';

Future<List<Appello>> _fetchAppelli() async {
  var response = await ApiManager.fetchData('docente/appelli');
  if (response != null) {
    var results = json.decode(response) as List?;
    List<Appello> list = [];
    if (results != null) {
      for (var j in results) {
        list.add(Appello.fromJson(j));
      }
      return list;
    }
  }

  return [];
}

class AppelliDocenteScreen extends StatefulWidget {
  const AppelliDocenteScreen({Key? key}) : super(key: key);

  @override
  State<AppelliDocenteScreen> createState() => _AppelliDocenteScreenState();
}

class _AppelliDocenteScreenState extends State<AppelliDocenteScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appello>>(
      future: _fetchAppelli(),
      builder: (BuildContext context, AsyncSnapshot<List<Appello>> snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            !snapshot.hasData) {
          return const Text('Nessun dato disponibil');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Stack(fit: StackFit.expand, children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              child: DataClass(dataList: snapshot.data!),
            ),
          ]);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
