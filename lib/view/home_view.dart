import 'dart:async';

import 'package:Equilibre/domain/schedule.dart';
import 'package:Equilibre/domain/service.dart';
import 'package:Equilibre/infra/address_response.dart';
import 'package:Equilibre/infra/create_service_response.dart';
import 'package:Equilibre/infra/newer_schedules.dart';
import 'package:Equilibre/infra/older_schedules.dart';
import 'package:Equilibre/infra/opening_hours_response.dart';
import 'package:Equilibre/infra/post_schedule.dart';
import 'package:Equilibre/infra/services_response.dart';
import 'package:Equilibre/infra/social_media_response.dart';
import 'package:Equilibre/main.dart';
import 'package:Equilibre/utilities/move_to.dart';
import 'package:Equilibre/utilities/text_field.dart';
import 'package:Equilibre/view/configuration_view.dart';
import 'package:Equilibre/view/information_screen.dart';
import 'package:Equilibre/view/login_screen.dart';
import 'package:Equilibre/view/schedule_view.dart';
import 'package:Equilibre/view/services_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import '../colors.dart';

bool isLogout = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  DateTime date = DateTime.now();
  final f = DateFormat('dd/MM/yyyy HH:mm:ss');
  final schedules = DateFormat('dd/MM');
  final daysOfWeek = DateFormat('EEEE');
  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: '');
  List<dynamic> scheduleList = [];
  bool isFuture = true;
  List<bool> pages = [true, false, false, false];

  setColor(String situation) {
    switch (situation) {
      case 'Agendamento Confirmado':
        return Colors.blue;
      case 'Agendamento Concluído':
        return Colors.green;
      case 'Agendamento Cancelado':
        return Colors.red;
      default:
    }
  }

  setIcon(String situation) {
    switch (situation) {
      case 'Agendamento Confirmado':
        return Icons.hourglass_empty;
      case 'Agendamento Concluído':
        return Icons.check;
      case 'Agendamento Cancelado':
        return Icons.cancel_sharp;
      default:
    }
  }

  void getWorkingDays() async {
    await OpeningHoursResponse()
        .ping()
        .then((value) => setState(() => listOpeningHours = value));
  }

  List<dynamic> futureSchedule = [];
  List<dynamic> oldSchedule = [];

  bool isError = false;

  requestSchedules() async {
    isError = false;
    if (userCredentials.idPermissao > 1) {
      await NewerSchedules().pingClients().then((value) {
        if (value == null) {
          setState(() {
            isError = true;
          });
        } else {
          futureSchedule = value;
          scheduleList = futureSchedule;
          oldSchedule = futureSchedule;
        }
      });
    } else {
      futureSchedule = await NewerSchedules().ping();
      oldSchedule = await OlderSchedules().ping();
      if (oldSchedule.isNotEmpty || futureSchedule.isNotEmpty) {
        scheduleList = (isFuture == true && futureSchedule.isNotEmpty)
            ? futureSchedule
            : oldSchedule;
        isFuture = futureSchedule.isNotEmpty ? true : false;
      } else {
        setState(() {
          isError = true;
        });
      }
    }
  }

  List<TextEditingController> registerServiceControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  listServices() async {
    await ServicesResponse()
        .ping()
        .then((value) => setState(() => listService = value));
  }

  listInformations() async {
    await AddressResponse().ping().then((value) async {
      if (value.isNotEmpty) address = value[0];

      await SocialMediaResponse().ping().then((value) {
        setState(() {
          if (value.isNotEmpty) socialMedia = value[0];
        });
      });
    });
  }

  @override
  void initState() {
    const oneSec = Duration(seconds: 1);
    requestSchedules();
    getWorkingDays();
    listServices();
    listInformations();
    Timer.periodic(
        oneSec,
        (Timer t) => setState(() {
              date = DateTime.now();
            }));
    super.initState();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton:
            ((pages[1] == true && userCredentials.idPermissao > 1) ||
                    pages[0] == true && userCredentials.idPermissao <= 1)
                ? FloatingActionButton(
                    onPressed: () {
                      if (pages[0] == true) {
                        MoveTo().page(context, const ScheduleView());
                      }
                      if (pages[1] == true) _showServiceRegistration();
                    },
                    backgroundColor: AppColors.blue,
                    child: const Icon(Icons.add),
                  )
                : null,
        backgroundColor: Colors.white,
        body: Container(
          color: AppColors.primaryColor.withOpacity(.8),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
            onRefresh: () {
              setState(() {
                futureSchedule.clear();
                oldSchedule.clear();
              });
              return requestSchedules();
            },
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                if (scheduleList.isEmpty && pages[0] == true)
                  isError == false
                      ? const Expanded(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : Center(
                          child: Column(
                          children: const [
                            Icon(Icons.error, color: Colors.red, size: 30),
                            Text(
                              "Nenhum agendamento cadastrado",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 255, 74, 3)),
                            ),
                          ],
                        ))
                else if (pages[0] == true)
                  Expanded(
                    child: Container(
                      color: AppColors.primaryColor,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          userCredentials.idPermissao > 1
                              ? const Center()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isFuture = true;
                                          if (futureSchedule.isEmpty) {
                                            toastModal(
                                                'Erro',
                                                'Não há agendamentos futuros',
                                                1200,
                                                Colors.red,
                                                Icons.error);
                                            setState(() {
                                              isFuture = false;
                                            });
                                          } else {
                                            scheduleList = isFuture == true
                                                ? futureSchedule
                                                : oldSchedule;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 140,
                                        decoration: BoxDecoration(
                                            color: isFuture == true
                                                ? Color.fromARGB(
                                                    255, 177, 159, 3)
                                                : AppColors.selectedColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft:
                                                    Radius.circular(12))),
                                        child: const Center(
                                          child: Text("Próximos",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (oldSchedule.isEmpty) {
                                            toastModal(
                                                'Erro',
                                                'Não há agendamentos passados',
                                                1200,
                                                Colors.red,
                                                Icons.error);
                                          } else {
                                            isFuture = false;
                                            scheduleList = isFuture == true
                                                ? futureSchedule
                                                : oldSchedule;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 140,
                                        decoration: BoxDecoration(
                                            color: isFuture == false
                                                ? Color.fromARGB(
                                                    255, 177, 159, 3)
                                                : AppColors.selectedColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12))),
                                        child: const Center(
                                          child: Text("Passados",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 15,
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: scheduleList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (userCredentials.idPermissao <= 1)
                                        _showMyDialog(scheduleList[index]);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        width: 250,
                                        color: AppColors.primaryColor
                                            .withOpacity(.8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AutoSizeText(
                                                        scheduleList[index]
                                                            .nomeServico,
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        'R\$${currency.format(scheduleList[index].valor)}',
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    238,
                                                                    215,
                                                                    11),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ]),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_month,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      scheduleList[index]
                                                          .dataHora
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              userCredentials.idPermissao > 1
                                                  ? Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.person,
                                                          size: 25,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                            scheduleList[index]
                                                                .cliente,
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color: setColor(
                                                                scheduleList[
                                                                        index]
                                                                    .situacao)
                                                            .withOpacity(.4)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            setIcon(
                                                                scheduleList[
                                                                        index]
                                                                    .situacao),
                                                            color: setColor(
                                                                scheduleList[
                                                                        index]
                                                                    .situacao),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                              scheduleList[
                                                                      index]
                                                                  .situacao,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: setColor(
                                                                      scheduleList[
                                                                              index]
                                                                          .situacao),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                if (pages[1] == true)
                  Expanded(
                      child: ServicesScreen(
                    registerServiceControllers: registerServiceControllers,
                  )),
                if (pages[2] == true)
                  const Expanded(child: ConfigurationScreen()),
                if (pages[3] == true) const InformationScreen()
              ],
            ),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryColor,
          toolbarHeight: 120,
          title: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width -40,
                      child: AutoSizeText(
                        "Olá, ${userCredentials.nome}",
                        style: TextStyle(
                            fontSize: 22,
                            color: AppColors.selectedColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: AppColors.selectedColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            f.format(date).toString(),
                            style: TextStyle(
                                fontSize: 25,
                                color: AppColors.selectedColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                isLogout = true;
                                MoveTo()
                                    .pageAndReplace(context, const LoginScreen());
                              },
                              child: const Icon(
                                Icons.logout,
                                size: 28,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(.8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: userCredentials.idPermissao > 1
                    ? GNav(
                        rippleColor: Colors.grey[300]!,
                        hoverColor: Colors.grey[100]!,
                        gap: 8,
                        activeColor: Colors.white,
                        iconSize: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        duration: const Duration(milliseconds: 400),
                        tabBackgroundColor: AppColors.selectedColor,
                        color: Colors.white,
                        tabs: [
                          GButton(
                            icon: Icons.home,
                            text: 'Agendamentos',
                            onPressed: () {
                              setState(() {
                                pages[0] = true;
                                pages[1] = false;
                                pages[2] = false;
                                pages[3] = false;
                              });
                            },
                          ),
                          GButton(
                            icon: Icons.work,
                            text: 'Serviços',
                            onPressed: () {
                              setState(() {
                                pages[0] = false;
                                pages[1] = true;
                                pages[2] = false;
                                pages[3] = false;
                              });
                            },
                          ),
                          GButton(
                            icon: Icons.settings,
                            text: 'Configurações',
                            onPressed: () {
                              setState(() {
                                pages[0] = false;
                                pages[1] = false;
                                pages[2] = true;
                                pages[3] = false;
                              });
                            },
                          )
                        ],
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      )
                    : GNav(
                        rippleColor: Colors.grey[300]!,
                        hoverColor: Colors.grey[100]!,
                        gap: 8,
                        activeColor: Colors.white,
                        iconSize: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        duration: const Duration(milliseconds: 400),
                        tabBackgroundColor: AppColors.selectedColor,
                        color: Colors.white,
                        tabs: [
                          GButton(
                            icon: Icons.home,
                            text: 'Agendamentos',
                            onPressed: () {
                              setState(() {
                                pages[0] = true;
                                pages[1] = false;
                                pages[2] = false;
                                pages[3] = false;
                              });
                            },
                          ),
                          GButton(
                            icon: Icons.work,
                            text: 'Serviços',
                            onPressed: () {
                              setState(() {
                                pages[0] = false;
                                pages[1] = true;
                                pages[2] = false;
                                pages[3] = false;
                              });
                            },
                          ),
                          GButton(
                            icon: Icons.info,
                            text: 'Informações',
                            onPressed: () {
                              setState(() {
                                pages[0] = false;
                                pages[1] = false;
                                pages[2] = false;
                                pages[3] = true;
                              });
                            },
                          )
                        ],
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _showMyDialog(ScheduleEntity actualSchedule) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(actualSchedule.nomeServico,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  actualSchedule.descricaoCompleta,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 97, 97, 97)),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${actualSchedule.tempoServico}min",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$${currency.format(actualSchedule.valor)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  actualSchedule.nome,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 25),
                Text(
                  actualSchedule.dataHora.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: isFuture &&
                      actualSchedule.situacao != "Agendamento Cancelado",
                  child: GestureDetector(
                    onTap: () {
                      _showConfirmation(actualSchedule);
                    },
                    child: Container(
                      height: 60,
                      width: 180,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      child: const Center(
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  bool isLoading = false;
  Future _showConfirmation(ScheduleEntity actualSchedule) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Tem certeza que deseja cancelar o serviço?',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await PostSchedule()
                                .cancel('${actualSchedule.idAgendamento}')
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              MoveTo().page(context, const HomeScreen());
                            });
                          },
                          child: Container(
                              height: 45,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 41, 52, 216),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                  child: Text('Sim',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500))))),
                      const Spacer(),
                      Visibility(
                          visible: isLoading == true,
                          child: const CircularProgressIndicator()),
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 45,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 241, 72, 72),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                  child: Text('Não',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500))))),
                    ],
                  ),
                ),
              ));
        });
      },
    );
  }

  Future _showServiceRegistration() async {
    bool isLoading = false;
    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Cadastrar Serviço',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              content: SingleChildScrollView(
                  child: SizedBox(
                width: 250,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Nome do serviço",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextFieldComponent().build(registerServiceControllers[0]),
                      const SizedBox(height: 10),
                      const Text(
                        "Descrição do serviço",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextFieldComponent()
                          .build(registerServiceControllers[1], maxLines: 4),
                      const SizedBox(height: 10),
                      const Text(
                        "Valor do serviço",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextFieldComponent().build(registerServiceControllers[2],
                          inputType: TextInputType.number),
                      const SizedBox(height: 10),
                      const Text(
                        "Tempo do serviço (opcional)",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextFieldComponent().build(registerServiceControllers[3],
                          inputType: TextInputType.number, validate: false),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await CreateServiceResponse()
                                .ping(
                                    registerServiceControllers[0].text,
                                    registerServiceControllers[1].text,
                                    double.parse(
                                        registerServiceControllers[2].text),
                                    int.parse(
                                        registerServiceControllers[3].text))
                                .then((value) {
                              Navigator.of(context).pop();
                              MoveTo().page(context, const HomeScreen());
                              toastModal(
                                  'Sucesso',
                                  'Serviço adicionado com sucesso',
                                  1000,
                                  Colors.green,
                                  Icons.check);
                            });
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
                                  : Text(
                                      'Salvar',
                                      style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500),
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            );
          },
        );
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
