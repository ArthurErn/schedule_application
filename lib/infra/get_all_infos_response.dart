import 'package:Equilibre/domain/all_informations_entity.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class AllInformationsResponse {
  Future<AllInformationsEntity> ping() async {
    List<AllInformationsEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/endereco/');
    
    var response2 = await repo.connect(
        '${Env.url}/api/v1/empresa/');
    print(response);
    if(response != null){
    response.forEach((item) => list.add(AllInformationsEntity.fromJsonAddress(item)));
    }
    if(response2 != null){
    response2.forEach((item) => list[0].nome = item['nome']);
    }
    return list[0];
  }
}