import 'package:flutter/material.dart';
import 'package:frontend/utils/ApiManager.dart';

class _DynamicInputDialog extends StatefulWidget {
  @override
  _DynamicInputDialogState createState() => _DynamicInputDialogState();
}

class _DynamicInputDialogState extends State<_DynamicInputDialog> {
  List<TextEditingController> controllers = [];
  TextEditingController idesameController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController creditiController = TextEditingController();
  TextEditingController annoController = TextEditingController();

  List<String> selectedValue = [];

  @override
  Widget build(BuildContext context) {
    int counter = 1;
    return Dialog(
      insetPadding: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "Crea un nuovo esame",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: idesameController,
                  decoration: const InputDecoration(
                    labelText: 'ID Esame',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: creditiController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Crediti',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: TextFormField(
                        controller: annoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Anno',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                for (var i = 0; i < controllers.length; i += 5)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${idesameController.text}-${counter++}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 16), // Aggiornato lo spazio tra elementi
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controllers[i],
                              decoration: const InputDecoration(
                                labelText: 'Tipologia',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 12), // Aggiornato lo spazio tra elementi
                          Expanded(
                            child: TextFormField(
                              controller: controllers[i + 1],
                              decoration: const InputDecoration(
                                labelText: 'Scadenza',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 12), // Aggiornato lo spazio tra elementi
                          Expanded(
                            child: TextFormField(
                              controller: controllers[i + 2],
                              decoration: const InputDecoration(
                                labelText: 'Dipendenza',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 12), // Aggiornato lo spazio tra elementi
                          Expanded(
                            child: TextFormField(
                              controller: controllers[i + 3],
                              decoration: const InputDecoration(
                                labelText: 'Responsabile',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 12), // Aggiornato lo spazio tra elementi
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: i + 4 < controllers.length
                                    ? controllers[i + 4].text.isNotEmpty
                                    : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (i + 4 < controllers.length) {
                                      controllers[i + 4].text =
                                          value ?? false ? 'Checked' : '';
                                    }
                                  });
                                },
                              ),
                              const SizedBox(
                                  width:
                                      8), // Aggiornato lo spazio tra elementi
                              const Text(
                                "Opzionale",
                                textAlign: TextAlign.start,
                                // Aggiornato lo stile, il colore o altre proprietà del testo qui
                              ),
                            ],
                          ),
                          const SizedBox(
                              width: 12), // Aggiornato lo spazio tra elementi
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () {
                              setState(() {
                                --counter;
                                for (var i = 0; i < 5; i++) {
                                  controllers.removeLast();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (idesameController.text != "") {
                          ++counter;
                          setState(() {
                            for (var i = 0; i < 5; i++) {
                              controllers.add(TextEditingController());
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        _creaEsame(
                            idesameController.text,
                            nomeController.text,
                            creditiController.text,
                            annoController.text,
                            controllers);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> creaEsame(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return _DynamicInputDialog();
    },
  );
}

Future<void> _creaEsame(String idEsame, String nome, String crediti,
    String anno, List<TextEditingController> controllers) async {
  List<Map<String, dynamic>> prove = [];

  for (int i = 0; i < controllers.length; i += 5) {
    prove.add({
      'tipologia': controllers[i].text,
      'datascadenza': controllers[i + 1].text,
      'dipendeda': controllers[i + 2].text,
      'responsabile':
          (controllers[i + 3].text.isEmpty) ? '' : controllers[i + 3].text,
      'opzionale': (controllers[i + 4].text == 'Checked') ? true : false
    });
  }

  Map<String, dynamic> postData = {
    'idesame': idEsame,
    'nome': nome,
    'crediti': crediti,
    'anno': anno,
    'prove': prove,
  };

  // Assuming you have an ApiManager class with a postData method
  await ApiManager.postData('esami/crea', postData);

  // Consider handling the response or errors after the API call
}
