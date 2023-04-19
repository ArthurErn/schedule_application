import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class HttpPost {
  Future connect(String url, {json}) async {
    var uri = Uri.parse(url);
    String basicAuth = 'Basic ${base64Encode(utf8.encode('jonas:dt%:P1FV*s!7E3X6GqjN'))}';
    
    try {
      var data = await http.post(
        uri,
        headers: <String, String>{'authorization': basicAuth, "Content-type": "application/json"},
        body: json,
      );
      print(json);
      return data;
    } catch (e) {
      return null;
    }
  }
}