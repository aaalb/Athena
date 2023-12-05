import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'package:frontend/Screens/Studente/models/Prenotazione.dart';

void _sprenota(String idProva, String data) {
  Map<String, dynamic> postData = {
    'idprova': idProva,
    'data': data,
  };

  ApiManager.deleteData('/appelli/sprenota', postData);
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

Future<void> _dialogBuilder(BuildContext context, Prenotazione data) {
  return showDialog<void>(
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
                rows: [],
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
    },
  );
}
