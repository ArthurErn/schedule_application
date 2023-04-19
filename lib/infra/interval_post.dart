import 'dart:convert';

import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:http/http.dart';

class IntervalPost{
  Future post(int intervaloAtendimento) async {
    HttpPost repo = HttpPost();
    Response response = await repo.connect(
        '${Env.url}/api/v1/configuracao/', json: jsonEncode(
          {
      "intervalo_atendimento": intervaloAtendimento
    } 
    ));
    return response;
  }
}

