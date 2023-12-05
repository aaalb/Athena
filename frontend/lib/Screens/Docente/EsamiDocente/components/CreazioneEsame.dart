import 'package:flutter/material.dart';

class DynamicInputDialog extends StatefulWidget {
  @override
  _DynamicInputDialogState createState() => _DynamicInputDialogState();
}

class _DynamicInputDialogState extends State<DynamicInputDialog> {
  List<TextEditingController> controllers = [];
  TextEditingController idesameController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController creditiController = TextEditingController();
  TextEditingController annoController = TextEditingController();

  List<String> labels = ['Tipologia', 'Opzionale', 'Scadenza', 'Propedeutico'];
  int counter = 0;
  String selectedValue = 'Tipologia';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: idesameController,
                        decoration: InputDecoration(
                          labelText: 'ID Esame',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 40.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: TextFormField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 40.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: creditiController,
                        decoration: InputDecoration(
                          labelText: 'Crediti',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 40.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: TextFormField(
                        controller: annoController,
                        decoration: InputDecoration(
                          labelText: 'Anno',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 40.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                for (var i = 0; i < controllers.length; i += 4)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${idesameController.text}-${counter + 1}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: TextFormField(
                                controller: controllers[i],
                                decoration: InputDecoration(
                                  labelText: labels[i % labels.length],
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 40.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              hint: Text(selectedValue),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value ?? 'Tipologia';
                                });
                              },
                              items: <String>['Scritto', 'Orale', 'Progetto']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Checkbox(
                            value: i + 1 < controllers.length
                                ? controllers[i + 1].text.isNotEmpty
                                : false,
                            onChanged: (value) {
                              setState(() {
                                if (i + 1 < controllers.length) {
                                  controllers[i + 1].text =
                                      value ?? false ? 'Checked' : '';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (var i = 0; i < 2; i++) {
                        controllers.add(TextEditingController());
                      }
                      counter = controllers.length ~/ 4;
                    });
                  },
                  child: Text('Aggiungi una prova'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Do something with the input values
                    for (var controller in controllers) {
                      print(controller.text);
                      // Here you can process the text from each controller
                    }
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Conferma'),
                ),
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
      return DynamicInputDialog();
    },
  );
}
