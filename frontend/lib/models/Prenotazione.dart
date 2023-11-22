class Prenotazione {
  String attivitaDidattica, idprova, tipologia, data;

  Prenotazione({
    required this.attivitaDidattica,
    required this.idprova,
    required this.tipologia,
    required this.data,
  });

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      attivitaDidattica: json['nome'],
      tipologia: json['tipologia'],
      idprova: json['idprova'],
      data: json['data'],
    );
  }
}
