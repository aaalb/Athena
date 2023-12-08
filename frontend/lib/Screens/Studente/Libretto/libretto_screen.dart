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
  IconData backIcon = Icons.arrow_circle_left_outlined;
  IconData searchIcon = Icons.search;
  bool noDataVisible = false;
  double? searchHeight = 0;

  List<ExamTile> exams = []; // Using a single list for all exams
  List<ExamTile> allExams = [];
  List<double> visibleExams = [];
  List<double> visibleProve = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamTile>>(
      future: _fetchLibretto(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Placeholder while loading
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No data available')); // If no data is available
        } else {
          List<ExamTile> exams = snapshot.data!;
          return _buildUI(exams); // Build the UI using fetched data
        }
      },
    );
  }

  Future<List<ExamTile>> _fetchLibretto() async {
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

  Widget _buildUI(List<ExamTile> exams) {
    if (exams.isEmpty) noDataVisible = true;
    return NotificationListener<SearchRequestedNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.open == false) {
              exams = allExams;
              visibleExams.clear();
              visibleProve.clear();
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
                  debugPrint("DEBUG: $query");
                  exams = allExams.where((exam) {
                    return (exam.nome
                        .toLowerCase()
                        .contains(query.toLowerCase()));
                  }).toList();
                  debugPrint(exams.toString());
                  noDataVisible = exams.isEmpty;
                }
              });
              return false;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WindowTitle(title: "Libretto"),
                const Divider(
                  height: 20,
                ),
                TitleSearchBar(
                    key: WindowTitleState.searchBarKey, hint: "Cerca esame"),
                Visibility(
                  child: Text("No data"),
                  visible: noDataVisible,
                ),
                Expanded(
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
                                                .storico[nestedIndex]
                                                .idoneita,
                                          );
                                        })),
                              )
                            ],
                          );
                        }))),
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
