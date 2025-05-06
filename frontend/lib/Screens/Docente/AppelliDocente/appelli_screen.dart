import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/search.dart';
import 'package:frontend/Common/title.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/Screens/Docente/models/AppelloTile.dart';
import 'package:go_router/go_router.dart';

Future<List<AppelloTile>> _fetchAppelli() async {
  var response = await ApiManager.fetchData('docente/appelli');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => AppelloTile.fromJson(e)).toList();
    }
  }
  return [];
}

class AppelliDocenteComponent extends StatefulWidget {
  const AppelliDocenteComponent({Key? key}) : super(key: key);

  @override
  State<AppelliDocenteComponent> createState() =>
      AppelliDocenteComponentState();
}

class AppelliDocenteComponentState extends State<AppelliDocenteComponent> {
  bool noDataVisible = false;
  List<AppelloTile> appelli = [];
  List<AppelloTile> allAppelli = [];

  List<double> visibleAppelli = [];

  late bool needsRefresh;

  Future? _future;

  @override
  void initState() {
    super.initState();

    needsRefresh = true;
    //_futureAppelli = _fetchAppelli();
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
            if (needsRefresh) // needsRefresh)
            {
              needsRefresh = false;
              allAppelli = snapshot.data!;
              appelli = allAppelli;
              visibleAppelli.clear();
              //visibleConferme.clear();
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
              //visibleProve.clear();
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
                  //visibleProve.clear();

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
                        "assets/images/nodatatext.png",
                        fit: BoxFit.cover,
                        color: Color.fromARGB(115, 1, 1, 1),
                      ),
                    )),
                Visibility(
                  visible: !noDataVisible,
                  child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: appelli.length,
                      itemBuilder: (context, index) {
                        visibleAppelli.add(1);
                        return Visibility(
                          visible: visibleAppelli[index] == 1,
                          child: AppelloTile(
                            nome: appelli[index].nome,
                            idprova: appelli[index].idprova,
                            tipologia: appelli[index].tipologia,
                            data: appelli[index].data,
                            opzionale: appelli[index].opzionale,
                            responsabile: appelli[index].responsabile,
                            dipendenza: appelli[index].dipendenza,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}
