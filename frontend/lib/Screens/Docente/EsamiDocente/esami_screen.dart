import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/Screens/Docente/models/EsameTile.dart';
import 'package:go_router/go_router.dart';

Future<List<EsameTile>> _fetchEsami() async {
  var response = await ApiManager.fetchData('esami');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => EsameTile.fromJson(e)).toList();
    }
  }
  return [];
}

class EsamiDocenteComponent extends StatefulWidget {
  const EsamiDocenteComponent({Key? key}) : super(key: key);

  @override
  State<EsamiDocenteComponent> createState() => Libretto2ComponentState();
}

class Libretto2ComponentState extends State<EsamiDocenteComponent> {
  IconData backIcon = Icons.arrow_circle_left_outlined;
  IconData searchIcon = Icons.search;
  bool noDataVisible = false;
  double? searchHeight = 0;
  late List<EsameTile> appelli;
  late List<EsameTile> allAppelli;

  late Future<List<EsameTile>> _futureAppelli;

  @override
  void initState() {
    super.initState();
    _futureAppelli = _fetchEsami();
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
                  context.go("/docente");
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
                  "I miei Esami",
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
                      appelli =
                          List.from(allAppelli); // Ripristina tutti gli esami
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
                        appelli = List.from(
                            allAppelli); // Ripristina tutti gli esami se il campo di ricerca è vuoto
                      } else {
                        appelli = allAppelli.where((exam) {
                          return exam.nome
                              .toLowerCase()
                              .contains(value.toLowerCase());
                        }).toList();
                      }
                      noDataVisible = appelli.isEmpty;
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
          child: FutureBuilder<List<EsameTile>>(
            future: _futureAppelli,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                    child: Text('Errore durante il caricamento dei dati'));
              } else {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  allAppelli = snapshot
                      .data!; // Salva tutti gli esami ottenuti dalla chiamata API
                  appelli = List.from(
                      allAppelli); // Inizializza la lista exams con tutti gli esami
                  return appelli.isEmpty
                      ? const Center(child: Text('Nessun dato disponibile'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: appelli.length,
                          itemBuilder: (context, index) {
                            return EsameTile(
                              nome: appelli[index].nome,
                              idesame: appelli[index].idesame,
                              crediti: appelli[index].crediti,
                              anno: appelli[index].anno,
                              prove: appelli[index].prove,
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
