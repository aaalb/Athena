import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/search.dart';
import 'package:frontend/Common/title.dart';
import 'package:frontend/Screens/Studente/models/appello_tile.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';

Future _fetchAppelli() async {
  var response = await ApiManager.fetchData('appelli');
  if (response != null) {
    var results = json.decode(response) as List?;
    print(results);
    if (results != null) {
      return results.map((e) => AppelloTile.fromJson(e)).toList();
    }
  }
  return [];
}

class Appelli2Component extends StatefulWidget {
  const Appelli2Component({Key? key}) : super(key: key);

  @override
  State<Appelli2Component> createState() => Appelli2ComponentState();
}

class Appelli2ComponentState extends State<Appelli2Component> {
  bool noDataVisible = false;
  List<AppelloTile> appelli = []; // Using a single list for all exams
  List<AppelloTile> allAppelli = [];
  List<double> visibleAppelli = [];
  List<double> visibleConferme = [];

  late bool needsRefresh;

  Future? _future;

  @override
  void initState() {
    super.initState();
    needsRefresh = true;
    //_future = _fetchAppelli();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: needsRefresh ? _fetchAppelli() : _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Placeholder while loading
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (needsRefresh) {
              needsRefresh = false;
              allAppelli = snapshot.data!;
              appelli = allAppelli;
              visibleAppelli.clear();
              visibleConferme.clear();
            }
            return _buildUI(); // Build the UI using fetched data
          }
        }
      },
    );
  }

  Widget _buildUI() {
    noDataVisible = appelli.isEmpty;
    return NotificationListener<SearchRequestedNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.open == false) {
              appelli = allAppelli;
              visibleAppelli.clear();
              visibleConferme.clear();
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
                  visibleConferme.clear();

                  String query = notification.text!;
                  debugPrint("\n\nQuery: $query");
                  appelli = allAppelli.where((appello) {
                    return (appello.nome
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
                WindowTitle(title: "Appelli"),
                const Divider(
                  height: 20,
                ),
                TitleSearchBar(
                    key: WindowTitleState.searchBarKey, hint: "Cerca appello"),
                Visibility(
                    visible: noDataVisible,
                    child: Expanded(
                      child: Image.asset(
                        "images/nodatatext.png",
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
                            visibleConferme.add(0);
                            return Column(
                              children: [
                                Visibility(
                                  visible: visibleAppelli[index] == 1,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: AnimatedOpacity(
                                    opacity: visibleAppelli[index],
                                    duration: Duration(milliseconds: 500),
                                    child: AppelloTile(
                                      nome: appelli[index].nome,
                                      idprova: appelli[index].idprova,
                                      tipologia: appelli[index].tipologia,
                                      dipendenza: appelli[index].dipendenza,
                                      opzionale: appelli[index].opzionale,
                                      data: appelli[index].data,
                                      onTap: () {
                                        setState(() {
                                          needsRefresh = false;
                                          for (int i = 0;
                                              i < visibleAppelli.length;
                                              i++) {
                                            if (i != index) {
                                              visibleAppelli[i] =
                                                  visibleAppelli[i] == 1
                                                      ? 0
                                                      : 1;
                                            } else {
                                              visibleConferme[i] =
                                                  visibleConferme[i] == 1
                                                      ? 0
                                                      : 1;
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: visibleConferme[index] == 1,
                                    //maintainAnimation: true,
                                    //maintainState: true,
                                    child: AnimatedOpacity(
                                        opacity: visibleConferme[index],
                                        duration: Duration(milliseconds: 500),
                                        child: ConfermaAppelloTile(
                                          idprova: appelli[index].idprova,
                                          data: appelli[index].data,
                                        )))
                              ],
                            );
                          }))),
                )
              ],
            )));
  }

  void refresh() {
    setState(() {
      appelli = allAppelli;
      visibleAppelli.clear();
      visibleConferme.clear();
      needsRefresh = true;
    });
  }
}
