import 'package:flutter/material.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/profile/components/manager_button.dart';
import 'package:netflix/src/features/profile/components/profile_widget.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.get<ProfileController>().start();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
    final colorController = context.watch<ColorController>();

    final backgroundColor = colorController.currentScheme.darkBackgroundColor;

    double width = MediaQuery.of(context).size.width;

    final headline3 = AppFonts().headline3;

    final labelLarge = AppFonts().labelLarge;

    final selectedlabelLarge =
        labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    List<Widget> profiles = [];
    for (int i = 0; i < profileController.profiles.length; i++) {
      profiles.add(Padding(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: ProfileWidget(
          selectedStyle: selectedlabelLarge,
          unselectedStyle: labelLarge,
          icon: profileController.profiles[i].icon,
          name: profileController.profiles[i].name,
          index: i,
        ),
      ));
    }

    return Scaffold(
      body: Stack(children: [
        // Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: backgroundColor,
        ),
        //
        // Logo
        //
        Padding(
          padding: const EdgeInsets.only(left: 55, top: 21),
          child: SizedBox(
              width: width * 0.07,
              child: Image.asset('assets/images/logo.png')),
        ),
        //
        // Center Part
        //
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Quem está assistindo?',
                style: headline3,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: profiles,
              ),
              const SizedBox(
                height: 80,
              ),
              //
              // Gerenciar Perfis
              //
              ManagerButton(
                selectedStyle:
                    selectedlabelLarge.copyWith(fontWeight: FontWeight.normal),
                unselectedStyle: labelLarge,
              )
            ],
          ),
        )
      ]),
    );
  }
}
