import 'dart:convert';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:Equilibre/external/http_put.dart';
import 'package:Equilibre/view/login_screen.dart';
import 'package:http/http.dart';

class CreateServiceResponse {
  Future ping(String nome, String descricao, double valor, int tempoServico) async {
    HttpPost repo = HttpPost();

    Response res = await repo.connect(
        '${Env.url}/api/v1/servico/', json: jsonEncode(
          {
            "nome_servico": nome,
            "descricao": descricao
          }
    ));
    var decoder = jsonDecode(res.body);
    Response response = await repo.connect(
        '${Env.url}/api/v1/usuario_servico/', json: jsonEncode(
          {
            "id_usuario": userCredentials.idUsuario,
            "id_servico": decoder['id_servico'],
            "valor": valor,
            "tempo_servico": tempoServico
          }
    ));
    return response;
  }

  Future put(String nome, String descricao, double valor, int tempoServico, int idServico) async {
    HttpPut repo = HttpPut();
    Response res = await repo.connect(
        '${Env.url}/api/v1/servico/$idServico', json: jsonEncode(
          {
            "nome_servico": nome,
            "descricao": descricao
          }
    ));
    Response response = await repo.connect(
        '${Env.url}/api/v1/usuario_servico/$idServico', json: jsonEncode(
          {
            "valor": valor,
            "tempo_servico": tempoServico
          }
    ));
    print(response.statusCode);
    return response;
  }
}