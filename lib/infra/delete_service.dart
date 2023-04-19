import 'package:Equilibre/env.dart';
import 'package:http/http.dart';

import '../external/http_delete.dart';

class DeleteService{
  Future delete(int idServico) async {
    HttpDelete repo = HttpDelete();
    Response response = await repo.connect(
        '${Env.url}/api/v1/servico/$idServico');
    return response;
  }
}