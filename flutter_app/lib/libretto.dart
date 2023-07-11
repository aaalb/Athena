import 'package:flutter/material.dart';

class Exam {
  final String name;
  final String date;

  Exam({required this.name, required this.date});

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      name: json['name'],
      date: json['date'],
    );
  }
}

class Libretto extends StatefulWidget {
  const Libretto({super.key});

  @override
  State<Libretto> createState() => _LibrettoState();
}

class _LibrettoState extends State<Libretto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ExamsTable(),
    );
  }
}

class ExamsTable extends StatefulWidget {
  const ExamsTable({super.key});

  @override
  State<ExamsTable> createState() => _ExamsTableState();
}

class _ExamsTableState extends State<ExamsTable> {
  List<Exam> exams = [];

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Text('Name'),
            ),
            TableCell(
              child: Text('Date'),
            ),
          ],
        ),
        for (var exam in exams)
          TableRow(
            children: [
              TableCell(
                child: Text(exam.name),
              ),
              TableCell(
                child: Text(exam.date),
              ),
            ],
          ),
      ],
    );
  }
}
