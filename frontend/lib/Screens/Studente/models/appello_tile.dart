import 'package:flutter/material.dart';

class AppelloTile extends StatelessWidget {
  String idprova;
  String nome;
  String tipologia;
  String data;
  bool opzionale;
  String dipendenza;

  void Function()? onTap;

  AppelloTile({
    required this.nome,
    required this.idprova,
    required this.tipologia,
    required this.data,
    required this.opzionale,
    required this.dipendenza,
    this.onTap,
  });

  factory AppelloTile.fromJson(Map<String, dynamic> json) {
    return AppelloTile(
      nome: json['nome'] ?? '',
      idprova: json['idprova'] ?? '',
      tipologia: json['tipologia'] ?? '',
      data: json['data'] ?? '',
      opzionale: json['opzionale'] ?? false,
      dipendenza: json['dipendeda'] ?? 'Nessuna',
    );
  }

  @override
  Widget build(BuildContext context) {
    String opzionale_str = (opzionale) ? "Si" : "No";
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 222, 180, 180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(nome),
        subtitle: Text(
          'ID Prova: $idprova - Tipologia: $tipologia - Opzionale: ${opzionale_str} - Dipendenza: $dipendenza',
        ),
        trailing: Text(data),
        onTap: onTap,
      ),
    );
  }
}

/*
class ConfermaAppelloTile extends StatelessWidget {



  ConfermaAppelloTile()
  factory ProvaTile.fromJson(Map<String, dynamic> json) {
    return ProvaTile(
      idprova: json['idprova'] ?? '',
      tipologia: json['tipologia'] ?? '',
      opzionale: json['opzionale'] ?? '',
      voto: json['voto'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: ListTile(
          title: Text(idprova),
          subtitle: Text(
            'Tipologia: $idprova - Opzionale - ${opzionale.toString()}',
          ),
          trailing: Text("$voto"),
        ));
  }
}
*/
