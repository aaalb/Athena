import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:frontend/Screens/Docente/models/Appello.dart';
import 'package:frontend/Screens/Docente/models/Candidato.dart';
import 'package:frontend/utils/ApiManager.dart';

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

  final List<Appello> dataList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        Appello data = dataList[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(data.nome),
            subtitle: Text(
              'ID Prova: ${data.idprova} - Tipologia: ${data.tipologia} - Data: ${data.data}',
            ),
            onTap: () {
              _dialogInfoBuilder(context, data);
            },
          ),
        );
      },
    );
  }
}

Future<void> _dialogInfoBuilder(BuildContext context, Appello data) {
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
                columns: const [
                  DataColumn(label: Text("ID Prova")),
                  DataColumn(label: Text("Tipologia")),
                  DataColumn(label: Text("Opzionale")),
                  DataColumn(label: Text("Data")),
                  DataColumn(label: Text("Propedeutico")),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text(data.idprova)),
                      DataCell(Text(data.tipologia)),
                      DataCell(Text(data.opzionale.toString())),
                      DataCell(Text(data.data)),
                      DataCell(Text((data.dipendenza.isNotEmpty)
                          ? data.dipendenza
                          : "No")),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.edit_document),
                    onPressed: () {
                      _dialogVotiBuilder(context, data.idprova, data.data);
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

Future<void> _dialogVotiBuilder(
    BuildContext context, String idProva, String data) {
  List<TextEditingController> voti = [];
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
                    List<Candidato> candidati = snapshot.data!;
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
                  print(voti[0].text);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
