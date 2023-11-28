import 'package:flutter/material.dart';
import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/login_screen_top_image.dart';
import 'components/login_form.dart';
import 'package:frontend/background.dart';


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

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: Stack
      (
        alignment: Alignment.center,
        children: <Widget>
        [
          Container
          (
            decoration: const BoxDecoration
            (
              image: DecorationImage
              (
                image: AssetImage("images/wallpaper.jpg"),
                fit: BoxFit.cover
              )
            ),
          ),

          Padding
          (
            padding: EdgeInsets.all(20),
            child : Container
            (
              //height: 500,
              width: 390,
              decoration: BoxDecoration
              (
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const
                [
                  BoxShadow
                  (
                    offset: Offset(0.0, 3.0),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Padding
              (
                padding: const EdgeInsets.fromLTRB(55, 80, 55, 30),
                child: Column
                (
                  children: 
                  [
                    const Text
                    (
                      "Benvenuto",
                      style: TextStyle
                      (
                        fontFamily: "SourceSansPro",
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    
                    Padding
                    (
                      padding: const EdgeInsets.only(top: 37),
                      child: Form
                      (
                        child: Column
                        (
                          children: 
                          [
                            Material
                            (
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10.0),
                              child: TextField
                              (
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration
                                (
                                  hintText: "Email",
                                ),
                              )
                            ),

                            Material
                            (
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10.0),
                              child: TextField
                              (
                                controller: passwordController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                decoration: const InputDecoration
                                (
                                  hintText: "Password",
                                ),
                              )
                            ),

                            ElevatedButton
                            (
                              style: ButtonStyle
                              (
                                overlayColor: const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 53, 33, 10)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
                                fixedSize: MaterialStateProperty.all<Size>(Size(120, 50)),
                              ),
                              onPressed: ()
                              {
                                login(emailController.text.toString(), passwordController.text.toString())
                                  .then((value) => (value) ? context.go('/libretto') : {});
                              },
                              child: const Padding
                              (
                                padding: EdgeInsets.symmetric(), 
                                child: Text
                                (
                                  "ENTRA",
                                  style: TextStyle
                                  (
                                    fontFamily: "SourceSansPro",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ),
                          ].map((widget) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: widget,
                          )).toList(),
                        )
                      )
                    ),
                    SvgPicture.asset('images/cf-logo.svg'),
                  ],
                ),

              ) 
            )
          )
        ]
      ) 
    );
    /*
    return const Background(
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: LoginScreenTopImage(),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 450,
                    child: LoginForm(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    */
  }
}
