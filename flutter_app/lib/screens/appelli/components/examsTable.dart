import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Exam.dart';

class ExamsTable extends StatefulWidget {
  const ExamsTable({super.key});

  @override
  State<ExamsTable> createState() => _ExamsTableState();
}

class _ExamsTableState extends State<ExamsTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              showCheckboxColumn: false,
              columnSpacing: defaultPadding,
              columns: const [
                DataColumn(
                  label: Text("Attività didattica"),
                ),
                DataColumn(
                  label: Text("Appello"),
                ),
                DataColumn(
                  label: Text("Iscrizione"),
                ),
                DataColumn(
                  label: Text("Presidente"),
                ),
                DataColumn(
                  label: Text("CFU"),
                ),
              ],
              rows: List.generate(listaAppelli.length,
                  (index) => ExamsDataRow(listaAppelli[index], context)),
            ),
          )
        ],
      ),
    );
  }
}

DataRow ExamsDataRow(Exam examInfo, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(Text(examInfo.attivitaDidattica!)),
      DataCell(Text(examInfo.appello!)),
      DataCell(Text(examInfo.iscrizione!)),
      DataCell(Text(examInfo.presidente!)),
      DataCell(Text(examInfo.CFU!)),
    ],
    onSelectChanged: ((selected) {
      _dialogBuilder(context);
    }),
  );
}

Future<void> _dialogBuilder(BuildContext context) {
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
                  columnSpacing: defaultPadding,
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
                      onPressed: () => {}, child: Text("Book up")),
                )
              ],
            ));
      });
}
