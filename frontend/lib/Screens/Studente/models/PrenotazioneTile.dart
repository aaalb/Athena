import 'package:flutter/material.dart';

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
