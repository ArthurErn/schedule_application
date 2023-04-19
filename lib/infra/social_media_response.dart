import 'package:Equilibre/domain/social_media_entity.dart';
import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_repo.dart';

class SocialMediaResponse {
  Future ping() async {
    List<SocialMediaEntity> list = [];
    HttpRepository repo = HttpRepository();
    var response = await repo.connect(
        '${Env.url}/api/v1/rede_social/');
    response.forEach((item) => list.add(SocialMediaEntity.fromJson(item)));
    return list;
  }
}