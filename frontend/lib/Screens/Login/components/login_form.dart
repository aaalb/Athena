import 'dart:js';

import 'package:flutter/material.dart';
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

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "La tua matricola",
              prefixIcon: Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: "La tua password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                login(emailController.text.toString(),
                        passwordController.text.toString())
                    .then((value) => (value) ? context.go('/libretto') : {});
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
