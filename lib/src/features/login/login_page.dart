import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/smooth_scroll.dart';
import 'package:netflix/src/features/login/components/custom_text_field.dart';
import 'package:netflix/src/features/login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _lembrar = true;
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    const double textFieldWidth = 315;

    final scrollController = ScrollController();

    final loginController = context.watch<LoginController>();

    final headline4 = Theme.of(context).textTheme.headline4!.copyWith(
        color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Arial');

    final headline6 = Theme.of(context)
        .textTheme
        .headline6!
        .copyWith(color: Colors.white, fontSize: 17);

    final labelLarge = Theme.of(context)
        .textTheme
        .labelLarge!
        .copyWith(color: Colors.grey, fontSize: 16, fontFamily: 'Arial');

    final labelBig =
        labelLarge.copyWith(fontSize: 17, fontWeight: FontWeight.normal);

    final labelIntermedium =
        labelLarge.copyWith(fontSize: 13, fontWeight: FontWeight.normal);

    final labelMedium =
        Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey);

    return Scaffold(
        body: Scrollbar(
      controller: scrollController,
      child: SmoothScroll(
        scrollSpeed: 90,
        scrollAnimationLength: 150,
        curve: Curves.decelerate,
        controller: scrollController,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          child: Stack(
            children: [
              // Background
              Padding(
                padding: const EdgeInsets.all(0),
                child: Image.asset('assets/images/login_background.jpg',
                    width: width * 0.991,
                    fit: BoxFit.contain,
                    color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.darken),
              ),
              //
              // Gradient
              //
              Container(
                width: width,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0)
                      ]),
                ),
              ),
              //
              // Logo
              //
              Padding(
                padding: const EdgeInsets.only(left: 35, top: 21),
                child: SizedBox(
                    width: width * 0.13,
                    child: Image.asset('assets/images/logo.png')),
              ),
              //
              // Login Card
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 90,
                      ),
                      Container(
                        width: 450,
                        height: height * 1.08,
                        color: Colors.black.withOpacity(0.75),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60, left: 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              // Texto Entrar
                              //
                              Text(
                                'Entrar',
                                style: headline4,
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              //
                              // Textfield Email
                              //
                              CustomTextField(
                                textFieldWidth: textFieldWidth,
                                textStyle: labelLarge,
                                text: 'Email ou número de telefone',
                                controller: email,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              //
                              // Textfield Senha
                              //
                              CustomTextField(
                                textFieldWidth: textFieldWidth,
                                textStyle: labelLarge,
                                text: 'Senha',
                                controller: senha,
                                isPassword: true,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              //
                              // Botao Entrar
                              //
                              loginController.isLogged
                                  ? Container(
                                      width: 313,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color:
                                            const Color.fromARGB(255, 228, 0, 0)
                                                .withOpacity(0.5),
                                      ),
                                      child: Center(
                                          child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      )),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (loginController.canLog()) {
                                          loginController.login();
                                          await Future.delayed(
                                                  const Duration(seconds: 2))
                                              .then((value) =>
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          '/profile'));
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                loginController.canLog()
                                                    ? const Color.fromARGB(
                                                        255, 228, 0, 0)
                                                    : const Color.fromARGB(
                                                        255, 190, 0, 0)),
                                      ),
                                      child: SizedBox(
                                        width: textFieldWidth - 35,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 13),
                                          child: Text(
                                            'Entrar',
                                            style: headline6,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              //
                              // Lembre-se
                              //
                              SizedBox(
                                width: textFieldWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 25,
                                          child: IconButton(
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              setState(() {
                                                _lembrar = !_lembrar;
                                              });
                                            },
                                            icon: Icon(
                                              _lembrar
                                                  ? Icons.check_box
                                                  : Icons
                                                      .check_box_outline_blank,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Lembre-se de mim',
                                          style: labelMedium,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Precisa de ajuda?',
                                      style: labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              //
                              // Textos
                              //
                              RichText(
                                text: TextSpan(
                                  text: 'Novo por aqui? ',
                                  style: labelLarge,
                                  children: const <TextSpan>[
                                    TextSpan(text: '''Assine agora.
      
      ''', style: TextStyle(color: Colors.white)),
                                    TextSpan(
                                        text:
                                            '''Esta página é protegida pelo Google reCAPTCHA 
      para garantir que você não é um robô. ''',
                                        style: TextStyle(fontSize: 13)),
                                    TextSpan(
                                        text: 'Saiba mais.',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.blue))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height,
                    width: 20,
                  ),
                ],
              ),
              //
              // Infos
              //
              Positioned(
                top: height * 1.37,
                child: Container(
                  color: Colors.black.withOpacity(0.75),
                  width: width * 0.99,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 170),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dúvidas? Ligue 0800 591 8942',
                            style: labelBig,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Perguntas frequentes',
                                  style: labelIntermedium,
                                ),
                                Text(
                                  'Central de Ajuda',
                                  style: labelIntermedium,
                                ),
                                Text(
                                  'Termos de Uso',
                                  style: labelIntermedium,
                                ),
                                Text(
                                  'Privacidade',
                                  style: labelIntermedium,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Preferências de cookies',
                                  style: labelIntermedium,
                                ),
                                SizedBox(
                                  width: width * 0.098,
                                ),
                                Text(
                                  'Informações corporativas',
                                  style: labelIntermedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                              width: 140,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade800,
                                  ),
                                  color: Colors.black),
                              child: Row(children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 12, top: 1),
                                  child: Icon(
                                    Icons.language,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                DropdownButton<Text>(
                                    underline: Container(),
                                    items: [
                                      DropdownMenuItem<Text>(
                                          child: Text(
                                        'Portugues',
                                        style: labelMedium,
                                      ))
                                    ],
                                    onChanged: (v) {})
                              ]))
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
