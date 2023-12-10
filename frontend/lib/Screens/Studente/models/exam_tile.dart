import 'package:flutter/material.dart';

class ExamTile extends StatelessWidget {
  String nome;
  String idesame;
  int voto;
  int crediti;
  int anno;
  List<ProvaTile> storico;

  void Function()? onTap;

  ExamTile({
    required this.nome,
    required this.idesame,
    required this.voto,
    required this.crediti,
    required this.anno,
    required this.storico,
    this.onTap,
  });

  factory ExamTile.fromJson(Map<String, dynamic> json) {
    List<dynamic> proveJson = json['prove'];

    List<ProvaTile> proveList = [];
    for (var item in proveJson) {
      proveList.add(ProvaTile.fromJson(item));
    }
    return ExamTile(
      nome: json['nome'] ?? '',
      idesame: json['idesame'] ?? '',
      voto: json['voto_complessivo'] ?? '',
      crediti: json['crediti'] ?? 0,
      anno: json['anno'] ?? 0,
      storico: proveList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 222, 180, 180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(nome),
        subtitle: Text(
          'ID Esame: $idesame - Anno: $anno - Crediti: $crediti',
        ),
        trailing: Text("$voto"),
        onTap: onTap,
      ),
    );
  }
}

class ProvaTile extends StatelessWidget {
  String idprova, tipologia, data;
  bool idoneita;
  int voto;

  ProvaTile(
      {required this.tipologia,
      required this.idprova,
      required this.idoneita,
      required this.voto,
      required this.data});

  factory ProvaTile.fromJson(Map<String, dynamic> json) {
    return ProvaTile(
      idprova: json['idprova'] ?? '',
      tipologia: json['tipologia'] ?? '',
      idoneita: json['idoneita'],
      voto: json['voto'],
      data: json['data'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: (idoneita)
            ? Color.fromARGB(91, 206, 254, 208)
            : Color.fromARGB(255, 255, 206, 202),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: ListTile(
          title: Text(idprova),
          subtitle: Text(
            'Tipologia: $idprova - Data - ${data}',
          ),
          trailing: Text("$voto"),
        ));
  }
}
