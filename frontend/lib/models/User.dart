class User {
  String nome;
  String cognome;
  String matricola;
  String email;
  String datanascita;
  String facolta;
  bool isLogged;

  User({
    required this.nome,
    required this.cognome,
    required this.matricola,
    required this.email,
    required this.datanascita,
    required this.facolta,
    this.isLogged = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nome: json['nome'] as String,
        cognome: json['cognome'] as String,
        matricola: json['matricola'] as String,
        email: json['email'] as String,
        datanascita: json['datanascita'] as String,
        facolta: json['facolta'] as String);
  }

  void loggedOut() {
    isLogged = false;
  }
}
