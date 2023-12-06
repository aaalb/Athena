import 'package:flutter/material.dart';

import 'package:frontend/Screens/Studente/models/Esame.dart';

class DataClass extends StatelessWidget
{
  const DataClass({super.key, required this.dataList});
  final List<Esame> dataList;

  @override
  Widget build(BuildContext context)
  {
    return SingleChildScrollView
    (
      // Using scrollView for scrolling and formating
      scrollDirection: Axis.vertical,
      // using FittedBox for fitting complte table in screen horizontally.
      child: FittedBox
      (
        child: DataTable
        (
          sortColumnIndex: 1,
          showCheckboxColumn: false,
          border: TableBorder.all(width: 1.0),
          // Data columns as required by APIs data.
          columns: const 
          [
            DataColumn(label: Text("Attività Didattica")),
            DataColumn(label: Text("Voto complessivo")),
            DataColumn(label: Text("Crediti")),
            DataColumn(label: Text("Anno")),
          ],
          // Main logic and code for geting data and shoing it in table rows.
          rows: dataList
              .map(
                  //maping each rows with datalist data
                  (data) => DataRow(cells: [
                        DataCell(Text(data.attivitaDidattica)),
                        DataCell(Text(data.votoComplessivo.toString())),
                        DataCell(Text(data.crediti.toString())),
                        DataCell(Text(data.anno.toString())),
                      ]))
              .toList(), // converting at last into list.
        )
      )
    );
  }
}
