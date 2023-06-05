import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:Equilibre/colors.dart';
import 'package:Equilibre/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static final Marker marker = Marker(markerId: MarkerId('value'), position: LatLng(-15.620822, -56.087058));


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 57, 84),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 32,
                          color: Color.fromARGB(255, 247, 67, 54),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            "${address.ruaAvenida}, ${address.numero}\n${address.complemento}\n${address.cep} ${address.bairro}, ${address.cidade}\n${address.estado}, ${address.pais}",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: socialMedia.whatsapp != '',
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(socialMedia.whatsapp),
                              webOnlyWindowName: '_blank');
                        },
                        child: const Icon(FontAwesomeIcons.whatsapp,
                            size: 45, color: Colors.white),
                      ),
                    ),
                    Visibility(
                      visible: socialMedia.instagram != '',
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(socialMedia.instagram),
                              webOnlyWindowName: '_blank');
                        },
                        child: const Icon(FontAwesomeIcons.instagram,
                            size: 45, color: Colors.white),
                      ),
                    ),
                    Visibility(
                      visible: socialMedia.facebook != '',
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(socialMedia.facebook),
                              webOnlyWindowName: '_blank');
                        },
                        child: const Icon(FontAwesomeIcons.facebook,
                            size: 45, color: Colors.white),
                      ),
                    ),
                    Visibility(
                      visible: socialMedia.youtube != '',
                      child: GestureDetector(
                          onTap: () async {
                            await launchUrl(Uri.parse(socialMedia.youtube),
                                webOnlyWindowName: '_blank');
                          },
                          child: const Icon(FontAwesomeIcons.youtube,
                              size: 45, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: socialMedia.tiktok != '',
                      child: GestureDetector(
                          onTap: () async {
                            await launchUrl(Uri.parse(socialMedia.tiktok),
                                webOnlyWindowName: '_blank');
                          },
                          child: const Icon(FontAwesomeIcons.tiktok,
                              size: 45, color: Colors.white)),
                    ),
                    Visibility(
                      visible: socialMedia.twitter != '',
                      child: GestureDetector(
                          onTap: () async {
                            await launchUrl(Uri.parse(socialMedia.twitter),
                                webOnlyWindowName: '_blank');
                          },
                          child: const Icon(FontAwesomeIcons.twitter,
                              size: 45, color: Colors.white)),
                    ),
                    Visibility(
                      visible: socialMedia.linkedin != '',
                      child: GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(socialMedia.linkedin),
                              webOnlyWindowName: '_blank');
                        },
                        child: const Icon(FontAwesomeIcons.linkedin,
                            size: 45, color: Colors.white),
                      ),
                    ),
                    Visibility(
                      visible: socialMedia.outra != '',
                      child: GestureDetector(
                          onTap: () async {
                            await launchUrl(Uri.parse(socialMedia.outra),
                                webOnlyWindowName: '_blank');
                          },
                          child: const Icon(FontAwesomeIcons.chrome,
                              size: 45, color: Colors.white)),
                    ),
                  ],
                ),
      //           Container(
      //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      //             height: 350,
      //             width: 350,
      //             child: GoogleMap(
      //               markers: {marker},
      //               mapType: MapType.normal,
      //               initialCameraPosition: CameraPosition(
      // target: LatLng(-15.620822, -56.087058), zoom: 12),
      //               onMapCreated: (GoogleMapController controller) {
      //                 _controller.complete(controller);
      //               },
      //             ),
      //           )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
