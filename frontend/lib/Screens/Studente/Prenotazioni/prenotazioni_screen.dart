import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/Screens/Studente/models/PrenotazioneTile.dart';
import 'package:go_router/go_router.dart';

Future<List<PrenotazioneTile>> _fetchPrenotazioni() async {
  var response = await ApiManager.fetchData('appelli/prenotazioni');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => PrenotazioneTile.fromJson(e)).toList();
    }
  }
  return [];
}

class PrenotazioniComponent extends StatefulWidget {
  const PrenotazioniComponent({Key? key}) : super(key: key);

  @override
  State<PrenotazioniComponent> createState() => Libretto2ComponentState();
}

class Libretto2ComponentState extends State<PrenotazioniComponent> {
  IconData backIcon = Icons.arrow_circle_left_outlined;
  IconData searchIcon = Icons.search;
  bool noDataVisible = false;
  double? searchHeight = 0;
  late List<PrenotazioneTile> exams;
  late List<PrenotazioneTile> allExams;

  late Future<List<PrenotazioneTile>> _futureExams;

  @override
  void initState() {
    super.initState();
    _futureExams = _fetchPrenotazioni();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                child: Icon(
                  backIcon,
                  color: Color.fromARGB(255, 209, 67, 67),
                  size: 40,
                ),
                onTap: () {
                  context.go("/studente");
                },
                onHover: (hovered) {
                  setState(() {
                    backIcon = hovered
                        ? Icons.arrow_circle_left_rounded
                        : Icons.arrow_circle_left_outlined;
                  });
                },
              ),
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Prenotazioni",
                  style: TextStyle(
                    color: Color.fromARGB(255, 209, 67, 67),
                    fontFamily: 'SourceSansPro',
                    fontWeight: FontWeight.w600,
                    fontSize: 44,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Icon(
                  searchIcon,
                  color: Color.fromARGB(255, 209, 67, 67),
                  size: 40,
                ),
                onTap: () {
                  setState(() {
                    if (searchIcon == Icons.search) {
                      searchIcon = Icons.search_off;
                      searchHeight = null;
                      exams = List.from(allExams); // Ripristina tutti gli esami
                    } else {
                      searchIcon = Icons.search;
                      searchHeight = 0;
                    }
                    noDataVisible = false; // Resetta il flag "No data"
                  });
                },
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          child: Container(
            height: searchHeight,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Nome della prova",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 209, 67, 67),
                        width: 3,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        exams = List.from(
                            allExams); // Ripristina tutti gli esami se il campo di ricerca è vuoto
                      } else {
                        exams = allExams.where((exam) {
                          return exam.nome
                              .toLowerCase()
                              .contains(value.toLowerCase());
                        }).toList();
                      }
                      noDataVisible = exams.isEmpty;
                    });
                  },
                ),
                const Divider(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<PrenotazioneTile>>(
            future: _futureExams,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Errore durante il caricamento dei dati'));
              } else {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  allExams = snapshot
                      .data!; // Salva tutti gli esami ottenuti dalla chiamata API
                  exams = List.from(
                      allExams); // Inizializza la lista exams con tutti gli esami
                  return exams.isEmpty
                      ? const Center(child: Text('Nessun dato disponibile'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: exams.length,
                          itemBuilder: (context, index) {
                            return PrenotazioneTile(
                              nome: exams[index].nome,
                              idprova: exams[index].idprova,
                              tipologia: exams[index].tipologia,
                              data: exams[index].data,
                              responsabile: exams[index].responsabile,
                              dipendenza: exams[index].data,
                            );
                          },
                        );
                } else {
                  return const Center(child: Text('Nessun dato disponibile'));
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
