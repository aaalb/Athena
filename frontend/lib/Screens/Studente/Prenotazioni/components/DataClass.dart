import 'package:flutter/material.dart';
import 'package:frontend/models/ApiManager.dart';
import 'package:frontend/models/Prenotazione.dart';

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
          border: TableBorder.all(color: Colors.black),
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
                      _dialogBuilder(context, data.idprova, data.data);
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

Future<void> _dialogBuilder(BuildContext context, String idProva, String data) {
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
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("Exam Type"),
                    ),
                    DataColumn(
                      label: Text("Professor"),
                    ),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text("ciao")),
                      DataCell(Text("ciao")),
                      DataCell(Text("ciao")),
                    ])
                  ],
                ),
                Positioned(
                  top: 50,
                  child: ElevatedButton(
                      onPressed: () => {
                            _sprenota(idProva, data),
                          },
                      child: const Text("Cancella Prenotazione")),
                )
              ],
            )
            /*child: Column(
            children: [
              DataTable(
                showCheckboxColumn: false,
                columnSpacing: 8.0,
                columns: const [
                  DataColumn(label: Text("Attività Didattica")),
                  DataColumn(label: Text("Data")),
                  DataColumn(label: Text("Tipologia")),
                  DataColumn(label: Text("Presidente")),
                  DataColumn(label: Text("CFU"))
                ],
                rows: datalistAppello
                    .map(
                      //maping each rows with datalist data
                      (data) => DataRow(cells: [
                        DataCell(Text(data.attivitaDidattica ?? '')),
                        DataCell(Text(data.data ?? '')),
                        DataCell(Text(data.tipologia ?? '')),
                        DataCell(Text(data.presidente ?? '')),
                        DataCell(Text(data.CFU ?? '')),
                      ]),
                    )
                    .toList(),
              )
            ],
          ),*/
            );
      });
}
