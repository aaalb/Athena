class Esame {
  String attivitaDidattica;
  int votoComplessivo, crediti, anno;

  Esame({
    required this.attivitaDidattica,
    required this.votoComplessivo,
    required this.crediti,
    required this.anno,
  });

  factory Esame.fromJson(Map<String, dynamic> json) {
    return Esame(
      attivitaDidattica: json['nome'],
      votoComplessivo: json['voto_complessivo'],
      crediti: json['crediti'],
      anno: json['anno'],
    );
  }
}
