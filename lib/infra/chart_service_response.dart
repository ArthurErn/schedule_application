import 'package:Equilibre/domain/chart.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class ChartServiceResponse {
  Future ping() async {
    List<ChartEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/bi/');
    response.forEach((item) => list.add(ChartEntity.fromJson(item)));
    return list;
  }
}