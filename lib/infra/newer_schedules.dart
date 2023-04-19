import 'package:Equilibre/domain/client_schedules.dart';
import 'package:Equilibre/domain/schedule.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';
import 'package:Equilibre/view/login_screen.dart';

class NewerSchedules {
  Future ping() async {
    List<ScheduleEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/agendamento_futuros/${userCredentials.idUsuario}');
    if(response != null){
    response.forEach((item) => list.add(ScheduleEntity.fromJson(item)));
    }
    return list;
  }

  Future pingClients() async {
    List<ClientSchedulesEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/agendamento_meus_clientes/${userCredentials.idUsuario}');
    if(response != null){
    response.forEach((item) => list.add(ClientSchedulesEntity.fromJson(item)));
    }else{
      return response;
    }
    return list;
  }
}