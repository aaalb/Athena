import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/Screens/Studente/models/ExamTile.dart';
import 'package:go_router/go_router.dart';

Future<List<ExamTile>> _fetchLibretto() async {
  var response = await ApiManager.fetchData('libretto');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => ExamTile.fromJson(e)).toList();
    }
  }
  return [];
}

class Libretto2Component extends StatefulWidget {
  const Libretto2Component({Key? key}) : super(key: key);

  @override
  State<Libretto2Component> createState() => Libretto2ComponentState();
}

class Libretto2ComponentState extends State<Libretto2Component> {
  IconData backIcon = Icons.arrow_circle_left_outlined;
  IconData searchIcon = Icons.search;
  bool noDataVisible = false;
  double? searchHeight = 0;
  late List<ExamTile> exams;
  late List<ExamTile> allExams;

  late Future<List<ExamTile>> _futureExams;

  @override
  void initState() {
    super.initState();
    _futureExams = _fetchLibretto();
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
                  "Libretto",
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
                    hintText: "Nome dell'esame",
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
          child: FutureBuilder<List<ExamTile>>(
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
                            return ExamTile(
                              nome: exams[index].nome,
                              idesame: exams[index].idesame,
                              voto: exams[index].voto,
                              crediti: exams[index].crediti,
                              anno: exams[index].anno,
                              data: exams[index].data,
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
