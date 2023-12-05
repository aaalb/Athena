import 'package:flutter/material.dart';
import 'package:frontend/Screens/Docente/models/Esame.dart';
import 'package:frontend/Screens/Docente/models/Prova.dart';
import 'package:frontend/utils/ApiManager.dart';

void _eliminaEsame(String idesame) {
  Map<String, dynamic> postData = {
    'idesame': idesame,
  };

  ApiManager.deleteData('esami/elimina', postData);
}

class DataClass extends StatelessWidget {
  const DataClass({
    Key? key,
    required this.dataList,
  }) : super(key: key);

  final List<Esame> dataList;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      sortColumnIndex: 1,
      showCheckboxColumn: false,
      columns: const [
        DataColumn(label: Text("ID Esame")),
        DataColumn(label: Text("Attività Didattica")),
        DataColumn(label: Text("Crediti")),
        DataColumn(label: Text("Anno")),
      ],
      rows: dataList
          .map(
            (data) => DataRow(
              cells: [
                DataCell(Text(data.idesame)),
                DataCell(Text(data.attivitaDidattica)),
                DataCell(Text(data.crediti.toString())),
                DataCell(Text(data.anno.toString())),
              ],
              onSelectChanged: (selected) {
                _dialogBuilder(context, data.proveList, data.idesame);
              },
            ),
          )
          .toList(),
    );
  }
}

Future<void> _dialogBuilder(
    BuildContext context, List<Prova> proveList, String idEsame) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Aggiungi padding al Dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DataTable(
                  sortColumnIndex: 1,
                  showCheckboxColumn: false,
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
                            DataCell(Text(data.dipendenza)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _eliminaEsame(idEsame);
                  Navigator.of(context)
                      .pop(); // Chiudi il dialog dopo la cancellazione
                },
                child: const Text("Elimina esame"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
