import 'dart:convert';

import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:http/http.dart';

class NewPassword {
  Future ping(String idUser, String senha) async {
    HttpPost repo = HttpPost();
    Response response = await repo.connect(
        '${Env.url}/api/v1/usuario/$idUser', json: jsonEncode({
          "senha": senha,
    }));
    return response;
  }
}