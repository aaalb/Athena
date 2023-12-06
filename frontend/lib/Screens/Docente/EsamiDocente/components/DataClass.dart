import 'package:flutter/material.dart';
import 'package:frontend/Screens/Docente/models/Esame.dart';
import 'package:frontend/Screens/Docente/models/Prova.dart';
import 'package:frontend/utils/ApiManager.dart';

class Prova {
  final String idprova; 
  final int voto, bonus;

  Prova({
    required this.idprova,
    required this.voto,
    required this.bonus,
  });

  factory Prova.fromJson(Map<String, dynamic> json) {
    return Prova(
      idprova: json['idprova'],
      voto: json['voto'] ?? "",
      bonus: json['bonus'] ?? "",
    );
  }
}


void _eliminaEsame(String idesame) {
  Map<String, dynamic> postData = {
    'idesame': idesame,
  };

  ApiManager.deleteData('esami/elimina', postData);
}

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

class DataClass extends StatelessWidget {
  const DataClass({
    Key? key,
    required this.dataList,
  }) : super(key: key);

  final List<Esame> dataList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        Esame data = dataList[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(data.attivitaDidattica),
            subtitle: Text(
              'ID Esame: ${data.idesame} - Anno: ${data.anno} - Crediti: ${data.crediti}',
            ),
            onTap: () {
              _dialogBuilder(context, data.proveList, data.idesame);
            },
          ),
        );
      },
    );
  }
}

Future<void> _dialogBuilder(
    BuildContext context, List<Prova> proveList, String idEsame) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white, // Set dialog background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DataTable(
                columnSpacing: 20.0,
                headingRowHeight: 40.0,
                sortColumnIndex: 1,
                columns: const [
                  DataColumn(label: Text("ID Prova")),
                  DataColumn(label: Text("Tipologia")),
                  DataColumn(label: Text("Opzionale")),
                  DataColumn(label: Text("Scadenza")),
                  DataColumn(label: Text("Propedeutico")),
                ],
                rows: proveList
                    .map(
                      (data) => DataRow(
                        cells: [
                          DataCell(Text(data.idProva)),
                          DataCell(Text(data.tipologia)),
                          DataCell(Text(data.opzionale)),
                          DataCell(Text(data.dataScadenza)),
                          DataCell(Text((data.dipendenza) != ""
                              ? data.dipendenza
                              : "No")),
                        ],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.book_rounded),
                    onPressed: () {
                      _dialogCandidatiBuilder(context, idProva, data)
                    },
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _eliminaEsame(idEsame);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _dialogCandidatiBuilder(
    BuildContext context, String idEsame) {
  List<TextEditingController> voti = [];
  List<String> candidati = [];
  List<Prova> 

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
                future: _fetchCandidati(idProva, data),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Candidato>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
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
                    ;
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
                                        "${data.cognome} ${data.nome}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Email: ${data.email}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: voti[index],
                                    decoration: const InputDecoration(
                                      labelText: 'Voto',
                                      border: OutlineInputBorder(),
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
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  for (int i = 0; i < voti.length; ++i) {
                    _inserisciVoto(
                        idProva, data, candidati[i].email, voti[i].text);
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

