import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> sendLogin(String badgenumber, String password) async {
  Uri url = Uri.http('localhost:8000', '/auth/login');
  Map data = {
    "badgenumber": badgenumber,
    "password": password,
  };

  var body = json.encode(data);

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 200) return true;
  return false;
}
