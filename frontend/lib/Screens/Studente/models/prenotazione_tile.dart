import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/Prenotazioni/prenotazioni_main.dart';
import 'package:frontend/utils/ApiManager.dart';

class PrenotazioneTile extends StatelessWidget {
  final String nome, idprova, tipologia, data, dipendenza, responsabile;

  PrenotazioneTile(
      {required this.nome,
      required this.idprova,
      required this.tipologia,
      required this.data,
      required this.dipendenza,
      required this.responsabile});

  factory PrenotazioneTile.fromJson(Map<String, dynamic> json) {
    return PrenotazioneTile(
      nome: json['nome'],
      idprova: json['idprova'],
      tipologia: json['tipologia'],
      data: json['data'],
      dipendenza: json['dipendenza'] ?? "",
      responsabile: json['responsabile'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _confirmDelete(context, idprova, data);
              },
              child: const Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
            )),
        title: Text(nome),
        subtitle: Text(
          'ID Prova: ${idprova} - Tipologia: ${tipologia}',
        ),
        trailing:
            Text("$data", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

void _confirmDelete(BuildContext context, String idprova, String data) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma cancellazione prenotazione"),
          content: const Text(
              "Sei sicuro di confermare la cancellazione dell'appello?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
                onPressed: () async {
                  _deleteAppello(idprova, data);
                  //  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const Prenotazioni(),
                  ));
                },
                child: const Text("Si")),
          ],
        );
      });
}

Future<void> _deleteAppello(String idProva, String data) async {
  Map<String, dynamic> postData = {
    'idprova': idProva,
    'data': data,
  };

  ApiManager.deleteData('appelli/sprenota', postData);
}
