class Candidato {
  final String nome, cognome, email;

  Candidato({
    required this.nome,
    required this.cognome,
    required this.email,
  });

  factory Candidato.fromJson(Map<String, dynamic> json) {
    return Candidato(
      nome: json['nome'],
      cognome: json['cognome'] ?? "",
      email: json['email'],
    );
  }
}
