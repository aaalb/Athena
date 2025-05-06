import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/search.dart';
import 'package:frontend/Common/title.dart';
import 'package:frontend/Screens/Docente/EsamiDocente/creazione_esame.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/Screens/Docente/models/EsameTile.dart';
import 'package:go_router/go_router.dart';

class EsamiDocenteComponent extends StatefulWidget {
  const EsamiDocenteComponent({Key? key}) : super(key: key);

  @override
  State<EsamiDocenteComponent> createState() => EsamiDocenteComponentState();
}

class EsamiDocenteComponentState extends State<EsamiDocenteComponent> {
  bool noDataVisible = false;
  List<EsameTile> appelli = [];
  List<EsameTile> allAppelli = [];
  List<double> visibleAppelli = [];
  List<double> visibleProve = [];

  late bool needsRefresh;

  Future? _future;
  @override
  void initState() {
    super.initState();

    needsRefresh = true;
    //_future = _fetchEsami();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: needsRefresh ? _fetchEsami() : _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Placeholder while loading
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (needsRefresh) // needsRefresh)
            {
              needsRefresh = false;
              allAppelli = snapshot.data!;
              appelli = allAppelli;
              visibleAppelli.clear();
              visibleProve.clear();
            }
            return _buildUI(); // Build the UI using fetched data
          }
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
    noDataVisible = appelli.isEmpty;
    return NotificationListener<SearchRequestedNotification>(
      onNotification: (notification) {
        setState(() {
          if (notification.open == false) {
            appelli = allAppelli;
            visibleAppelli.clear();
            visibleProve.clear();
            needsRefresh = true;
          }
        });
        return false;
      },
      child: NotificationListener<SearchQueryNotification>(
          onNotification: (notification) {
            setState(() {
              if (notification.text != null) {
                visibleAppelli.clear();
                visibleProve.clear();

                String query = notification.text!;
                debugPrint("\n\nQuery: $query");
                appelli = allAppelli.where((appelli) {
                  return (appelli.nome
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
              WindowTitle(title: "I miei Esami"),
              const Divider(
                height: 20,
              ),
              TitleSearchBar(
                  key: WindowTitleState.searchBarKey, hint: "Cerca appello"),
              Visibility(
                  visible: noDataVisible,
                  child: Expanded(
                    child: Image.asset(
                      "assets/images/nodatatext.png",
                      fit: BoxFit.cover,
                      color: Color.fromARGB(115, 1, 1, 1),
                    ),
                  )),
              Visibility(
                visible: !noDataVisible,
                child: Expanded(
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
                                                    visibleProve[i] == 1
                                                        ? 0
                                                        : 1;
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
              ),
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
