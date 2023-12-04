// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';

Future<bool> login(String email, String password) async {
  try {
    http.Response response = await http.post(
      Uri.parse('http://localhost:8000/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      //TO-DO: change sharedpreferences with something encrypted
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("access_token", data['access_token']);

      return true;
    }
  } catch (e) {}

  return false;
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginFailed = false;

  Color borderColor = Color.fromARGB(0, 214, 25, 25);
  String errorText = "";
  List<double> elevations = [2, 2];

  FocusNode FOCemail_in = FocusNode(debugLabel: "email");
  FocusNode FOCemail_out =
      FocusNode(debugLabel: "email focus", skipTraversal: true);
  FocusNode FOCpass_in = FocusNode(debugLabel: "pass");
  FocusNode FOCpass_out =
      FocusNode(debugLabel: "pass focus", skipTraversal: true);
  FocusNode FOCbutton_in = FocusNode(debugLabel: "bottone");
  FocusNode FOCbutton_out =
      FocusNode(debugLabel: "bottone", skipTraversal: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: <Widget>[
      Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/wallpaper.jpg"), fit: BoxFit.cover)),
      ),
      SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
                width: 390,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0.0, 3.0),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(55, 80, 55, 30),
                  child: Column(
                    children: [
                      Image.asset(
                        "images/cf-logo.png",
                        fit: BoxFit.fill,
                      ),

                      /*const Text
                      (
                        "Benvenuto",
                        style: TextStyle
                        (
                          fontFamily: "SourceSansPro",
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),*/

                      Padding(
                          padding: const EdgeInsets.only(top: 37),
                          child: Form(
                              child: Column(
                            children: [
                              Text(
                                errorText,
                                style: const TextStyle(color: Colors.red),
                              ),
                              Material(
                                  elevation: elevations[0],
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Focus(
                                      focusNode: FOCemail_out,
                                      child: TextField(
                                        focusNode: FOCemail_in,
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "Email",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          ),
                                        ),
                                      ),
                                      onFocusChange: (hasFocus) =>
                                          _onFocusChange(
                                              hasFocus: hasFocus,
                                              callerId: 0))),
                              Material(
                                  elevation: elevations[1],
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Focus(
                                    focusNode: FOCpass_out,
                                    child: TextField(
                                      controller: passwordController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          )),
                                      focusNode: FOCpass_in,
                                    ),
                                    onFocusChange: (hasFocus) => _onFocusChange(
                                        hasFocus: hasFocus, callerId: 1),
                                  )),
                              Focus(
                                focusNode: FOCbutton_out,
                                child: ElevatedButton(
                                    focusNode: FOCbutton_in,
                                    style: ButtonStyle(
                                      overlayColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Color.fromARGB(255, 53, 33, 10)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0))),
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(120, 50)),
                                    ),
                                    onPressed: () {
                                      login(
                                        emailController.text.toString(),
                                        passwordController.text.toString(),
                                      ).then((value) => (value)
                                          ? context.go('/libretto')
                                          : {
                                              setState(() {
                                                borderColor = Color.fromARGB(
                                                    255, 255, 0, 0);
                                                errorText =
                                                    "Email o password errati";
                                                loginFailed = true;

                                                passwordController.clear();
                                              })
                                            });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(),
                                      child: Text(
                                        "ENTRA",
                                        style: TextStyle(
                                          fontFamily: "SourceSansPro",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )),
                                onFocusChange: (hasFocus) => _onFocusChange(
                                    hasFocus: hasFocus, callerId: -1),
                              ),
                            ]
                                .map((widget) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: widget,
                                    ))
                                .toList(),
                          ))),
                    ],
                  ),
                ))),
      )
    ]));
  }

  void ResetFormState() {
    if (loginFailed) {
      setState(() {
        borderColor = Color.fromARGB(0, 255, 0, 0);
        errorText = "";
        loginFailed = false;
      });
    }
  }

  void Elevate({required int index}) {
    setState(() {
      for (int i = 0; i < elevations.length; i++) {
        elevations[i] = (i == index) ? 10 : 2;
      }
    });
  }

  void LowerAll() {
    Elevate(index: -1);
  }

  void _onFocusChange({required bool hasFocus, required int callerId}) {
    if (hasFocus) {
      ResetFormState();
      Elevate(index: callerId);
    }
  }

  void onPressed() {
    debugPrint("Debug: ${FocusManager.instance.primaryFocus?.debugLabel}");
  }
}
