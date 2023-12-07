import 'package:hive/hive.dart';

part 'user-data.g.dart';

@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  final String? nome;
  @HiveField(1)
  final String? cognome;
  @HiveField(2)
  final String? matricola;
  @HiveField(3)
  final String? email;
  @HiveField(4)
  final String? dataNascita;
  @HiveField(5)
  final String? facolta;
  @HiveField(6)
  final String? role;

  UserData({
    required this.nome,
    required this.cognome,
    required this.matricola,
    required this.email,
    required this.dataNascita,
    required this.facolta,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        nome: json['nome'] ?? '',
        cognome: json['cognome'] ?? '',
        matricola: json['matricola'] ?? '',
        email: json['email'] ?? '',
        dataNascita: json['dataNascita'] ?? '',
        facolta: json['facolta'] ?? '',
        role: json['role'] ?? '');
  }
}
