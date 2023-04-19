import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRepository {
  Future connect(String url) async {
    try {
      Uri uri = Uri.parse(url);
      String basicAuth = 'Basic ${base64Encode(utf8.encode('jonas:dt%:P1FV*s!7E3X6GqjN'))}';
      http.Response response = await http
          .get(uri, headers: <String, String>{'authorization': basicAuth}).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}