import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/Appelli2/appelli_screen.dart';
import 'package:frontend/utils/ApiManager.dart';

class AppelloTile extends StatelessWidget
{
  String idprova;
  String nome;
  String tipologia;
  String data;
  bool opzionale;
  String dipendenza;

  void Function()? onTap;

  AppelloTile({
    required this.nome,
    required this.idprova,
    required this.tipologia,
    required this.data,
    required this.opzionale,
    required this.dipendenza,
    this.onTap,
  });

  factory AppelloTile.fromJson(Map<String, dynamic> json) {
    return AppelloTile(
      nome: json['nome'] ?? '',
      idprova: json['idprova'] ?? '',
      tipologia: json['tipologia'] ?? '',
      data: json['data'] ?? '',
      opzionale: json['opzionale'] ?? false,
      dipendenza: json['dipendeda'] ?? 'Nessuna',
    );
  }
  @override
  Widget build(BuildContext context) {
    String opzionale_str = (opzionale) ? "Si" : "No";
    return Card(
        color: Color.fromARGB(255, 242, 239, 239),
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        //leading: showBack ? Icon(Icons.arrow_back_ios_new_sharp) : null,
        title: Text(nome),
        subtitle: Text(
          'ID Prova: $idprova - Tipologia: $tipologia - Opzionale: ${opzionale_str} - Dipendenza: $dipendenza',
        ),
        trailing: Text(data),
        onTap: onTap,
      ),
    );
  }
}

class ConfermaAppelloTile extends StatefulWidget
{
  String data;
  String idprova;

  ConfermaAppelloTile({required this.data, required this.idprova});

  factory ConfermaAppelloTile.fromJson(Map<String, dynamic> json) {
    return ConfermaAppelloTile(
      idprova: json['idprova'] ?? '',
      data: json['data'] ?? '',
    );
  }

  @override
  State<ConfermaAppelloTile> createState() => ConfermaAppelloTileState(data: data, idprova: idprova);
}

class ConfermaAppelloTileState extends State<ConfermaAppelloTile>
{
  String data;
  String idprova;

  Widget tileText = Text('Prenotati', textAlign: TextAlign.center,);

  AssetImage? okImage;

  @override
  void initState()
  {
    super.initState();
    okImage = AssetImage('images/ok.gif');
  }

  @override
  void dispose() {
    okImage!.evict();
    super.dispose();
  }

  ConfermaAppelloTileState({required this.data, required this.idprova});


  static GlobalKey<Appelli2ComponentState> appelliKey = GlobalKey<Appelli2ComponentState>();


  @override
  Widget build(BuildContext context) {
    return Card
    (
     shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color.fromARGB(255, 209, 67, 67),)
     ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: InkWell
      (
        splashColor: Color.fromARGB(197, 229, 79, 79),
        onTap: ()
        {
          _prenotaAppello(this.idprova, this.data).then((value)
          {
            setState(() {
              if(value)
              {
                tileText = Image(image: okImage!, fit: BoxFit.cover,);
                okImage!.evict();
                Future.delayed(Duration(milliseconds: 1000)).then((value)
                {
                  appelliKey.currentState?.refresh();
                });
              }
              else
              {
                tileText = Text("Errore");
              }
            });
          });
        },
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(child: tileText,)
        ),
      ),
    );
  }
}


Future<bool> _prenotaAppello(String idprova, String data) async {
  Map<String, dynamic> postData = {
    'idprova': idprova,
    'data': data,
  };

  try {
    var response = await ApiManager.postData('appelli/prenota', postData);
    
    if (response!.containsKey("Status") && response["Status"] == "Success") {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    // Gestisci eventuali errori di chiamata API
    print("Errore durante la chiamata API: $e");
    return false;
  }
}


