import './Prova.dart';
import 'dart:convert';

class Esame {
  String attivitaDidattica, idesame;
  int crediti, anno;
  List<Prova> proveList;

  Esame({
    required this.idesame,
    required this.attivitaDidattica,
    required this.crediti,
    required this.anno,
    required this.proveList,
  });

  factory Esame.fromJson(Map<String, dynamic> esamiJson) {
    List<dynamic> proveJson = esamiJson['prove'];

    List<Prova> proveList = [];
    for (var item in proveJson) {
      proveList.add(Prova.fromJson(item));
    }

    return Esame(
      idesame: esamiJson['idesame'],
      attivitaDidattica: esamiJson['nome'],
      crediti: esamiJson['crediti'],
      anno: esamiJson['anno'],
      proveList: proveList,
    );
  }
}
