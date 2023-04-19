import 'package:Equilibre/domain/configuration_entity.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class ConfigurationResponse {
  Future ping() async {
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/configuracao/');
    return response;
  }
}