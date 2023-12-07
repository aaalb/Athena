import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/Libretto2/libretto_screen.dart';

class ExamTile extends StatelessWidget
{
  String attivita;
  String idesame;
  int voto;
  int crediti;
  int anno;
  List<Prova> storico;
  
  void Function()? onTap;

  ExamTile
  (
    {
      required this.attivita,
      required this.idesame,
      required this.voto, 
      required this.crediti, 
      required this.anno,
      required this.storico,
      this.onTap,
    }
  );

  factory ExamTile.fromJson(Map<String, dynamic> json) {
    return ExamTile(
      attivita: json['nome'],
      idesame: json['idesame'],
      voto: json['voto_complessivo'],
      crediti: json['crediti'],
      anno: json['anno'],
      storico: [Prova(nome: "canial", idprova: "outis", tipologia: "tipo", data: "oggi", voto: 31)],
      //data: json['data'],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Card
    (
      margin: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 222, 180, 180),
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile
      (
        title: Text(attivita),
        subtitle: Text
        (
          'ID Esame: $idesame - Anno: $anno - Crediti: $crediti',
        ),
        trailing: Text("$voto"),
        onTap: onTap,
      ),
    );
  }
}


class ProvaTile extends StatelessWidget
{
  String nome;
  String idprova;
  String data;
  String tipologia;
  int voto;

  ProvaTile
  (
    {
      required this.nome,
      required this.idprova,
      required this.data, 
      required this.tipologia, 
      required this.voto,
    }
  );

  @override
  Widget build(BuildContext context)
  {
    return Card
    (
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: ListTile
      (
        title: Text(nome),
        subtitle: Text
        (
          '$idprova - $data - $tipologia',
        ),
        trailing: Text("$voto"),
      )
    );
  }
}

