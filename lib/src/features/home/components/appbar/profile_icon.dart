import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oldflix/src/features/home/components/appbar/components/profile_button.dart';
import 'package:oldflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:oldflix/src/features/login/login_controller.dart';
import 'package:oldflix/src/features/profile/controllers/profile_controller.dart';

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({super.key});
  static const width = 215.0;
  static const iconWidth = 32.0;
  static const iconArrowSize = 25.0;

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  bool _hover = false;

  static const duration = Duration(milliseconds: 400);
  static const height = 340.0;

  void onHover() {
    if (mounted) {
      setState(() {
        _hover = true;
      });
    }
  }

  void onExit() {
    if (mounted) {
      setState(() {
        _hover = false;
      });
    }
  }

  Widget iconWidget(BuildContext context) {
    final profileController = Modular.get<ProfileController>();
    if (mounted) {
      profileController.start();
    }
    return Row(
      children: [
        Container(
          width: ProfileIcon.iconWidth,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: profileController.profiles.isNotEmpty
                ? DecorationImage(
                    image: AssetImage(
                      profileController
                          .profiles[profileController.selected].icon,
                    ),
                  )
                : null,
          ),
        ),
        AnimatedRotation(
          turns: _hover ? 0 : 0.5,
          duration: duration,
          child: const Icon(Icons.arrow_drop_up,
              size: ProfileIcon.iconArrowSize, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Modular.get<ProfileController>();
    final loginController = Modular.get<LoginController>();

    final options = ['Gerenciar Perfis', 'Conta', 'Central de Ajuda'];
    const optionsWidgets = [
      Icon(Icons.edit, color: Colors.white),
      Icon(Icons.person, color: Colors.white),
      Icon(Icons.help_center_outlined, color: Colors.white),
    ];

    final List<Widget> items = [];
    for (int i = 0; i < profileController.profiles.length; i++) {
      if (i == profileController.selected) {
        continue;
      }
      items.add(ProfileButton(
        onClick: () {
          profileController.select(i);
          Modular.to.pushNamed('/splash');
        },
        width: ProfileIcon.width,
        picture: Image.asset(
          profileController.profiles[i].icon,
          fit: BoxFit.fill,
        ),
        text: profileController.profiles[i].name,
      ));
    }
    for (int i = 0; i < options.length; i++) {
      items.add(ProfileButton(
        width: ProfileIcon.width,
        picture: optionsWidgets[i],
        text: options[i],
      ));
    }

    final icon = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: iconWidget(context),
    );

    final child = Stack(children: [
      Container(
        alignment: Alignment.bottomRight,
        width: ProfileIcon.width - 20,
        height: 20,
        child: const Icon(Icons.arrow_drop_up, size: 30, color: Colors.white),
      ),
      Container(
          margin: const EdgeInsets.only(top: 17),
          width: ProfileIcon.width + 1,
          height: height,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: SizedBox(
                  height: height,
                  child: Column(
                    children: items,
                  ),
                ),
              ),
              Positioned(
                  top: 300,
                  child: Container(
                      height: 4,
                      width: ProfileIcon.width,
                      color: Colors.grey.withValues(alpha: 0.2))),
              Positioned(
                top: 300,
                child: ProfileButton(
                  onClick: () {
                    loginController.changeLog(false);
                    Modular.to.pushNamed('/login');
                  },
                  showPicture: false,
                  width: ProfileIcon.width,
                  picture: null,
                  text: 'Sair da Oldflix',
                ),
              )
            ],
          )),
    ]);

    final widget = HoverWidget(
      rightPadding: 50,
      icon: icon,
      onHover: onHover,
      onExit: onExit,
      index: 1,
      child: child,
    );
    return widget;
  }
}
