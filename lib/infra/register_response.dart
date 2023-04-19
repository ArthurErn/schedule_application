import 'dart:convert';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:http/http.dart';

class RegisterResponse {
  Future<Response> ping(String user, String senha, String phone, String email) async {
    HttpPost repo = HttpPost();
    Response response = await repo.connect(
        '${Env.url}/api/v1/usuario/', json: jsonEncode({
          "nome": user,
          "id_permissao": 1,
          "senha": senha,
          "telefone": phone,
          "email": email
    }));
    return response;
  }
}