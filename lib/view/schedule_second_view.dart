import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:Equilibre/colors.dart';
import 'package:Equilibre/domain/barber_service.dart';
import 'package:Equilibre/infra/user_service_response.dart';
import 'package:Equilibre/infra/post_schedule.dart';
import 'package:Equilibre/utilities/move_to.dart';
import 'package:Equilibre/view/home_view.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleSecondView extends StatefulWidget {
  final List<dynamic> scheduleInfoList;
  const ScheduleSecondView({super.key, required this.scheduleInfoList});

  @override
  State<ScheduleSecondView> createState() => _ScheduleSecondViewState();
}

class _ScheduleSecondViewState extends State<ScheduleSecondView> {

  callBarberServices()async{
    setState(() {
      isLoading = true;
    });
    
    await UserServiceResponse().ping().then((value) => setState((){
      barberServiceList = value;
      isLoading = false;
    }));
  }

  List<UserServiceEntity> barberServiceList = [];
  bool isLoading = false;
  bool isSaving = false;
  int selectedIndex = -1;
  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: '');

  @override
  void initState() {
    callBarberServices();
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
            Text("Novo agendamento", style: TextStyle(fontSize: 23, color: AppColors.selectedColor, fontWeight: FontWeight.bold, letterSpacing: .2),)
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: selectedIndex >= 0?true:false,
        child: FloatingActionButton(
          onPressed: () async{
            setState(() {
              isSaving = true;
            });
            await PostSchedule().ping(widget.scheduleInfoList).then((value){
              
              dynamic texto = jsonDecode(utf8.decode(value.bodyBytes));
              if(value.statusCode >= 400){
                toastModal('Erro', texto['detail'], 1200, Colors.red, Icons.error);
              }else{
                Navigator.pop(context);
                Navigator.pop(context);
                MoveTo().page(context, const HomeScreen());
                toastModal('Sucesso', "Horário marcado com sucesso", 1200, Colors.green, Icons.check);
              }
              setState(() {
              isSaving = false;
            });
            });
          },
          backgroundColor: AppColors.blue,
          child: isSaving ? const CircularProgressIndicator():const Icon(Icons.check),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: AppColors.primaryColor.withOpacity(.8),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
              color: AppColors.primaryColor.withOpacity(.8),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(color: AppColors.primaryColor,),
                child: isLoading == true?const Center(child: CircularProgressIndicator(),):Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: Center(child: Text('Serviços', style: TextStyle(color: AppColors.selectedColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: .2)))),
                    Expanded(
                      child: ListView.builder(
                        itemCount: barberServiceList.length,
                        itemBuilder: ((context, index){
                          return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedIndex = index;
                                widget.scheduleInfoList[2] = barberServiceList[index].idUsuarioServico;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(14)),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                height: 86,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: selectedIndex == index?const Color.fromARGB(255, 255, 239, 95):AppColors.primaryColor.withOpacity(0.8), borderRadius: BorderRadius.circular(14)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person_rounded, color: selectedIndex == index?Colors.black:Colors.white, size: 32,),
                                            const SizedBox(width: 6),
                                          AutoSizeText(barberServiceList[index].nome.toUpperCase(), style: TextStyle(color: selectedIndex == index?Colors.black:Colors.white, letterSpacing: .2, fontSize: 17), maxLines: 1,),
                                          ],
                                        ),
                                        Expanded(child: Container(),),
                                        Row(
                                          children: [
                                            const SizedBox(width: 6),
                                          Text("R\$${currency.format(barberServiceList[index].valor)}", style: const TextStyle(color: Color.fromARGB(255, 255, 197, 38), letterSpacing: .2, fontSize: 17)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.work_rounded, color: selectedIndex == index?Colors.black:Colors.white, size: 32,),
                                        const SizedBox(width: 6),
                                        Text(barberServiceList[index].nomeServico.toUpperCase(), style: TextStyle(color: selectedIndex == index?Colors.black:Colors.white, letterSpacing: .2, fontSize: 17)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );}),),
                    ),
                  ],
                ),
              )
              ),
        ),
      ),
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