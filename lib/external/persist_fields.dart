import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? lembrarPersist;
//SALVA OS ULTIMOS CAMPOS DE CONEXAO DA API
Future salvarLogin(TextEditingController user, TextEditingController password) async {
  String usuario = user.text;
  String senha = password.text;
  final pref = await SharedPreferences.getInstance();
  pref.setString('usuario', usuario);
  pref.setString('senha', senha);
}

Future salvarCheckbox(bool lembrar) async {
  lembrarPersist = lembrar;
  final pref = await SharedPreferences.getInstance();
  pref.setBool('lembrar', lembrarPersist!);
}