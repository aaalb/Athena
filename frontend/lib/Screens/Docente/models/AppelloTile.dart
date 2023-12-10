import 'package:flutter/material.dart';
import 'Candidato.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';

Future<List<Candidato>> _fetchCandidati(String idProva, String data) async {
  var response = await ApiManager.fetchData('iscrizioni/$idProva/$data');
  if (response != null) {
    var results = json.decode(response) as List?;
    List<Candidato> list = [];
    if (results != null) {
      for (var j in results) {
        list.add(Candidato.fromJson(j));
      }
      return list;
    }
  }

  return [];
}

Future<void> _inserisciVoto(
    String idProva, String data, String email, String voto) async {
  Map<String, dynamic> postData = {
    'stud_email': email,
    'voto': voto,
  };

  // Assuming you have an ApiManager class with a postData method
  await ApiManager.postData('iscrizioni/$idProva/$data/voto',
      postData); // Changed to postData method assuming it creates an exam
}

class AppelloTile extends StatelessWidget {
  final String nome, idprova, tipologia, data, dipendenza, responsabile;
  final bool opzionale;

  AppelloTile({
    required this.idprova,
    required this.nome,
    required this.tipologia,
    required this.data,
    required this.opzionale,
    required this.dipendenza,
    required this.responsabile,
  });

  factory AppelloTile.fromJson(Map<String, dynamic> json) {
    return AppelloTile(
      idprova: json["idprova"] ?? '',
      nome: json["nome"] ?? '',
      tipologia: json["tipologia"] ?? '',
      data: json["data"] ?? '',
      opzionale: json["opzionale"] ?? '',
      dipendenza: json["dipendeda"] ?? '',
      responsabile: json["responsabile"] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(nome),
        subtitle: Text(
          'ID Prova: ${idprova} - Tipologia: ${tipologia}',
        ),
        trailing:
            Text("$data", style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () => _dialogVotiBuilder(context, idprova, data),
      ),
    );
  }
}

Future<void> _dialogVotiBuilder(
    BuildContext context, String idProva, String data) {
  List<TextEditingController> voti = [];
  late List<Candidato> candidati = [];

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Candidato>>(
            future: _fetchCandidati(idProva, data),
            builder: (BuildContext context,
                AsyncSnapshot<List<Candidato>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Errore durante il recupero dei dati'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Nessuna iscrizione alla prova'),
                );
              } else {
                candidati = snapshot.data!;
                for (int i = 0; i < candidati.length; ++i) {
                  voti.add(TextEditingController());
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: candidati.length,
                        itemBuilder: (context, index) {
                          Candidato data = candidati[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data.email}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Visibility(
                                    visible: candidati.isNotEmpty,
                                    child: Expanded(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: voti[index],
                                        decoration: const InputDecoration(
                                          labelText: 'Voto',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: candidati.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          right: 8.0,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            for (int i = 0; i < voti.length; ++i) {
                              _inserisciVoto(
                                idProva,
                                data,
                                candidati[i].email ?? "",
                                voti[i].text,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
    },
  );
}
