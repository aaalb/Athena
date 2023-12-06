class Appello {
  final String dipendenza, idprova, nome, tipologia, data;
  final bool opzionale;

  Appello({
    required this.data,
    required this.dipendenza,
    required this.idprova,
    required this.nome,
    required this.opzionale,
    required this.tipologia,
  });

  factory Appello.fromJson(Map<String, dynamic> json) {
    return Appello(
      data: json['data'],
      dipendenza: json['dipendenza'] ?? "",
      idprova: json['idprova'],
      nome: json['nome'],
      opzionale: json['opzionale'],
      tipologia: json['tipologia'],
    );
  }
}
