import 'package:Equilibre/domain/opening_hours.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class OpeningHoursResponse {
  Future ping() async {
    List<OpeningHours> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/horario_atendimento/');
    response.forEach((item){list.add(OpeningHours.fromJson(item));
    });
    return list;
  }
}