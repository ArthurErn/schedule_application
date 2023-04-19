import 'package:Equilibre/domain/address_entity.dart';
import 'package:Equilibre/domain/opening_hours.dart';
import 'package:Equilibre/domain/service.dart';
import 'package:Equilibre/domain/social_media_entity.dart';
import 'package:Equilibre/view/login_screen.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter/material.dart';
List<OpeningHours> listOpeningHours = [];
List<ServiceEntity> listService = [];
late SocialMediaEntity socialMedia;
late AddressEntity address;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barber Shop',
      home: LoginScreen(),
    );
  }
}
