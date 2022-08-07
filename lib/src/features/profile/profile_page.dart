import 'package:flutter/material.dart';
import 'package:netflix/src/features/profile/components/manager_button.dart';
import 'package:netflix/src/features/profile/components/profile_widget.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileController>(context, listen: false).start();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();

    double width = MediaQuery.of(context).size.width;

    final headline3 = Theme.of(context).textTheme.headline3!.copyWith(
        color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Arial');

    final labelLarge = Theme.of(context)
        .textTheme
        .labelLarge!
        .copyWith(color: Colors.grey, fontSize: 16, fontFamily: 'Arial');

    final selectedlabelLarge =
        labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    List<Widget> profiles = [];
    for (int i = 0; i < profileController.profiles.length; i++) {
      profiles.add(ProfileWidget(
        selectedStyle: selectedlabelLarge,
        unselectedStyle: labelLarge,
        icon: profileController.profiles[i].icon,
        name: profileController.profiles[i].name,
      ));
    }

    return Stack(children: [
      // Background
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey.shade900,
      ),
      //
      // Logo
      //
      Padding(
        padding: const EdgeInsets.only(left: 55, top: 21),
        child: SizedBox(
            width: width * 0.07, child: Image.asset('assets/images/logo.png')),
      ),
      //
      // Center Part
      //
      Center(
        child: Column(
          children: [
            const SizedBox(
              height: 130,
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
              height: 70,
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
    ]);
  }
}
