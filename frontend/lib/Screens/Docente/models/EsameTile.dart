import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'Prova.dart';

class EsameTile extends StatelessWidget {
  final String nome, idesame;
  final int crediti, anno;
  final List<Prova> prove;

  EsameTile({
    required this.idesame,
    required this.nome,
    required this.crediti,
    required this.anno,
    required this.prove,
  });

  factory EsameTile.fromJson(Map<String, dynamic> json) {
    List<dynamic> proveJson = json['prove'];

    List<Prova> proveList = [];
    for (var item in proveJson) {
      proveList.add(Prova.fromJson(item));
    }

    return EsameTile(
        idesame: json["idesame"] ?? '',
        nome: json["nome"] ?? '',
        crediti: json["crediti"] ?? '',
        anno: json["anno"] ?? '',
        prove: proveList);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmDelete(context, idesame),
        ),
        title: Text(nome),
        subtitle: Text(
          'ID Esame: ${idesame} - Crediti: ${crediti} - Anno: ${anno}',
        ),
        trailing: IconButton(
          icon: Icon(Icons.book_rounded),
          onPressed: () {},
        ),
        onTap: () {},
      ),
    );
  }
}

void _confirmDelete(BuildContext context, String idesame) {
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
                  _deleteEsame(idesame);
                },
                child: const Text("Si")),
          ],
        );
      });
}

Future<void> _deleteEsame(String idEsame) async {
  Map<String, dynamic> postData = {
    'idesame': idEsame,
  };

  ApiManager.deleteData('esami/elimina', postData);
}
