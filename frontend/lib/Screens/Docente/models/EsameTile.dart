import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'Prova.dart';
import 'Candidato.dart';
import 'dart:convert';

Future<List<Candidato>> _fetchCandidati(String idEsame) async {
  var response = await ApiManager.fetchData('esami/$idEsame/candidati');
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

class EsameTile extends StatelessWidget {
  final String nome, idesame;
  final int crediti, anno;
  final List<Prova> prove;
  void Function()? onTap;

  EsameTile({
    required this.idesame,
    required this.nome,
    required this.crediti,
    required this.anno,
    required this.prove,
    this.onTap,
  });

  factory EsameTile.fromJson(Map<String, dynamic> json) {
    List<dynamic> proveJson = json['prove'];

    List<Prova> proveList = [];
    for (var item in proveJson) {
      proveList.add(Prova.fromJson(item));
    }

    return EsameTile(
      idesame: json["idesame"] ?? '',
      nome: json["nome"] ?? '',
      crediti: json["crediti"] ?? '',
      anno: json["anno"] ?? '',
      prove: proveList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: () => _confirmDelete(context, idesame),
        ),
        title: Text(nome),
        subtitle: Text(
          'ID Esame: ${idesame} - Crediti: ${crediti} - Anno: ${anno}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.library_books_rounded),
          onPressed: () {
            _dialogVotiBuilder(context, idesame);
          },
        ),
        onTap: onTap,
      ),
    );
  }
}

void _confirmDelete(BuildContext context, String idesame) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma cancellazione esame"),
          content: const Text(
              "Sei sicuro di confermare la cancellazione dell'esame?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
                onPressed: () async {
                  _deleteEsame(idesame);
                  Navigator.of(context).pop();
                },
                child: const Text("Si")),
          ],
        );
      });
}

Future<void> _dialogVotiBuilder(BuildContext context, String idEsame) {
  List<TextEditingController> voti = [];
  List<Candidato> candidati = [];

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Candidato>>(
                future: _fetchCandidati(idEsame),
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
                      child: Text('Nessun voto da registrare'),
                    );
                  } else {
                    candidati = snapshot.data!;
                    for (int i = 0; i < candidati.length; ++i) {
                      voti.add(TextEditingController());
                    }
                    return ListView.builder(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    );
                  }
                },
              ),
            ),
            Visibility(
              visible: true,
              child: Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    for (int i = 0; i < voti.length; ++i) {
                      _inserisciVoto(
                        idEsame,
                        candidati[i].email ?? '',
                        voti[i].text,
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

Future<void> _deleteEsame(String idEsame) async {
  Map<String, dynamic> postData = {
    'idesame': idEsame,
  };

  ApiManager.deleteData('esami/elimina', postData);
}

class ProvaTile extends StatelessWidget {
  String idProva, tipologia, dataScadenza, opzionale, dipendenza;

  ProvaTile({
    required this.idProva,
    required this.tipologia,
    required this.opzionale,
    required this.dataScadenza,
    required this.dipendenza,
  });

  factory ProvaTile.fromJson(Map<String, dynamic> json) {
    return ProvaTile(
      idProva: json['idprova'],
      tipologia: json['tipologia'],
      opzionale: (json['opzionale'] == "true") ? "Si" : "No",
      dataScadenza: json['datascadenza'],
      dipendenza: json['dipendeda'] ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    String opzionale_text = (opzionale == "Si") ? "Opzionale" : "";
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: ListTile(
          title: Text(idProva),
          subtitle: Text(
            'Tipologia: $tipologia - Scadenza: ${dataScadenza}',
          ),
          trailing: Text(opzionale_text),
        ));
  }
}

Future<void> _inserisciVoto(String idEsame, String email, String voto) async {
  Map<String, dynamic> postData = {
    'idesame': idEsame,
    'stud_email': email,
    'voto': voto,
  };

  // Assuming you have an ApiManager class with a postData method
  await ApiManager.postData('libretto/inserisci',
      postData); // Changed to postData method assuming it creates an exam
}
