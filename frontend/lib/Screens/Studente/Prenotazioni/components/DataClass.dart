import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'package:frontend/Screens/Studente/models/Appello.dart';
import 'package:frontend/Screens/Studente/models/Prenotazione.dart';
import 'dart:convert';

void _sprenota(String idProva, String data) {
  Map<String, dynamic> postData = {
    'idprova': idProva,
    'data': data,
  };

  ApiManager.deleteData('/appelli/sprenota', postData);
}

Future<List<Appello>> _getInfoEsami(String idprova) async {
  var response = await ApiManager.fetchData('appelli/$idprova/info');
  if (response != null) {
    var result = json.decode(response) as List?;
    if (result != null) {
      return result.map((e) => Appello.fromJson(e)).toList();
    }
  }
  return [];
}

class DataClass extends StatelessWidget {
  const DataClass({
    super.key,
    required this.dataListPrenotazioni,
  });
  final List<Prenotazione> dataListPrenotazioni;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        // Using scrollView for scrolling and formating
        scrollDirection: Axis.vertical,
        // using FittedBox for fitting complte table in screen horizontally.
        child: FittedBox(
            child: DataTable(
          sortColumnIndex: 1,
          showCheckboxColumn: false,
          // Data columns as required by APIs data.
          columns: const [
            DataColumn(label: Text("ID Prova")),
            DataColumn(label: Text("Attività Didattica")),
            DataColumn(label: Text("Tipologia")),
            DataColumn(label: Text("Data")),
            // DataColumn(label: Text("Modifica Prenotazione")),
          ],
          // Main logic and code for geting data and shoing it in table rows.
          rows: dataListPrenotazioni
              .map(
                //maping each rows with datalist data
                (data) => DataRow(
                    onSelectChanged: ((selected) {
                      _dialogBuilder(context, data);
                    }),
                    cells: [
                      DataCell(Text(data.idprova)),
                      DataCell(Text(data.attivitaDidattica)),
                      DataCell(Text(data.tipologia)),
                      DataCell(Text(data.data)),
                    ]),
              )
              .toList(), // converting at last into list.
        )));
  }
}

FutureBuilder<List<Appello>> _dialogBuilder(
    BuildContext context, Prenotazione data) {
  return FutureBuilder<List<Appello>>(
      future: _getInfoEsami(data.idprova),
      builder: (BuildContext context, AsyncSnapshot<List<Appello>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Se il futuro è in attesa, puoi mostrare un indicatore di caricamento
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Se si verifica un errore durante il caricamento del futuro
          return Text('Errore: ${snapshot.error}');
        } else {
          // Se il futuro è stato completato con successo
          List<Appello>? dataEsame = snapshot.data;
          if (dataEsame != null && dataEsame.isNotEmpty) {
            return Dialog(
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                insetPadding: const EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: 8.0,
                      columns: const [
                        DataColumn(
                          label: Text("ID Prova"),
                        ),
                        DataColumn(
                          label: Text("Nome"),
                        ),
                        DataColumn(
                          label: Text("Tipologia"),
                        ),
                        DataColumn(
                          label: Text("Data"),
                        ),
                        DataColumn(
                          label: Text("Opzionale"),
                        ),
                        DataColumn(label: Text("Dipende Da"))
                      ],
                      rows: dataEsame
                          .map((data) => DataRow(cells: [
                                DataCell(Text(data.idprova ?? '')),
                                DataCell(Text(data.nome ?? '')),
                                DataCell(Text(data.tipologia ?? '')),
                                DataCell(Text(data.data ?? '')),
                                DataCell(Text(data.opzionale ?? '')),
                                DataCell(Text(data.dipendeda ?? ''))
                              ]))
                          .toList(),
                    ),
                    Positioned(
                      top: 50,
                      child: ElevatedButton(
                          onPressed: () => {
                                _sprenota(data.idprova, data.data),
                              },
                          child: const Text("Cancella Prenotazione")),
                    )
                  ],
                ));
          } else {
            // Gestione del caso in cui la lista sia vuota
            return Text('Nessun dato disponibile');
          }
        }
      });

  /* return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              DataTable(
                  showCheckboxColumn: false,
                  columnSpacing: 8.0,
                  columns: const [
                    DataColumn(
                      label: Text("ID Prova"),
                    ),
                    DataColumn(
                      label: Text("Tipologia"),
                    ),
                    DataColumn(
                      label: Text("Opzionale"),
                    ),
                    DataColumn(
                      label: Text("Scadenza"),
                    ),
                    DataColumn(
                      label: Text("Dipendenza"),
                    )
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text(data.attivitaDidattica)),
                      DataCell(Text(data.data))
                    ])
                  ]),
              Positioned(
                top: 50,
                child: ElevatedButton(
                    onPressed: () => {
                          _sprenota(data.idprova, data.data),
                        },
                    child: const Text("Cancella Prenotazione")),
              )
            ],
          ));
    },
  );*/
}
