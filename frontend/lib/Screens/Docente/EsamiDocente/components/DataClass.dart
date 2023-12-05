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
                              : "Nessuna")),
                        ],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                onPressed: () {
                  _eliminaEsame(idEsame);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Elimina esame",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
