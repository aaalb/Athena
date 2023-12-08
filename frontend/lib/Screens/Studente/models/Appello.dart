class Appello {
  final String? idprova, nome, tipologia, data, opzionale, dipendeda;

  Appello(
      {this.idprova,
      this.nome,
      this.tipologia,
      this.data,
      this.opzionale,
      this.dipendeda});

  factory Appello.fromJson(Map<String, dynamic> json) {
    return Appello(
        idprova: json["idprova"],
        nome: json["nome"],
        tipologia: json["tipologia"],
        data: json["data"],
        opzionale: json["opzionale"] ?? '',
        dipendeda: json["dipendeda"] ?? '');
  }
}
