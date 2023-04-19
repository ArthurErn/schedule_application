import 'package:Equilibre/domain/opening_hours.dart';
import 'package:Equilibre/infra/opening_hours_response.dart';
import 'package:Equilibre/utilities/translate_days.dart';
import 'package:Equilibre/view/configuration_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class ConfigureWorkDays extends StatefulWidget {
  const ConfigureWorkDays({super.key});

  @override
  State<ConfigureWorkDays> createState() => _ConfigureWorkDaysState();
}

class _ConfigureWorkDaysState extends State<ConfigureWorkDays> {
  final schedules = DateFormat('dd/MM');
  final DateTime date = DateTime.now();
  final daysOfWeek = DateFormat('EEEE');

  List<String> listDays = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  bool light = false;

  translateSequencial(int sequencial) {
    switch (sequencial) {
      case 0:
        return 'Segunda-feira';
      case 1:
        return 'Terça-feira';
      case 2:
        return 'Quarta-feira';
      case 3:
        return 'Quinta-feira';
      case 4:
        return 'Sexta-feira';
      case 5:
        return 'Sábado';
      case 6:
        return 'Domingo';
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
        itemCount: listOpeningHours.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        translateSequencial(
                                listOpeningHours[index].sequencial)
                            .toUpperCase(),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 184, 184, 184),
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                          child: Divider(
                        color: Color.fromARGB(255, 184, 184, 184),
                        thickness: 1.1,
                      )),
                      const SizedBox(width: 10),
                      Text(
                        listOpeningHours[index].emAtendimento == true
                            ? "ATENDENDO"
                            : "FECHADO",
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                listOpeningHours[index].emAtendimento == true
                                    ? const Color.fromARGB(255, 95, 197, 99)
                                    : const Color.fromARGB(255, 104, 104, 104)),
                      ),
                      Switch(
                        value: listOpeningHours[index].emAtendimento,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          setState(() {
                            listOpeningHours[index].emAtendimento = value;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: ()async{
                            listOpeningHours[index].horaInicial = await selectTime(context, listOpeningHours[index].horaInicial);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: listOpeningHours[index].emAtendimento == true?Colors.white:const Color.fromARGB(255, 107, 107, 107),
                                borderRadius: BorderRadius.circular(14)),
                            height: 42,
                            width: 80,
                            child: Center(
                              child: Text(
                                listOpeningHours[index].horaInicial,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async{
                            listOpeningHours[index].horaSaidaIntervalo = await selectTime(context, listOpeningHours[index].horaSaidaIntervalo);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: listOpeningHours[index].emAtendimento == true?Colors.white:const Color.fromARGB(255, 107, 107, 107),
                                borderRadius: BorderRadius.circular(14)),
                            height: 42,
                            width: 80,
                            child: Center(
                              child: Text(
                                listOpeningHours[index].horaSaidaIntervalo,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async{
                            listOpeningHours[index].horaRetornoIntervalo = await selectTime(context, listOpeningHours[index].horaRetornoIntervalo);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: listOpeningHours[index].emAtendimento == true?Colors.white:const Color.fromARGB(255, 107, 107, 107),
                                borderRadius: BorderRadius.circular(14)),
                            height: 42,
                            width: 80,
                            child: Center(
                              child: Text(
                                listOpeningHours[index].horaRetornoIntervalo,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async{
                            listOpeningHours[index].horaFechamento = await selectTime(context, listOpeningHours[index].horaFechamento);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: listOpeningHours[index].emAtendimento == true?Colors.white:const Color.fromARGB(255, 107, 107, 107),
                                borderRadius: BorderRadius.circular(14)),
                            height: 42,
                            width: 80,
                            child: Center(
                              child: Text(
                                listOpeningHours[index].horaFechamento,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  
                ]),
          );
        }));
  }

  Future<String> selectTime(BuildContext context, String period) async {
  TimeOfDay? picked = await showTimePicker(
    hourLabelText: "",
    minuteLabelText: "",
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    period = "${picked.hour}:${picked.minute}" ;
    if(picked.minute.toString().startsWith('0')){
      period = period.replaceRange(3, 4, "00");
    }
    period = "$period:00";
    return period;
  }
  return "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
}
}