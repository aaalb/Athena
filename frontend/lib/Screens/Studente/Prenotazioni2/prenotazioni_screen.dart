import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/search.dart';
import 'package:frontend/Common/title.dart';
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
  State<PrenotazioniComponent> createState() => PrenotazioniComponentState();
}

class PrenotazioniComponentState extends State<PrenotazioniComponent> {
  bool noDataVisible = false;
  List<PrenotazioneTile> prenotazioni = []; // Using a single list for all exams
  List<PrenotazioneTile> allPrenotazioni = [];
  List<double> visiblePrenotazioni = [];
  List<double> visibleConferme = [];

  late bool needsRefresh;

  Future? _future;
  @override
  void initState() {
    super.initState();

    needsRefresh = true;
    //_future = _fetchPrenotazioni();
  }

  Widget build(BuildContext context) 
  {
    return FutureBuilder(
      future: needsRefresh ? _fetchPrenotazioni() : null,//_future,
      builder: (context, snapshot) 
      {
        if (snapshot.connectionState == ConnectionState.waiting) 
        {
          return const CircularProgressIndicator(); // Placeholder while loading
        } 
        else 
        {
          if (snapshot.hasError) 
          {
            return Text('Error: ${snapshot.error}');
          }
          else 
          {
            if (needsRefresh) 
            {
              needsRefresh = false;
              allPrenotazioni = snapshot.data!;
              prenotazioni = allPrenotazioni;
              visiblePrenotazioni.clear();
              visibleConferme.clear();
            }
            return _buildUI(); // Build the UI using fetched data
          }
        }
      },
    );
  }

  Widget _buildUI() 
  {
    noDataVisible = prenotazioni.isEmpty;
    return NotificationListener<SearchRequestedNotification>
    (
        onNotification: (notification) {
          debugPrint("DEBUG got notification");
          setState(() {
            if (notification.open == false) {
              prenotazioni = allPrenotazioni;
              visiblePrenotazioni.clear();
              visibleConferme.clear();
              needsRefresh = true;
            }
          });
          return false;
        },
        child: NotificationListener<SearchQueryNotification>
        (
          onNotification: (notification) 
          {
            setState(() {
              if (notification.text != null) {
                visiblePrenotazioni.clear();
                visibleConferme.clear();

                String query = notification.text!;
                debugPrint("\n\nQuery: $query");
                prenotazioni = allPrenotazioni.where((appello) {
                  return (appello.nome
                      .toLowerCase()
                      .contains(query.toLowerCase()));
                }).toList();
                //debugPrint("AllExams: ${allExams.length}\n");
                debugPrint("DEBUG: prenotazioni lenght ${prenotazioni.length}");
                noDataVisible = prenotazioni.isEmpty;
              }
            });
            return false;
          },
          child: Column
          (
            mainAxisSize: MainAxisSize.min,
            children: 
            [
              WindowTitle(title: "Prenotazioni"),
              
              const Divider(
                height: 20,
              ),
              
              TitleSearchBar(
                  key: WindowTitleState.searchBarKey, hint: "Cerca appello"),
              
              Visibility
              (
                visible: noDataVisible,
                child: Expanded
                (
                  child: Image.asset("images/nodatatext.png", fit: BoxFit.cover, color: Color.fromARGB(115, 1, 1, 1),),
                )                  
              ),
              
              Visibility
              (
                visible: !noDataVisible,
                child: Expanded
                (
                  child: ListView.builder
                  (
                    shrinkWrap: true,
                    itemCount: prenotazioni.length,
                    itemBuilder: (context, index) 
                    {
                      visiblePrenotazioni.add(1);
                      visibleConferme.add(0);
                      return Column(
                        children: 
                        [
                          Visibility
                          (
                            visible: visiblePrenotazioni[index] == 1,
                            maintainAnimation: true,
                            maintainState: true,
                            child: AnimatedOpacity
                            (
                              opacity: visiblePrenotazioni[index],
                              duration: Duration(milliseconds: 500),
                              child: PrenotazioneTile
                              (
                                nome: prenotazioni[index].nome,
                                idprova: prenotazioni[index].idprova,
                                tipologia: prenotazioni[index].tipologia,
                                dipendenza: prenotazioni[index].dipendenza,
                                data: prenotazioni[index].data,
                                responsabile: prenotazioni[index].responsabile,
                                onTap: () 
                                {
                                  setState(() {
                                    for (int i = 0; i < visiblePrenotazioni.length; i++) 
                                    {
                                      if (i != index) 
                                      {
                                        visiblePrenotazioni[i] = visiblePrenotazioni[i] == 1 ? 0 : 1;
                                      }
                                      else
                                      {
                                        visibleConferme[i] = visibleConferme[i] == 1 ? 0 : 1;
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                          ),

                          Visibility
                          (
                            visible: visibleConferme[index] == 1,
                            //maintainAnimation: true,
                            //maintainState: true,
                            child: AnimatedOpacity
                            (
                              opacity: visibleConferme[index],
                              duration: Duration(milliseconds: 500),
                              
                              child: CancellaPrenotazioneTile
                              (
                                idprova: prenotazioni[index].idprova,
                                data: prenotazioni[index].data,
                              )
                            )
                          )
                        ],
                      );
                    }
                  )
                )
              )
            ],
          )
      )
    );
  }


  void refresh()
  {
    setState(() 
    {
      prenotazioni = allPrenotazioni;
      visiblePrenotazioni.clear();
      visibleConferme.clear();
      needsRefresh = true;
    });
  }

}
