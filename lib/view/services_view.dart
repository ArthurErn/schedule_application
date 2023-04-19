import 'package:Equilibre/colors.dart';
import 'package:Equilibre/domain/service.dart';
import 'package:Equilibre/infra/create_service_response.dart';
import 'package:Equilibre/infra/delete_service.dart';
import 'package:Equilibre/main.dart';
import 'package:Equilibre/utilities/move_to.dart';
import 'package:Equilibre/utilities/text_field.dart';
import 'package:Equilibre/view/home_view.dart';
import 'package:Equilibre/view/login_screen.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ServicesScreen extends StatefulWidget {
  List<TextEditingController> registerServiceControllers;
  ServicesScreen({super.key, required this.registerServiceControllers});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: '');
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: ListView.builder(
          itemCount: listService.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Slidable(
                enabled: userCredentials.idPermissao >= 2,
                closeOnScroll: false,
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (value) {
                        _showConfirmation(listService[index].idServico);
                      },
                      borderRadius: BorderRadius.circular(12),
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Excluir',
                    ),
                    SlidableAction(
                      onPressed: (value) {
                        widget.registerServiceControllers[0].text =
                            listService[index].nomeServico;
                        widget.registerServiceControllers[1].text =
                            listService[index].descricao;
                        widget.registerServiceControllers[2].text =
                            listService[index].valor.toString();
                        widget.registerServiceControllers[3].text =
                            listService[index].tempoServico.toString();
                        _showServiceRegistration(listService[index].idServico);
                      },
                      borderRadius: BorderRadius.circular(12),
                      backgroundColor: const Color.fromARGB(255, 40, 108, 255),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Editar',
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(.2)),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              listService[index].nomeServico,
                              style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            Text(
                                "R\$${currency.format(listService[index].valor).toString()}",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 197, 38),
                                    letterSpacing: .2,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 250,
                              child: Text(listService[index].descricao,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Color.fromARGB(255, 126, 126, 126))),
                            ),
                            Text(
                              "${listService[index].tempoServico.toString()} min",
                              style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })),
    );
  }

  Future _showServiceRegistration(int idServico) async {
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
                      TextFieldComponent()
                          .build(widget.registerServiceControllers[0]),
                      const SizedBox(height: 10),
                      const Text(
                        "Descrição do serviço",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextFieldComponent().build(
                          widget.registerServiceControllers[1],
                          maxLines: 4),
                      const SizedBox(height: 10),
                      const Text(
                        "Valor do serviço",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextFieldComponent().build(
                          widget.registerServiceControllers[2],
                          inputType: TextInputType.number),
                      const SizedBox(height: 10),
                      const Text(
                        "Tempo do serviço (opcional)",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      TextFieldComponent().build(
                          widget.registerServiceControllers[3],
                          inputType: TextInputType.number,
                          validate: false),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await CreateServiceResponse()
                                .put(
                                    widget.registerServiceControllers[0].text,
                                    widget.registerServiceControllers[1].text,
                                    double.parse(widget
                                        .registerServiceControllers[2].text),
                                    int.parse(widget
                                        .registerServiceControllers[3].text),
                                    idServico)
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

  bool isLoading = false;
  Future _showConfirmation(int idServico) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Tem certeza que deseja excluir o serviço?',
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
                            await DeleteService()
                                .delete(idServico)
                                .then((value) {
                              if(value.statusCode < 300){
                                  MoveTo().page(context, const HomeScreen());
                                  toastModal(
                                  'Sucesso',
                                  'Serviço excluido com sucesso',
                                  1000,
                                  Colors.green,
                                  Icons.check);
                              }else{
                                toastModal(
                                  'Erro',
                                  'O serviço está vinculado a um processo!',
                                  1000,
                                  Colors.red,
                                  Icons.error);
                              }
                              setState(() {
                                isLoading = false;
                              });
                              
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
