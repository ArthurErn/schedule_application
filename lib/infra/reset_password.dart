import 'package:Equilibre/env.dart';
import 'package:Equilibre/external/http_post.dart';
import 'package:http/http.dart';

class ResetPassword {
  Future ping(String email) async {
    HttpPost repo = HttpPost();
    Response response = await repo.connect(
        '${Env.url}/api/v1/redefinir_senha/${email.trim()}');
    return response;
  }
}