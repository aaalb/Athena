import 'package:flutter/material.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Screens/Studente/Prenotazioni/prenotazioni_main.dart';
import 'package:frontend/Screens/Studente/Prenotazioni/prenotazioni_screen.dart';
import 'package:frontend/utils/ApiManager.dart';

class PrenotazioneTile extends StatelessWidget {
  final String nome, idprova, tipologia, data, dipendenza, responsabile;

  void Function()? onTap;

  PrenotazioneTile(
      {required this.nome,
      required this.idprova,
      required this.tipologia,
      required this.data,
      required this.dipendenza,
      required this.responsabile,
      this.onTap});

  factory PrenotazioneTile.fromJson(Map<String, dynamic> json) {
    return PrenotazioneTile(
      nome: json['nome'],
      idprova: json['idprova'],
      tipologia: json['tipologia'],
      data: json['data'],
      dipendenza: json['dipendenza'] ?? "",
      responsabile: json['responsabile'],
    );
  }

  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 242, 239, 239),
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(nome),
        subtitle: Text(
          'ID Prova: $idprova - Tipologia: $tipologia',
        ),
        trailing: Text(data),
        onTap: onTap,
      ),
    );
  }
}

class CancellaPrenotazioneTile extends StatefulWidget {
  String data;
  String idprova;

  CancellaPrenotazioneTile({required this.data, required this.idprova});

  factory CancellaPrenotazioneTile.fromJson(Map<String, dynamic> json) {
    return CancellaPrenotazioneTile(
      idprova: json['idprova'] ?? '',
      data: json['data'] ?? '',
    );
  }

  @override
  State<CancellaPrenotazioneTile> createState() =>
      CancellaPrenotazioneTileState(data: data, idprova: idprova);
}

class CancellaPrenotazioneTileState extends State<CancellaPrenotazioneTile> {
  String data;
  String idprova;

  Widget tileText = Text(
    'Annulla Prenotazione',
    textAlign: TextAlign.center,
  );
  AssetImage? okImage;
  AssetImage? warningImage;

  int confirmState = 0;

  @override
  void initState() {
    super.initState();
    confirmState = 0;
    okImage = AssetImage('assets/images/ok.gif');
    warningImage = AssetImage('assets/images/warning.gif');
  }

  @override
  void dispose() {
    okImage!.evict();
    warningImage!.evict();
    super.dispose();
  }

  CancellaPrenotazioneTileState({required this.data, required this.idprova});

  static GlobalKey<PrenotazioniComponentState> prenotazioniKey =
      GlobalKey<PrenotazioniComponentState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Color.fromARGB(255, 209, 67, 67),
          )),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
      child: InkWell(
        splashColor: Color.fromARGB(197, 229, 79, 79),
        onTap: () {
          if (confirmState == 0) {
            setState(() {
              confirmState = 1;
              tileText = Image(
                image: warningImage!,
                fit: BoxFit.cover,
                color: Color.fromARGB(255, 209, 67, 67),
              );
              warningImage!.evict();
            });
            Future.delayed(Duration(milliseconds: 1750)).then((value) {
              setState(() {
                tileText = Text(
                  "Clicca per confermare",
                  textAlign: TextAlign.center,
                );
                confirmState = 2;
              });
            });
          } else if (confirmState == 2) {
            confirmState = 1;
            _deleteAppello(this.idprova, this.data).then((value) {
              setState(() {
                if (value) {
                  tileText = Image(
                    image: okImage!,
                    fit: BoxFit.cover,
                    color: Color.fromARGB(255, 209, 67, 67),
                  );
                  okImage!.evict();
                  Future.delayed(Duration(milliseconds: 1000)).then((value) {
                    prenotazioniKey.currentState?.refresh();
                  });
                } else {
                  tileText = Text("Errore");
                }
              });
            });
          }
        },
        child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: tileText,
            )),
      ),
    );
  }
}

Future<bool> _deleteAppello(String idProva, String data) async {
  Map<String, dynamic> postData = {
    'idprova': idProva,
    'data': data,
  };
  try {
    var response = await ApiManager.deleteData('appelli/sprenota', postData);
    return true;
    /*if (response!.containsKey("Status") && response["Status"] == "Success") {
      return true;
    } else {
      return false;
    }*/
  } catch (e) {
    // Gestisci eventuali errori di chiamata API
    print("Errore durante la chiamata API: $e");
    return false;
  }
}
