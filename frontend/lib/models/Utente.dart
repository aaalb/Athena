class utente {
  int id;
  String nome;
  String cognome;
  String email;

  bool isLogged;

  utente({
    required this.id,
    required this.nome,
    required this.cognome,
    required this.email,
    this.isLogged = true,
  });

  factory utente.fromJson(Map<String, dynamic> json) {
    return utente(
      id: json['id'] as int,
      nome: json['nome'] as String,
      cognome: json['cognome'] as String,
      email: json['email'] as String,
    );
  }
}
