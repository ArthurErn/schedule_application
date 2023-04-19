import 'package:Equilibre/domain/address_entity.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class AddressResponse {
  Future ping() async {
    List<AddressEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/endereco/');
    response.forEach((item) => list.add(AddressEntity.fromJson(item)));
    return list;
  }
}