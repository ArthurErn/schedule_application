import 'dart:convert';

import 'package:Equilibre/domain/opening_hours.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:http/http.dart';

class WorkDaysPost {
  Future ping(List<OpeningHours> listOpeningHours) async {
    HttpPost repo = HttpPost();
    Response response = await repo.connect(
        '${Env.url}/api/v1/horario_atendimento/', json: jsonEncode(listOpeningHours));
    return response;
  }
}