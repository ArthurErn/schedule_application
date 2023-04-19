import 'dart:convert';

import 'package:Equilibre/domain/address_entity.dart';
import 'package:Equilibre/env.dart';
import 'package:http/http.dart';

import '../external/http_post.dart';

class InformationsPost {
  Future<Response> ping(AddressEntity address, String enterpriseName) async {
    HttpPost repo = HttpPost();

    await repo.connect(
      '${Env.url}/api/v1/empresa/', json: jsonEncode({
        "nome": enterpriseName
      }));

    Response response2 = await repo.connect(
        '${Env.url}/api/v1/endereco/', json: jsonEncode({
          "cep": address.cep,
          "rua_avenida": address.ruaAvenida,
          "numero": address.numero,
          "complemento": address.complemento,
          "bairro": address.bairro,
          "cidade": address.cidade,
          "estado": address.estado,
          "pais": address.pais
        }));
    return response2;
  }
}