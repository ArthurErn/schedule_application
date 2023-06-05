import 'package:Equilibre/colors.dart';
import 'package:Equilibre/domain/opening_hours.dart';
import 'package:Equilibre/infra/schedule_date.dart';
import 'package:Equilibre/main.dart';
import 'package:Equilibre/utilities/move_to.dart';
import 'package:Equilibre/utilities/translate_days.dart';
import 'package:Equilibre/view/schedule_second_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final schedules = DateFormat('dd/MM');
  final requestSchedules = DateFormat('yyyy-MM-dd');
  DateTime date = DateTime.now();
  final daysOfWeek = DateFormat('EEEE');
  List<dynamic> scheduleHoursList = [];
  bool isLoading = false;
  bool isClicked = false;
  int selectedDayIndex = -1;
  int selectedHourIndex = -1;
  List<dynamic> scheduleInformations = ['', '', ''];

  workThisDay(DateTime thisDate, int sequencial) {
    DateTime data = date.add(Duration(days: sequencial));
    List<OpeningHours> closed = listOpeningHours
        .where((element) =>
            element.sequencial == data.weekday - 1 &&
            element.emAtendimento == false)
        .toList();
    return closed.isNotEmpty ? false : true;
  }

  @override
  void initState() {
    setState(() {
      isClicked = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Novo agendamento",
              style: TextStyle(
                  fontSize: 23,
                  color: AppColors.selectedColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .2),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //   },
      //   backgroundColor: AppColors.blue,
      //   child: const Icon(Icons.add),
      // ),
      backgroundColor: Colors.white,
      body: Container(
        color: AppColors.primaryColor.withOpacity(.8),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Row(children: [
            //   scheduleInformations[0] == ''?const Icon(Icons.close, color: Colors.red,):const Icon(Icons.check, color: Colors.green,),
            //   Text('Data selecionada', style: TextStyle(color: AppColors.selectedColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: .4),)
            // ],),
            // const SizedBox(height: 5),
            // Row(children: [
            //   scheduleInformations[1] == ''?const Icon(Icons.close, color: Colors.red,):const Icon(Icons.check, color: Colors.green,),
            //   Text('Horário selecionada', style: TextStyle(color: AppColors.selectedColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: .4),)
            // ],),
            // const SizedBox(height: 5),
            // Row(children: [
            //   scheduleInformations[2] == ''?const Icon(Icons.close, color: Colors.red,):const Icon(Icons.check, color: Colors.green,),
            //   Text('Serviço selecionado', style: TextStyle(color: AppColors.selectedColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: .4),)
            // ],),
            const SizedBox(height: 10),
            Container(
              height: 120,
              color: AppColors.primaryColor,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 90,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 8, right: 8),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                          selectedHourIndex = -1;
                        });

                        await ScheduleDate()
                            .ping(requestSchedules
                                .format(date.add(Duration(days: index))))
                            .then((value) => setState(() {
                                  scheduleHoursList = value;
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      selectedDayIndex = index;
                                    });
                                  } else {
                                    selectedDayIndex = -1;
                                  }
                                }));
                        setState(() {
                          setState(() {
                            isClicked = true;
                          });
                          isLoading = false;
                        });
                        scheduleInformations[0] = requestSchedules
                            .format(date.add(Duration(days: index)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: workThisDay(date, index)
                              ? selectedDayIndex == index
                                  ? Color.fromARGB(255, 158, 146, 35)
                                  : AppColors.selectedColor
                              : Colors.red,
                        ),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: selectedDayIndex == index
                                ? Colors.transparent
                                : AppColors.primaryColor.withOpacity(.8),
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                schedules
                                    .format(date.add(Duration(days: index)))
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                translateDaysOfWeek(daysOfWeek
                                    .format(date.add(Duration(days: index)))),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )
                            ],
                          )),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
                visible: scheduleHoursList.isEmpty && isClicked == true,
                child: const SizedBox(
                  height: 170,
                )),
            Visibility(
                visible: isClicked == false,
                child: const Center(
                  child: Text(
                    'Selecione a data desejada para seu agendamento',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.redAccent),
                  ),
                )),
            Visibility(
                visible: scheduleHoursList.isEmpty && isClicked == true,
                child: const Text(
                  'Não trabalhamos neste dia!',
                  style: TextStyle(fontSize: 20, color: Colors.redAccent),
                )),
            Visibility(
                visible: scheduleHoursList.isNotEmpty,
                child: const Text(
                  'Horários disponíveis',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
            const SizedBox(
              height: 15,
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Visibility(
                  visible: scheduleHoursList.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: SizedBox(
                      height: 330,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 3),
                          physics: const BouncingScrollPhysics(),
                          itemCount: scheduleHoursList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedHourIndex = index;
                                    scheduleInformations[1] =
                                        scheduleHoursList[index];
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: selectedHourIndex == index
                                        ? Colors.yellow
                                        : AppColors.selectedColor,
                                  ),
                                  child: Container(
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColors.primaryColor
                                              .withOpacity(.8)),
                                      child: Center(
                                          child: Text(
                                        scheduleHoursList[index],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                Visibility(
                    visible: isLoading,
                    child: const Center(child: CircularProgressIndicator())),
              ],
            ),
            const SizedBox(height: 10),
            
          ],
        ),
      ),
      floatingActionButton: Visibility(
              visible: selectedDayIndex >= 0 && selectedHourIndex >= 0,
              child: FloatingActionButton(
                  onPressed: () {
                    MoveTo().page(
                        context,
                        ScheduleSecondView(
                            scheduleInfoList: scheduleInformations));
                  },
                child: const Icon(Icons.check, color: Colors.white,)),
            ),
    );
  }
}
