import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class HttpService {
  static var url = Uri.http('localhost:8000', 'login');

  static login(email, password, BuildContext context) async {
    var response = await http
        .post(url, body: {'badgeNumber': 'doodle', 'password': '234'});

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      if (json[0] == 'Authenticated') {
        context.go("/");
      }
    }
  }
}
