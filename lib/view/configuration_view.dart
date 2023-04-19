import 'dart:ui';
import 'package:Equilibre/colors.dart';
import 'package:Equilibre/domain/address_entity.dart';
import 'package:Equilibre/domain/opening_hours.dart';
import 'package:Equilibre/infra/configuration_response.dart';
import 'package:Equilibre/infra/informations_post.dart';
import 'package:Equilibre/infra/interval_post.dart';
import 'package:Equilibre/infra/opening_hours_response.dart';
import 'package:Equilibre/infra/post_work_days.dart';
import 'package:Equilibre/main.dart';
import 'package:Equilibre/utilities/move_to.dart';
import 'package:Equilibre/view/configure_work_days.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'charts_view.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  bool isLoading = false;
  final cepMask = MaskTextInputFormatter(mask: '#####-###');

  final empresaController = TextEditingController();
  final ruaAvenidaController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final paisController = TextEditingController();
  final cepController = TextEditingController();
  final intervaloController = TextEditingController();

  List<bool> pages = [
    false,
    false,
    false,
  ];

  @override
  void initState() {
    getInterval();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            pages.any((element) => element == true)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Text('Configurações',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                pages[1] = false;
                                pages[2] = false;
                                pages[0] = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        AppColors.primaryColor.withOpacity(.8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.schedule,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Horários de funcionamento',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                pages[0] = false;
                                pages[2] = false;
                                pages[1] == true
                                    ? (pages[1] = false)
                                    : (pages[1] = true);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        AppColors.primaryColor.withOpacity(.8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.auto_graph_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Gráficos gerenciais',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                pages[0] = false;
                                pages[1] = false;
                                showInformationsEdition();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        AppColors.primaryColor.withOpacity(.8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.home,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Dados cadastrais',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                pages[0] = false;
                                pages[1] = false;
                                showHourIntervalEdition();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        AppColors.primaryColor.withOpacity(.8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.home,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Intervalo de Horário',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            Visibility(visible: (pages[1] == true), child: const ChartsView()),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Visibility(
                    visible: (pages[0] == true),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height - 250,
                        child: const ConfigureWorkDays())),
                Visibility(
                  visible: pages[0] == true,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, bottom: 25),
                    child: FloatingActionButton(
                      onPressed: (() async {
                        setState(() {
                          isLoading = true;
                        });
                        await WorkDaysPost()
                            .ping(listOpeningHours)
                            .then((value) {
                          setState(() {
                            if (value.statusCode == 202) {
                              toastModal("Sucesso", "Horário salvo com sucesso",
                                  1200, Colors.green, Icons.check);
                            } else {
                              toastModal("Erro", "Horário inválido", 1500,
                                  Colors.red, Icons.error);
                            }
                            isLoading = false;
                          });
                        });
                      }),
                      child: isLoading == false
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool isLoadingInfos = false;
  Future showInformationsEdition() async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Editar dados cadastrais",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 480,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        controller: empresaController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          labelText: "Nome da empresa",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                width: 2, color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                      ),
                      TextField(
                        controller: cepController,
                        inputFormatters: [cepMask],
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          labelText: "CEP",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                width: 2, color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: ruaAvenidaController,
                              decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: "Rua/Avenida",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: numeroController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: "Número",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: complementoController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          labelText: "Complemento",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                width: 2, color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: bairroController,
                              decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: "Bairro",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: cidadeController,
                              decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: "Cidade",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: estadoController,
                              decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: "Estado",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: paisController,
                              decoration: InputDecoration(
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                labelText: "País",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() => isLoadingInfos = true);

                          AddressEntity address = AddressEntity(
                              cep: cepController.text.isEmpty
                                  ? 0
                                  : int.parse(
                                      cepController.text.replaceAll('-', '')),
                              ruaAvenida: ruaAvenidaController.text,
                              numero: numeroController.text.isEmpty
                                  ? 0
                                  : int.parse(numeroController.text),
                              complemento: complementoController.text,
                              bairro: bairroController.text,
                              cidade: cidadeController.text,
                              estado: estadoController.text,
                              pais: paisController.text);
                          if (address.bairro.isNotEmpty &&
                              address.cep != 0 &&
                              address.cidade.isNotEmpty &&
                              address.complemento.isNotEmpty &&
                              address.estado.isNotEmpty &&
                              address.numero != 0 &&
                              address.pais.isNotEmpty &&
                              address.ruaAvenida.isNotEmpty) {
                            await InformationsPost()
                                .ping(address, empresaController.text)
                                .then((value) {
                              if (value.statusCode == 201) {
                                toastModal("Sucesso", "Dados atualizados!",
                                    1200, Colors.blue, Icons.check);
                                Navigator.pop(context);
                              } else {
                                toastModal(
                                    "Erro",
                                    "Problema na atualização de dados",
                                    1200,
                                    Colors.red,
                                    Icons.error);
                              }
                              setState(() => isLoadingInfos = false);
                            });
                          } else {
                            toastModal("Erro", "Preencha todos os campos!",
                                1200, Colors.red, Icons.error);
                            setState(() => isLoadingInfos = false);
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 135,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: isLoadingInfos == true
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Salvar",
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
      },
    );
  }

  getInterval() async {
    await ConfigurationResponse().ping().then((value){
      if(value.isNotEmpty){
        setState(() {
          intervaloController.text = value['intervalo_atendimento'].toString();
        });
      }
    });
  }

  Future showHourIntervalEdition() async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Editar intervalo de horários",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                height: 160,
                width: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: intervaloController,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black),
                        labelText: "Intervalo",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                              width: 2, color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(width: 2, color: Colors.grey),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (intervaloController.text.isEmpty) {
                          toastModal("Erro", "Preencha o campo de intervalo",
                              900, Colors.red, Icons.error);
                        } else {
                          setState(() => isLoading = true);
                          await IntervalPost()
                              .post(int.parse(intervaloController.text))
                              .then((value) {
                            if (value.statusCode < 300) {
                              Navigator.pop(context);
                              toastModal("Sucesso", "Intervalo atualizado!",
                                  1200, Colors.blue, Icons.check);
                              
                            } else {
                              toastModal(
                                  "Erro",
                                  "Problema na atualização do intervalo",
                                  900,
                                  Colors.red,
                                  Icons.error);
                            }
                          });
                          setState(() => isLoading = false);
                        }
                      },
                      child: Container(
                        height: 55,
                        width: 135,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: isLoading == true
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Salvar",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
      },
    );
  }

  void toastModal(
      String title, String message, int duration, Color color, IconData icon) {
    return CherryToast(
            icon: icon,
            themeColor: color,
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            displayTitle: true,
            description: Text(message),
            toastPosition: Position.top,
            animationDuration: Duration(milliseconds: duration),
            autoDismiss: true,
            animationType: AnimationType.fromTop)
        .show(context);
  }
}
