class Candidato {
  final String? email;
  List<ProvaSuperata>? prove;

  Candidato({
    required this.email,
    this.prove,
  });

  factory Candidato.fromJson(Map<String, dynamic> json) {
    List<ProvaSuperata> proveList = [];
    if (json.containsKey('prove')) {
      List<dynamic> proveJson = json['prove'];

      for (var item in proveJson) {
        proveList.add(ProvaSuperata.fromJson(item));
      }
    }

    return Candidato(
      email: json['email'] ?? '',
      prove: proveList,
    );
  }
}

class ProvaSuperata {
  final String idprova;
  final int voto, bonus;

  ProvaSuperata({
    required this.idprova,
    required this.bonus,
    required this.voto,
  });

  factory ProvaSuperata.fromJson(Map<String, dynamic> json) {
    return ProvaSuperata(
      idprova: json['idprova'] ?? '',
      bonus: json['bonus'] ?? 0,
      voto: json['voto'] ?? 0,
    );
  }
}
