import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'prenotazioni_screen.dart';
import 'package:frontend/Common/page_dimensions.dart';

class Prenotazioni extends StatefulWidget {
  const Prenotazioni({super.key});

  static PageDimensions dimensions = const PageDimensions(
      //width: 800,
      constraints: BoxConstraints(
    minWidth: 390,
    maxWidth: 600,
    minHeight: 200,
    maxHeight: 400,
  ));

  @override
  State<Prenotazioni> createState() => _Libretto2State();
}

class _Libretto2State extends State<Prenotazioni> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      LoadNewPageNotification(
        width: Prenotazioni.dimensions.width,
        height: Prenotazioni.dimensions.height,
        constraints: Prenotazioni.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: PrenotazioniComponent()),
    );
  }
}
