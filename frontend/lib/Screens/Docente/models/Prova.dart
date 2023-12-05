class Prova {
  String idProva, tipologia, dataScadenza, opzionale, dipendenza;

  Prova({
    required this.idProva,
    required this.tipologia,
    required this.opzionale,
    required this.dataScadenza,
    required this.dipendenza,
  });

  factory Prova.fromJson(Map<String, dynamic> json) {
    return Prova(
        idProva: json['idprova'],
        tipologia: json['tipologia'],
        opzionale: (json['opzionale'] == "true") ? "Si" : "No",
        dataScadenza: json['datascadenza'],
        dipendenza: json['dipendeda'] ?? "");
  }
}
