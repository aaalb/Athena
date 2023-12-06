import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/Libretto/components/DataClass.dart';
import 'package:frontend/models/ApiManager.dart';
import 'dart:convert';
import 'package:frontend/constants.dart';
import 'package:frontend/models/Esame.dart';
import 'package:go_router/go_router.dart';

Future<List<Esame>> _fetchLibretto() async {
  var response = await ApiManager.fetchData('libretto');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => Esame.fromJson(e)).toList();
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
  List<ExamTile> exams = allExams;
  
  @override
  Widget build(BuildContext context)
  {
    if(exams.isEmpty) noDataVisible = true;
    return Column
    (
      mainAxisSize: MainAxisSize.min,
      children: 
      [
        Row
        (
          children: 
          [
            Align
            (
              alignment: Alignment.centerRight,
              child: InkWell
              (
                child: Icon
                (
                  backIcon, 
                  color: Color.fromARGB(255, 209, 67, 67),
                  size: 40,
                ),
                onTap: () {
                  context.go("/menu");
                },
                onHover: (hovered)
                {
                  setState(() {
                    backIcon = hovered ? Icons.arrow_circle_left_rounded : Icons.arrow_circle_left_outlined;
                  });
                },
              )
            ),
            const Expanded
            (
              child: Align
              (
                alignment: Alignment.center,
                child: Text("Libretto",style: TextStyle
                (
                  color: Color.fromARGB(255, 209, 67, 67),
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.w600,
                  fontSize: 44,
                ),),
              )
            ),
            Align
            (
              alignment: Alignment.centerLeft,
              child: InkWell
              (
                child: Icon
                (
                  searchIcon, 
                  color: Color.fromARGB(255, 209, 67, 67),
                  size: 40,
                ),
                onTap: () {
                  setState(() 
                  {
                    if(searchIcon == Icons.search)
                    {
                      searchIcon = Icons.search_off;
                      searchHeight = null;
                    }
                    else
                    {
                      searchIcon = Icons.search;
                      searchHeight = 0;
                      exams = allExams;
                    }
                    noDataVisible = allExams.isEmpty;
                  });
                },
              )
            ),
          ],
        ),

        const Divider(height: 20,),
        
        AnimatedSize
        (
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          child: Container
          (
            height: searchHeight,
            child: Column
            (
              children: 
              [
                TextField
                (
                  //controller: emailController,
                  decoration: InputDecoration
                  (
                    hintText: "Nome dell'esame",
                    focusedBorder: OutlineInputBorder
                    (
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 209, 67, 67), width: 3),
                    ),
                  ),

                  onChanged: (value)
                  {
                    setState(() {
                      exams = allExams.where((exam)
                      {
                        return (exam.attivita.toLowerCase().contains(value.toLowerCase()));
                      }).toList();

                      noDataVisible = allExams.isEmpty;
                    });
                  }
                ),
                Divider(height: 20,),
              ]
            )
          )
        ),
        
        Visibility(child: Text("No data"), visible: noDataVisible,),
        
        Expanded
        (
          //constraints: BoxConstraints(maxHeight: 250, minHeight: 10),
          //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: //SingleChildScrollView(child:
          (
            ListView.builder
            (
              shrinkWrap: false,
              itemCount: exams.length,
              itemBuilder: (context, index) 
              {
                return ExamTile
                (
                  attivita: exams[index].attivita,
                  idesame: exams[index].idesame,
                  voto: exams[index].voto,
                  crediti: exams[index].crediti,
                  anno: exams[index].anno
                );
              },
            )
          )
        ),
      ],
    ); 
    
    /*
    FutureBuilder<List<Esame>>
    (
      future: _fetchLibretto(),
      builder: (BuildContext context, AsyncSnapshot<List<Esame>> snapshot) 
      {
        if (snapshot.connectionState == ConnectionState.none ||
            !snapshot.hasData) 
        {
          return const Text('no data');
        } 
        else if (snapshot.connectionState == ConnectionState.done) 
        {
          return Container
          (
            padding: const EdgeInsets.all(defaultPadding),
            child: DataClass(dataList: snapshot.data as List<Esame>),
          );
        }
        else
        {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );*/
  }
}

var allExams = <ExamTile>
[
  ExamTile(idesame: "CT-0000", attivita: "Basi di dati", voto: 27, crediti: 12, anno: 2),
  ExamTile(idesame: "CT-0000", attivita: "Calcolo 1", voto: 20, crediti: 6, anno: 1),
  ExamTile(idesame: "CT-0000", attivita: "Algoritmi e strutture dati", voto: 19, crediti: 12, anno: 2),
  ExamTile(idesame: "CT-0000", attivita: "Ricerca operativa", voto: 24, crediti: 6, anno: 3),
  //ExamTile(idesame: "CT-0000", attivita: "Calcolabilità e linguaggi formali", voto: 25, crediti: 6, anno: 3),
];


class ExamTile extends StatelessWidget
{
  String attivita;
  String idesame;
  int voto;
  int crediti;
  int anno;

  ExamTile
  (
    {
      required this.attivita,
      required this.idesame,
      required this.voto, 
      required this.crediti, 
      required this.anno
    }
  );

  @override
  Widget build(BuildContext context)
  {

    return Card
    (
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile
      (
        title: Text(attivita),
        subtitle: Text
        (
          'ID Esame: ${idesame} - Anno: ${anno} - Crediti: ${crediti}',
        ),
        trailing: Text("$voto"),

        onTap: () 
        {
          //_dialogBuilder(context, data.proveList, data.idesame);
        },
      ),
    );
  }
}


class ExamRow extends StatelessWidget
{
  String attivita;
  int voto;
  int crediti;
  int anno;

  ExamRow
  (
    {
      required this.attivita, 
      required this.voto, 
      required this.crediti, 
      required this.anno
    }
  );

  @override
  Widget build(BuildContext context)
  {
    return Row
    (
      children: 
      [
        Expanded
        (
          child: Align
          (
            alignment: Alignment.center,
            child: Text(attivita),
          )
        ),
        VerticalDivider(width: 10,),
        Expanded
        (
          child: Align
          (
            alignment: Alignment.center,
            child: Text(voto.toString()),
          )
        ),
        VerticalDivider(width: 10,),
        Expanded
        (
          child: Align
          (
            alignment: Alignment.center,
            child: Text(crediti.toString()),
          )
        ),
        VerticalDivider(width: 10,),
        Expanded
        (
          child: Align
          (
            alignment: Alignment.center,
            child: Text(anno.toString()),
          )
        ),
      ],
    );
  }
}
