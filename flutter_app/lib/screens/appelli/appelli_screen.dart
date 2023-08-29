import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screens/appelli/components/examsTable.dart';

import 'components/header.dart';

class Appelli extends StatefulWidget {
  const Appelli({super.key});

  @override
  State<Appelli> createState() => _AppelliState();
}

class _AppelliState extends State<Appelli> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: ExamsTable(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
