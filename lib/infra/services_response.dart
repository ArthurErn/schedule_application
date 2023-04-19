import 'package:Equilibre/domain/service.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class ServicesResponse {
  Future ping() async {
    List<ServiceEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/servico/');
    response.forEach((item) => list.add(ServiceEntity.fromJson(item)));
    print(response);
    return list;
  }
}