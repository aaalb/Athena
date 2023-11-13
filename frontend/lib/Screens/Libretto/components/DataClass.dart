import 'package:flutter/material.dart';

import 'package:frontend/models/Esame.dart';

class DataClass extends StatelessWidget {
  const DataClass({super.key, required this.dataList});
  final List<Esame> dataList;

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
          border: TableBorder.all(width: 1.0),
          // Data columns as required by APIs data.
          columns: const [
            DataColumn(
                label: Text(
              "Attività Didattica",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "Voto complessivo",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "Crediti",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              "Anno",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
          ],
          // Main logic and code for geting data and shoing it in table rows.
          rows: dataList
              .map(
                  //maping each rows with datalist data
                  (data) => DataRow(cells: [
                        DataCell(
                          Text(data.attivitaDidattica,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                        ),
                        DataCell(Text(data.votoComplessivo.toString(),
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500))),
                        DataCell(
                          Text(data.crediti.toString(),
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w500)),
                        ),
                        DataCell(
                          Text(data.anno.toString(),
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w500)),
                        ),
                      ]))
              .toList(), // converting at last into list.
        )));
  }
}
