import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/search.dart';
import 'package:frontend/Common/title.dart';
import 'package:frontend/Screens/Studente/models/exam_tile.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';

class LibrettoComponent extends StatefulWidget {
  const LibrettoComponent({Key? key}) : super(key: key);

  @override
  State<LibrettoComponent> createState() => LibrettoComponentState();
}

class LibrettoComponentState extends State<LibrettoComponent> {
  bool noDataVisible = false;
  List<ExamTile> exams = []; // Using a single list for all exams
  List<ExamTile> allExams = [];
  List<double> visibleExams = [];
  List<double> visibleProve = [];

  late bool needsRefresh;

  Future? _future;
  @override
  void initState()
  {
    super.initState();

    needsRefresh = true;
    //_future = _fetchLibretto();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("refresh: $needsRefresh");
   return FutureBuilder(
      future: needsRefresh ? _fetchLibretto() : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Placeholder while loading
        } else 
        {
          if (snapshot.hasError)
          {
            return Text('Error: ${snapshot.error}');
          } 
          else
          {
            if(needsRefresh)
            {
              needsRefresh = false;
              allExams = snapshot.data!;
              exams = allExams;
              visibleExams.clear();
              visibleProve.clear();
            }
          }
          return _buildUI(); // Build the UI using fetched data
        }
      },
    );
  }

  Future _fetchLibretto() async {
    var response = await ApiManager.fetchData('libretto');
    if (response != null) {
      var results = json.decode(response) as List?;
      print(results);
      if (results != null) {
        return results.map((e) => ExamTile.fromJson(e)).toList();
      }
    }
    return [];
  }

  Widget _buildUI() {
    debugPrint("exams empty: ${exams.isEmpty}");
    noDataVisible = exams.isEmpty;
    return NotificationListener<SearchRequestedNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.open == false) {
              debugPrint("allExams: ${allExams.length}");
              exams = allExams;
              visibleExams.clear();
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
                  visibleExams.clear();
                  visibleProve.clear();

                  String query = notification.text!;
                  debugPrint("\n\nQuery: $query");
                  exams = allExams.where((exam) {
                    return (exam.nome
                        .toLowerCase()
                        .contains(query.toLowerCase()));
                  }).toList();
                  //debugPrint("AllExams: ${allExams.length}\n");
                  debugPrint("DEBUG: exams lenght ${exams.length}");
                  noDataVisible = exams.isEmpty;
                }
              });
              return false;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: 
              [
                WindowTitle(title: "Libretto"),
                
                const Divider(
                  height: 20,
                ),
                
                TitleSearchBar(
                    key: WindowTitleState.searchBarKey, hint: "Cerca esame"),
                
                Visibility
                (
                  visible: noDataVisible,
                  child: Expanded
                  (
                    child: Image.asset("images/nodatatext.png", fit: BoxFit.cover, color: Color.fromARGB(115, 1, 1, 1),),
                  )                  
                ),

                Visibility(
                  visible: !noDataVisible,
                  child: Expanded(
                      child: (ListView.builder(
                          shrinkWrap: false,
                          itemCount: exams.length,
                          itemBuilder: (context, index) {
                            visibleExams.add(1);
                            visibleProve.add(0);
                            return Column(
                              children: [
                                Visibility(
                                  visible: visibleExams[index] == 1,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: AnimatedOpacity(
                                    opacity: visibleExams[index],
                                    duration: Duration(milliseconds: 500),
                                    child: ExamTile(
                                      nome: exams[index].nome,
                                      idesame: exams[index].idesame,
                                      voto: exams[index].voto,
                                      crediti: exams[index].crediti,
                                      anno: exams[index].anno,
                                      storico: exams[index].storico,
                                      data: exams[index].data,
                                      onTap: () {
                                        setState(() {
                                          for (int i = 0;
                                              i < visibleExams.length;
                                              i++) {
                                            if (i != index) {
                                              visibleExams[i] =
                                                  visibleExams[i] == 1 ? 0 : 1;
                                            } else {
                                              visibleProve[i] =
                                                  visibleProve[i] == 1 ? 0 : 1;
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: visibleProve[index] == 1,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: AnimatedOpacity(
                                      opacity: visibleProve[index],
                                      duration: Duration(milliseconds: 500),
                                      child: ColumnBuilder(
                                          itemCount: exams[index].storico.length,
                                          itemBuilder: (context, nestedIndex) {
                                            return ProvaTile(
                                              idprova: exams[index]
                                                  .storico[nestedIndex]
                                                  .idprova,
                                              tipologia: exams[index]
                                                  .storico[nestedIndex]
                                                  .tipologia,
                                              voto: exams[index]
                                                  .storico[nestedIndex]
                                                  .voto,
                                              data: exams[index]
                                                  .storico[nestedIndex]
                                                  .data,
                                              idoneita: exams[index]
                                                  .storico[nestedIndex].idoneita,
                                            );
                                          })),
                                )
                              ],
                            );
                          }))),
                ),
              ],
            )));
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
