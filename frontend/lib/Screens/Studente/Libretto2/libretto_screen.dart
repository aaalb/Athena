import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/search.dart';
import 'package:frontend/Common/title.dart';
import 'package:frontend/Common/exam_tile.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/Screens/Studente/models/Esame.dart';
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

class Libretto2Component extends StatefulWidget
{
  const Libretto2Component({super.key});

  @override
  State<Libretto2Component> createState() => Libretto2ComponentState();
}

class Libretto2ComponentState extends State<Libretto2Component> {
  IconData backIcon = Icons.arrow_circle_left_outlined;
  IconData searchIcon = Icons.search;
  bool noDataVisible = false;
  double? searchHeight = 0;

  late List<ExamTile> allExams;
  late List<ExamTile> exams = allExams;
  Future<List<ExamTile>> _futureExams = _fetchLibretto();

  List<double> visibleExams = List.empty(growable: true);
  List<double> visibleProve = List.empty(growable: true);
  

  @override
  Widget build(BuildContext context)
  {
    if(exams.isEmpty) noDataVisible = true;
    return NotificationListener<SearchRequestedNotification>
    (
      onNotification: (notification) 
      {
        setState(() {
          if(notification.open == false)
          {
            exams = allExams;
            visibleExams.clear();
            visibleProve.clear();
          }
        });
        return false;
      },
      child: NotificationListener<SearchQueryNotification>
      (
        onNotification: (notification) 
        {
          setState(() {  
            if(notification.text != null)
            {
              visibleExams.clear();
              visibleProve.clear();

              String query = notification.text!;
              debugPrint("DEBUG: $query");
              exams = allExams.where((exam)
              {
                return (exam.attivita.toLowerCase().contains(query.toLowerCase()));
              }).toList();

              noDataVisible = exams.isEmpty;
            }
          });
          return false;
        },
        child: Column
        (
          mainAxisSize: MainAxisSize.min,
          children: 
          [
            WindowTitle(title: "Libretto"),
            
            const Divider(height: 20,),
            
            TitleSearchBar(key: WindowTitleState.searchBarKey, hint: "Cerca esame"),
            
            Visibility(child: Text("No data"), visible: noDataVisible,),
            
            Expanded
            (
              child:
              (
                ListView.builder
                (
                  shrinkWrap: false,
                  itemCount: exams.length,
                  itemBuilder: (context, index) 
                  {
                    visibleExams.add(1);
                    visibleProve.add(0);
                    return Column
                    (
                      children: 
                      [
                        Visibility
                        (
                          visible: visibleExams[index] == 1,
                          maintainAnimation: true,
                          maintainState: true,
                          child: AnimatedOpacity
                          (
                            opacity: visibleExams[index],
                            duration: Duration(milliseconds: 500),
                            child: ExamTile
                            (
                              attivita: exams[index].attivita,
                              idesame: exams[index].idesame,
                              voto: exams[index].voto,
                              crediti: exams[index].crediti,
                              anno: exams[index].anno,
                              storico: exams[index].storico,
                              onTap: () 
                              {
                                setState(() {
                                  for(int i = 0; i < visibleExams.length; i++)
                                  {
                                    if(i != index)
                                    {
                                      visibleExams[i] = visibleExams[i] == 1? 0 : 1;
                                    }
                                    else
                                    {
                                      visibleProve[i] = visibleProve[i] == 1? 0 : 1;
                                    }
                                  }
                                });
                              },
                            ), 
                          ),
                        ),

                        Visibility
                        (
                          visible: visibleProve[index] == 1,
                          maintainAnimation: true,
                          maintainState: true,
                          child: AnimatedOpacity
                          (
                            opacity: visibleProve[index],
                            duration: Duration(milliseconds: 500),
                            
                            child: ColumnBuilder
                            (
                              itemCount: exams[index].storico.length,
                              itemBuilder: (context, nestedIndex)
                              {
                                return ProvaTile
                                (
                                  nome: exams[index].storico[nestedIndex].nome,
                                  idprova: exams[index].storico[nestedIndex].idprova,
                                  data: exams[index].storico[nestedIndex].data,
                                  tipologia: exams[index].storico[nestedIndex].tipologia,
                                  voto: exams[index].storico[nestedIndex].voto,
                                );
                              }
                            )
                          ),
                        )
                      ],
                    );
                  }
                )
              )
            ),
          ],
        )
      )
    );
  }
}

var allExams = <ExamTile>
[
  ExamTile(idesame: "CT-0000", attivita: "Basi di dati", voto: 27, crediti: 12, anno: 2, storico: allProve),
  ExamTile(idesame: "CT-0000", attivita: "Calcolo 1", voto: 20, crediti: 6, anno: 1, storico: allProve),
  ExamTile(idesame: "CT-0000", attivita: "Algoritmi e strutture dati", voto: 19, crediti: 12, anno: 2, storico: allProve),
  ExamTile(idesame: "CT-0000", attivita: "Ricerca operativa", voto: 24, crediti: 6, anno: 3, storico: allProve),
  ExamTile(idesame: "CT-0000", attivita: "Calcolabilità e linguaggi formali", voto: 25, crediti: 6, anno: 3, storico: allProve),
];

var allProve = <Prova>
[
  Prova(idprova: "ABCDE", nome: "Basi mod 1", tipologia: "Scritto", data: "23/01/2022", voto: 27),
  Prova(idprova: "FGHIJ", nome: "Basi mod 2", tipologia: "Orale", data: "11/09/2022", voto: 20),
];

class Prova
{
  String nome;
  String idprova;
  String tipologia;
  String data;
  int voto;

  Prova
  (
    {
      required this.nome,
      required this.idprova,
      required this.tipologia, 
      required this.data,
      required this.voto,
    }
  );
}

class ColumnBuilder extends StatelessWidget {
	final IndexedWidgetBuilder itemBuilder;
	final MainAxisAlignment mainAxisAlignment;
	final MainAxisSize mainAxisSize;
	final CrossAxisAlignment crossAxisAlignment;
	final TextDirection textDirection;
	final VerticalDirection verticalDirection;
	final int itemCount;

	const ColumnBuilder({
		Key? key,
		required this.itemBuilder,
		required this.itemCount,
		this.mainAxisAlignment = MainAxisAlignment.start,
		this.mainAxisSize = MainAxisSize.max,
		this.crossAxisAlignment = CrossAxisAlignment.center,
		this.textDirection = TextDirection.ltr,
		this.verticalDirection = VerticalDirection.down,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return new Column(
			children: new List.generate(this.itemCount,
					(index) => this.itemBuilder(context, index)).toList(),
		);
	}
}