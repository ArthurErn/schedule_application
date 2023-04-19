import 'dart:convert';

import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:http/http.dart';

class ScheduleDate {
  Future<List<dynamic>> ping(String data) async {
    HttpPost repo = HttpPost();
    Response response = await repo.connect(
        '${Env.url}/api/v1/agendamento/data_desejada/?data_desejada=$data');
    return jsonDecode(response.body);
  }
}