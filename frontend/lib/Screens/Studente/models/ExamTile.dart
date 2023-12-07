import 'package:flutter/material.dart';

class ExamTile extends StatelessWidget {
  final String nome, data, idesame;
  final int voto, crediti, anno;

  ExamTile(
      {required this.nome,
      required this.idesame,
      required this.voto,
      required this.crediti,
      required this.anno,
      required this.data});

  factory ExamTile.fromJson(Map<String, dynamic> json) {
    return ExamTile(
      nome: json['nome'],
      idesame: json['idesame'],
      voto: json['voto_complessivo'],
      crediti: json['crediti'],
      anno: json['anno'],
      data: json['data'],
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
        leading: Text(nome),
        subtitle: Text(
          'ID Esame: ${idesame} - Anno: ${anno} - Crediti: ${crediti} - Data: ${data}',
        ),
        trailing:
            Text("$voto", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
