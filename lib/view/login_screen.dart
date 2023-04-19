import 'dart:convert';

import 'package:Equilibre/colors.dart';
import 'package:Equilibre/domain/user.dart';
import 'package:Equilibre/external/persist_fields.dart';
import 'package:Equilibre/infra/login_response.dart';
import 'package:Equilibre/infra/new_password.dart';
import 'package:Equilibre/infra/register_response.dart';
import 'package:Equilibre/infra/reset_password.dart';
import 'package:Equilibre/utilities/check_internet.dart';
import 'package:Equilibre/utilities/move_to.dart';
import 'package:Equilibre/view/home_view.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late UserEntity userCredentials;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRegister = false;
  bool checkboxValue = false;
  bool hideField = true;
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController registerUserController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerSecondPasswordController =
      TextEditingController();
  TextEditingController registerPhoneController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();

  //RETORNA OS ULTIMOS CAMPOS
  Future loadLogin() async {
    final pref = await SharedPreferences.getInstance();
    String? usuarioAPI = pref.getString("usuario");
    String? senhaAPI = pref.getString("senha");
    setState(() {
      userController.text = usuarioAPI!;
      passwordController.text = senhaAPI!;
      if (isLogout == false) {
        logUser(userController.text, passwordController.text);
      }
    });
  }

  Future loadCheckbox() async {
    final pref = await SharedPreferences.getInstance();
    dynamic lembrar = pref.getBool('lembrar');
    setState(() {
      checkboxValue = lembrar ?? false;
    });
  }

  void logUser(String user, String senha) async {
    setState(() {
      isLoading = true;
    });

    LoginResponse login = LoginResponse();
    await login.ping(user, senha).then((value) {
      if (value == null) {
        setState(() {
          isLoading = false;
          toastModal("Erro", "Verifique sua conexão com a internet", 500,
              Colors.red, Icons.error);
        });
        return;
      }
      if (value.statusCode != 202) {
        setState(() {
          isLoading = false;
          dynamic valor = jsonDecode(utf8.decode(value.bodyBytes));
          toastModal("Erro", valor["detail"], 500, Colors.red, Icons.error);
        });
        return;
      }
      userCredentials =
          UserEntity.fromJson(json.decode(utf8.decode(value.bodyBytes)));
      salvarCheckbox(checkboxValue);
      salvarLogin(userController, passwordController);
      setState(() {
        isLoading = false;
      });
      MoveTo().page(context, const HomeScreen());
    });
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

  void registerUser(
      {required String email,
      required String user,
      required String senha,
      required String phone,
      required String senhaConfirmar}) async {
    if (email.isEmpty ||
        user.isEmpty ||
        senha.isEmpty ||
        phone.isEmpty ||
        senhaConfirmar.isEmpty) {
      toastModal(
          'Erro', 'Preencha os campos vazios', 500, Colors.red, Icons.error);
    } else if (registerPasswordController.text !=
        registerSecondPasswordController.text) {
      toastModal(
          'Erro', 'Senhas não condizentes', 500, Colors.red, Icons.error);
    } else {
      setState(() {
        isLoading = true;
      });
      RegisterResponse register = RegisterResponse();
      await register
          .ping(user, senha.replaceAll(' ', ''), phone.replaceAll(' ', ''),
              email.replaceAll(' ', ''))
          .then((value) {
        dynamic valor = jsonDecode(utf8.decode(value.bodyBytes));
        if (value.statusCode == 201) {
          toastModal(
              "Sucesso", valor["nome"], 500, Colors.lightGreen, Icons.check);
          setState(() {
            isLoading = false;
            isRegister = false;
          });
        } else {
          toastModal('Erro', valor["detail"], 500, Colors.red, Icons.error);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  void fuckGoBackWrongButton() {
    setState(() {
      isRegister = false;
    });
  }

  void bringFields() async {
    await CheckInternet().check().then((value) async {
      if (value == null) return null;
      await loadCheckbox().then((value) {
        if (checkboxValue == true) {
          loadLogin();
        }
      });
    });
  }

  @override
  void initState() {
    bringFields();
    super.initState();
  }

  Widget customTextField(
      Icon icon, TextEditingController fieldController, String helperText,
      {bool isPassword = false}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      elevation: 20,
      shadowColor: Colors.grey[700],
      child: TextField(
          onChanged: (_) {
            setState(() {});
          },
          controller: fieldController,
          obscureText: isPassword == true ? hideField : false,
          decoration: InputDecoration(
              hintText: helperText,
              suffixIcon: (isPassword && passwordController.text != '')
                  ? GestureDetector(
                      child: Icon(hideField == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onTap: () {
                        setState(() {
                          hideField = hideField == false ? true : false;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: icon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.circular(12),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primaryColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: isRegister == false
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'lib/assets/logo.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                      const SizedBox(height: 15),
                      customTextField(
                          const Icon(Icons.person,
                              size: 35, color: Colors.blue),
                          userController,
                          'E-mail'),
                      const SizedBox(height: 10),
                      customTextField(
                          const Icon(
                            Icons.key,
                            size: 35,
                            color: Colors.blue,
                          ),
                          passwordController,
                          "Senha",
                          isPassword: true),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: checkboxValue,
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                  width: 1.0, color: Colors.white),
                            ),
                            onChanged: (_) => setState(() {
                              checkboxValue = !checkboxValue;
                            }),
                            activeColor: Colors.white,
                            checkColor: AppColors.blue,
                          ),
                          const Text(
                            'Lembrar usuário?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'spoof'),
                          )
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            logUser(
                                userController.text, passwordController.text);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromRGBO(180, 0, 0, 100),
                            ),
                            height: 55,
                            width: MediaQuery.of(context).size.width - 50,
                            child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            fontSize: 35,
                                            color:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.white)),
                                      )),
                          )),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                await CheckInternet().check().then((value) {
                                  if (value == null) {
                                    toastModal(
                                        "Erro",
                                        "Verifique sua conexão com a internet",
                                        500,
                                        Colors.red,
                                        Icons.error);
                                  } else {
                                    setState(() {
                                      isRegister = true;
                                    });
                                  }
                                });
                              },
                              child: const Text('Registrar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))),
                          GestureDetector(
                            onTap: () async {
                              await CheckInternet().check().then((value) {
                                if (value == null) {
                                  toastModal(
                                      "Erro",
                                      "Verifique sua conexão com a internet",
                                      500,
                                      Colors.red,
                                      Icons.error);
                                } else {
                                  _showPasswordRedefinition();
                                }
                              });
                            },
                            child: const Text("Esqueceu sua senha?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      )
                    ],
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'lib/assets/logo.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                        const SizedBox(height: 15),
                        customTextField(
                            const Icon(Icons.mail,
                                size: 35, color: Colors.blue),
                            registerEmailController,
                            "E-mail"),
                        const SizedBox(height: 10),
                        customTextField(
                            const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.blue,
                            ),
                            registerUserController,
                            "Nome"),
                        const SizedBox(height: 10),
                        customTextField(
                            const Icon(
                              Icons.phone,
                              size: 35,
                              color: Colors.blue,
                            ),
                            registerPhoneController,
                            "Telefone"),
                        const SizedBox(height: 10),
                        customTextField(
                            const Icon(
                              Icons.key,
                              size: 35,
                              color: Colors.blue,
                            ),
                            registerPasswordController,
                            "Senha",
                            isPassword: true),
                        const SizedBox(height: 10),
                        customTextField(
                            const Icon(
                              Icons.key,
                              size: 35,
                              color: Colors.blue,
                            ),
                            registerSecondPasswordController,
                            "Confirme sua senha",
                            isPassword: true),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: () {
                              registerUser(
                                  email: registerEmailController.text,
                                  user: registerUserController.text,
                                  senha: registerPasswordController.text,
                                  phone: registerPhoneController.text,
                                  senhaConfirmar:
                                      registerSecondPasswordController.text);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color.fromRGBO(180, 0, 0, 100),
                              ),
                              height: 55,
                              width: MediaQuery.of(context).size.width - 50,
                              child: Center(
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          "REGISTRAR",
                                          style: TextStyle(
                                              fontSize: 35,
                                              color: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.white)),
                                        )),
                            )),
                        const SizedBox(height: 20),
                        IconButton(
                            onPressed: () => fuckGoBackWrongButton(),
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 35,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<String> resetPassword(String email) async {
    dynamic texto;
    await ResetPassword().ping(email).then((value) {
      if (value.statusCode == 200) {
        Navigator.pop(context);
        _showResetCode();
      }
      texto = jsonDecode(utf8.decode(value.bodyBytes));
    });
    return texto['detail'].toString();
  }

  _showPasswordRedefinition() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isResetLoading = false;
        String erro = '';
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              elevation: 10,
              title: Text("Redefinir senha"),
              content: SizedBox(
                height: 160,
                child: Column(
                  children: [
                    customTextField(
                        const Icon(Icons.email, size: 35, color: Colors.blue),
                        emailController,
                        "Insira seu e-mail"),
                    const SizedBox(height: 10),
                    erro.isEmpty
                        ? Container()
                        : Text(
                            erro,
                            style: const TextStyle(color: Colors.red),
                          ),
                    !erro.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showResetCode();
                            },
                            child: Text(
                              "Já tenho o código",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isResetLoading = true;
                        });
                        await resetPassword(emailController.text)
                            .then((value) => setState(() {
                                  isResetLoading = false;
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      erro = value.toString();
                                    });
                                  }
                                }));
                      },
                      child: Container(
                        height: 60,
                        width: 350,
                        color: AppColors.blue,
                        child: Center(
                          child: isResetLoading == false
                              ? const Text("Enviar",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white))
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _showResetCode() {
    bool isResetLoading = false;
    String idUser = '';
    bool resetLoginSuccessful = false;
    TextEditingController resetCodeController = TextEditingController();
    TextEditingController resetPasswordController = TextEditingController();
    TextEditingController resetPasswordConfirmController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              elevation: 10,
              title: Text(resetLoginSuccessful
                  ? "Digite sua nova senha"
                  : "Digite seu código"),
              content: SizedBox(
                height: resetLoginSuccessful ? 210 : 140,
                child: Column(
                  children: [
                    resetLoginSuccessful
                        ? Container()
                        : customTextField(
                            const Icon(Icons.code,
                                size: 35, color: Colors.blue),
                            resetCodeController,
                            'Insira o código do e-mail'),
                    resetLoginSuccessful
                        ? const SizedBox(height: 10)
                        : Container(),
                    resetLoginSuccessful
                        ? customTextField(
                            const Icon(Icons.password,
                                size: 35, color: Colors.blue),
                            resetPasswordController,
                            'Insira a nova senha',
                            isPassword: true)
                        : Container(),
                    resetLoginSuccessful
                        ? const SizedBox(height: 10)
                        : Container(),
                    resetLoginSuccessful
                        ? customTextField(
                            const Icon(Icons.password,
                                size: 35, color: Colors.blue),
                            resetPasswordConfirmController,
                            'Confirmar senha',
                            isPassword: true)
                        : Container(),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        setState(() => isResetLoading = true);
                        if (resetLoginSuccessful &&
                            resetPasswordController.text ==
                                resetPasswordConfirmController.text) {
                          await NewPassword()
                              .ping(idUser, resetPasswordController.text)
                              .then((value) {
                            setState(() => isResetLoading = false);
                            if (value.statusCode == 202) {
                              Navigator.pop(context);
                              toastModal('Sucesso', 'Senha redefinida', 1500,
                                  Colors.green, Icons.check);
                            }
                          });
                        } else {
                          setState(() => isResetLoading = true);
                          LoginResponse loginRes = LoginResponse();
                          await loginRes
                              .ping(emailController.text,
                                  resetCodeController.text)
                              .then((value) {
                            setState(() => isResetLoading = false);
                            if (value.statusCode == 202) {
                              idUser = jsonDecode(utf8.decode(value.bodyBytes))[
                                      'id_usuario']
                                  .toString();
                              setState(() {
                                resetLoginSuccessful = true;
                              });
                            }
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        width: 350,
                        color: AppColors.blue,
                        child: Center(
                          child: isResetLoading == true
                              ? const CircularProgressIndicator()
                              : const Text("Enviar",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
