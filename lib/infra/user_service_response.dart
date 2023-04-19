import 'package:Equilibre/domain/barber_service.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class UserServiceResponse {
  Future ping() async {
    List<UserServiceEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/usuario_servico/');
    print(response);
    response.forEach((item) => list.add(UserServiceEntity.fromJson(item)));
    return list;
  }
}