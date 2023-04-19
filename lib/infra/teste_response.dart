import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class TesteResponse {
  Future ping(String user, String senha) async {
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/barbearia');
    return response;
  }
}