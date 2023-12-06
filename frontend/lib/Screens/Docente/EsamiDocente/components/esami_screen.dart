import 'package:flutter/material.dart';
import './DataClass.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/constants.dart';
import 'package:frontend/Screens/Docente/models/Esame.dart';
import 'CreazioneEsame.dart';
/*
Future<List<Esame>> _fetchEsami() async {
  var response = await ApiManager.fetchData('esami');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => Esame.fromJson(e)).toList();
    }
  }

  return [];
}

class EsamiDocenteScreen extends StatefulWidget {
  const EsamiDocenteScreen({Key? key}) : super(key: key);

  @override
  State<EsamiDocenteScreen> createState() => _EsamiDocenteScreenState();
}

class _EsamiDocenteScreenState extends State<EsamiDocenteScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Esame>>(
      future: _fetchEsami(),
      builder: (BuildContext context, AsyncSnapshot<List<Esame>> snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            !snapshot.hasData) {
          return const Text('Nessun dato disponibil');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                child: DataClass(dataList: snapshot.data!),
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    creaEsame(context);
                  },
                  child: const Icon(Icons.add),
                  backgroundColor:
                      Colors.blue, // Personalizza il colore del pulsante
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
*/