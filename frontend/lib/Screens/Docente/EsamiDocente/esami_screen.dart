import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Screens/Docente/EsamiDocente/creazione_esame.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/Screens/Docente/models/EsameTile.dart';
import 'package:go_router/go_router.dart';

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
  late List<EsameTile> appelli = [];
  late List<EsameTile> allAppelli = [];
  List<double> visibleAppelli = [];
  List<double> visibleProve = [];
  Future? _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchEsami();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Placeholder while loading
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildUI(); // If no data is available
        } else {
          if (allAppelli.isEmpty) {
            allAppelli = snapshot.data!;
            appelli = allAppelli;
          }
          return _buildUI(); // Build the UI using fetched data
        }
      },
    );
  }

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

  Widget _buildUI() {
    if (appelli.isEmpty) noDataVisible = true;
    return NotificationListener<SearchRequestedNotification>(
      onNotification: (notification) {
        setState(() {
          if (notification.open == false) {
            appelli = allAppelli;
            visibleAppelli.clear();
            visibleProve.clear();
          }
        });
        return false;
      },
      child: NotificationListener<SearchQueryNotification>(
          onNotification: (notification) {
            setState(() {
              if (notification.text != false) {
                visibleAppelli.clear();
                visibleProve.clear();

                String query = notification.text!;
                debugPrint("\n\nQuery: $query");
                appelli = allAppelli.where((appelli) {
                  return (appelli.idesame
                      .toLowerCase()
                      .contains(query.toLowerCase()));
                }).toList();
                noDataVisible = appelli.isEmpty;
              }
            });
            return false;
          },
          child: Column(
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
                            appelli = List.from(
                                allAppelli); // Ripristina tutti gli esami
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
                duration: Duration(milliseconds: 500),
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
                                  allAppelli); // Ripristina tutti gli esami se il campo di ricerca Ã¨ vuoto
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
                  child: (ListView.builder(
                      shrinkWrap: false,
                      itemCount: appelli.length,
                      itemBuilder: (context, index) {
                        visibleAppelli.add(1);
                        visibleProve.add(0);
                        return Column(
                          children: [
                            Visibility(
                                visible: visibleAppelli[index] == 1,
                                maintainAnimation: true,
                                maintainState: true,
                                child: AnimatedOpacity(
                                  opacity: visibleAppelli[index],
                                  duration: Duration(microseconds: 500),
                                  child: EsameTile(
                                      idesame: appelli[index].idesame,
                                      nome: appelli[index].nome,
                                      crediti: appelli[index].crediti,
                                      anno: appelli[index].anno,
                                      prove: appelli[index].prove,
                                      onTap: () {
                                        setState(() {
                                          for (int i = 0;
                                              i < visibleAppelli.length;
                                              i++) {
                                            if (i != index) {
                                              visibleAppelli[i] =
                                                  visibleAppelli[i] == 1
                                                      ? 0
                                                      : 1;
                                            } else {
                                              visibleProve[i] =
                                                  visibleProve[i] == 1 ? 0 : 1;
                                            }
                                          }
                                        });
                                      }),
                                )),
                            Visibility(
                                visible: visibleProve[index] == 1,
                                maintainAnimation: true,
                                maintainState: true,
                                child: AnimatedOpacity(
                                    opacity: visibleProve[index],
                                    duration: Duration(milliseconds: 500),
                                    child: ColumnBuilder(
                                      itemCount: appelli[index].prove.length,
                                      itemBuilder: (context, nestedIndex) {
                                        return ProvaTile(
                                            idProva: appelli[index]
                                                .prove[nestedIndex]
                                                .idProva,
                                            tipologia: appelli[index]
                                                .prove[nestedIndex]
                                                .tipologia,
                                            opzionale: appelli[index]
                                                .prove[nestedIndex]
                                                .opzionale,
                                            dataScadenza: appelli[index]
                                                .prove[nestedIndex]
                                                .dataScadenza,
                                            dipendenza: appelli[index]
                                                .prove[nestedIndex]
                                                .dipendenza);
                                      },
                                    )))
                          ],
                        );
                      }))),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    creaEsame(context);
                  },
                ),
              ),
            ],
          )),
    );
  }
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  const ColumnBuilder({
    required this.itemBuilder,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          List.generate(itemCount, (index) => itemBuilder(context, index)),
    );
  }
}
