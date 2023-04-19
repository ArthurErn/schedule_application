import 'dart:convert';
import 'dart:io';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:http/http.dart';

class LoginResponse {
  Future ping(String user, String senha) async {
    HttpPost repo = HttpPost();

    try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      }
    } on SocketException catch (_) {
      return null;
    }

    Response response = await repo.connect(
        '${Env.url}/api/v1/login/', json: jsonEncode({
          "email": user,
          "senha": senha
    }));
    return response;
  }
}