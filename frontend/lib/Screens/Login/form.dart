import 'package:flutter/material.dart';
import 'package:frontend/user-data.dart';
import 'package:frontend/utils/AppService.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'package:frontend/utils/AuthService.dart';
import 'dart:convert';

class LoginFormComponent extends StatefulWidget {
  const LoginFormComponent({super.key});

  @override
  State<LoginFormComponent> createState() => _LoginFormComponentState();
}

class _LoginFormComponentState extends State<LoginFormComponent> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String errorText = "";
  List<double> elevations = [2, 2];
  Color borderColor = const Color.fromARGB(0, 214, 25, 25);
  bool loginFailed = false;
  bool hidePassword = true;

  bool visible = true;

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
    return Form(
        child: AutofillGroup(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Image.asset(
          "assets/images/cf-logo.png",
          fit: BoxFit.fill,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          errorText,
          style: const TextStyle(color: Colors.red),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Material(
            elevation: elevations[0],
            borderRadius: BorderRadius.circular(10.0),
            child: Focus(
                focusNode: FOCemail_out,
                child: TextField(
                  focusNode: FOCemail_in,
                  autofillHints: [AutofillHints.email, AutofillHints.username],
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Email",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) =>
                    _onFocusChange(hasFocus: hasFocus, callerId: 0))),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Material(
            elevation: elevations[1],
            borderRadius: BorderRadius.circular(10.0),
            child: Focus(
              focusNode: FOCpass_out,
              child: TextField(
                autofillHints: [AutofillHints.password],
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                obscureText: hidePassword,
                decoration: InputDecoration(
                    hintText: "Password",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    )),
                onSubmitted: (value) => tryLogin(context),
                focusNode: FOCpass_in,
              ),
              onFocusChange: (hasFocus) =>
                  _onFocusChange(hasFocus: hasFocus, callerId: 1),
            )),
      ),
      Focus(
        focusNode: FOCbutton_out,
        child: ElevatedButton(
            focusNode: FOCbutton_in,
            style: ButtonStyle(
              overlayColor: const MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 53, 33, 10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              fixedSize: MaterialStateProperty.all<Size>(const Size(120, 50)),
            ),
            onPressed: () => tryLogin(context),
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
        onFocusChange: (hasFocus) =>
            _onFocusChange(hasFocus: hasFocus, callerId: -1),
      ),
    ] /*.map((widget) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: widget,
          )).toList(),*/
                )));
  }

  void _onFocusChange({required bool hasFocus, required int callerId}) {
    if (hasFocus) {
      ResetFormState();
      Elevate(index: callerId);
    }
  }

  void ResetFormState() {
    if (loginFailed) {
      setState(() {
        borderColor = const Color.fromARGB(0, 255, 0, 0);
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

  void tryLogin(BuildContext context) {
    AuthService.login(
      emailController.text.toString(),
      passwordController.text.toString(),
    ).then((value) {
      if (value) {
        _fetchUser().then((user) {
          if (user != null) {
            AppService.instance.setUserData(user);

            if (user.role == 'Docente') {
              context.go('/docente');
            } else if (user.role == 'Studente') {
              context.go('/studente');
            }
          } else {
            // Gestire il caso in cui non si ottiene un utente
          }
        });
      } else {
        setState(() {
          borderColor = Color.fromARGB(255, 255, 0, 0);
          errorText = "Email o password errati";
          loginFailed = true;

          passwordController.clear();
        });
      }
    });
  }

  Future<UserData?> _fetchUser() async {
    try {
      final response = await ApiManager.fetchData('utente/data');
      if (response != null) {
        final List<dynamic> results = json.decode(response);
        if (results.isNotEmpty) {
          return UserData.fromJson(results.first);
        }
      }
    } catch (e) {
      print('Errore durante il recupero dei dati dell\'utente: $e');
    }
    return null;
  }
}
