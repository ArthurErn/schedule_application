import 'dart:convert';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:Equilibre/external/http_put.dart';
import 'package:Equilibre/view/login_screen.dart';
import 'package:http/http.dart';

class PostSchedule {
  Future ping(List<dynamic> scheduleInfos) async {
    print(scheduleInfos);
    HttpPost repo = HttpPost();
    Response response =
        await repo.connect('${Env.url}/api/v1/agendamento/',
            json: jsonEncode({
              "id_usuario": userCredentials.idUsuario,
              "id_usuario_servico": scheduleInfos[2],
              "data_hora": "${scheduleInfos[0]} ${scheduleInfos[1]}",
              "atendimento_status": 0
            }));
    print(response);
    return response;
  }

  Future cancel(String idAgendamento) async {
    HttpPut repo = HttpPut();
    Response response = await repo.connect(
        '${Env.url}/api/v1/agendamento/$idAgendamento');
    return response;
  }
}
