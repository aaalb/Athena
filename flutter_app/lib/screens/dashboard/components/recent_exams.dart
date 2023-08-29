import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/RecentExam.dart';

class RecentExams extends StatefulWidget {
  const RecentExams({super.key});

  @override
  State<RecentExams> createState() => _RecentExamsState();
}

class _RecentExamsState extends State<RecentExams> {
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
          Text('Recent Exams', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: const [
                DataColumn(
                  label: Text("Name"),
                ),
                DataColumn(
                  label: Text("Credits"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text('Vote'),
                ),
              ],
              rows: List.generate(listRecentExams.length,
                  (index) => recentExamsDataRow(listRecentExams[index])),
            ),
          )
        ],
      ),
    );
  }
}

DataRow recentExamsDataRow(RecentExam examInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(examInfo.name!),
            ),
          ],
        ),
      ),
      DataCell(Text(examInfo.credits!)),
      DataCell(Text(examInfo.date!)),
      DataCell(Text(examInfo.vote!)),
    ],
  );
}
