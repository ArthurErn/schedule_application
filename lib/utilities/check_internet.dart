import 'dart:io';

class CheckInternet{
  Future check()async{
    try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return '';
      }
    } on SocketException catch (_) {
      return null;
    }
  }
}