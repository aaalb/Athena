import 'package:flutter/material.dart';
import 'package:frontend/models/Prenotazione.dart';
import 'DataClass.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/ApiManager.dart';

class PrenotazioniScreen extends StatefulWidget {
  const PrenotazioniScreen({super.key});

  @override
  State<PrenotazioniScreen> createState() => _PrenotazioniScreenState();
}

class _PrenotazioniScreenState extends State<PrenotazioniScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prenotazione>>(
      future: fetchPrenotazioni(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Prenotazione>> snapshotPrenotazione) {
        if (snapshotPrenotazione.connectionState == ConnectionState.none) {
          return const Text('no data');
        } else if (snapshotPrenotazione.connectionState ==
            ConnectionState.done) {
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: DataClass(
              dataListPrenotazioni:
                  snapshotPrenotazione.data as List<Prenotazione>,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
