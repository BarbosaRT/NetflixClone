import 'package:flutter/material.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';
import 'package:netflix/src/features/splash/splash_controller.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileController>(context, listen: false).start();
      Provider.of<SplashController>(context, listen: false).startSplash(5);
    });

    var splashNotifier = context.read<SplashController>();
    splashNotifier.addListener(() {
      if (splashNotifier.splashState == SplashState.finished) {
        splashNotifier.waitSplash();
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final profileController = context.watch<ProfileController>();

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
      // Loading
      //
      Padding(
        padding: EdgeInsets.only(left: (width - 150) / 2, top: 80),
        child: const SizedBox(
          height: 200,
          width: 200,
          child: CircularProgressIndicator(
            strokeWidth: 8,
            color: Colors.red,
          ),
        ),
      ),
      //
      // Icon
      //
      Padding(
        padding: EdgeInsets.only(left: (width - 150) / 2, top: 80),
        child: SizedBox(
            height: 200,
            width: 200,
            child: Center(
              child: SizedBox(
                width: 75,
                child: Image.asset(profileController
                    .profiles[profileController.selected].icon),
              ),
            )),
      ),
    ]);
  }
}
