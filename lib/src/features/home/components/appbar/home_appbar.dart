import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/appbar/top_button.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final ScrollController scrollController;
  const HomeAppBar({
    super.key,
    this.height = kToolbarHeight,
    required this.scrollController,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool started = false;

  @override
  void initState() {
    start(context);

    super.initState();
  }

  void start(BuildContext c) {
    if (started) {
      return;
    }
    final homeAppBarController = c.read<HomeAppBarController>();

    widget.scrollController.addListener(() {
      homeAppBarController.putAtTop(widget.scrollController.offset < 10);
    });

    started = false;
  }

  @override
  Widget build(BuildContext context) {
    final homeAppBarController = context.watch<HomeAppBarController>();
    start(context);

    final buttonLabels = [
      'Inicio',
      'Séries',
      'Filmes',
      'Bombando',
      'Minha lista',
      'Navegar Por Idiomas'
    ];

    final labelLarge = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Colors.grey.shade200,
          fontSize: 14,
          fontFamily: 'Roboto-Medium',
        );

    double width = MediaQuery.of(context).size.width;
    final selectedlabelLarge =
        labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    final child = Stack(children: [
      Positioned(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //
          // Logo
          //
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 10),
            child: SizedBox(
                width: width * 0.075,
                child: Image.asset('assets/images/logo.png')),
          ),
          const SizedBox(
            width: 27,
          ),
          //
          // Central Buttons
          //
          for (var item in buttonLabels)
            TopButton(
                selectedStyle: selectedlabelLarge,
                unselectedStyle: labelLarge,
                name: item),
        ]),
      ),
      //
      // Search
      //
      Positioned(
        top: 10,
        left: width * 0.8,
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      //
      // Infantil
      //
      Positioned(
        left: width * 0.826,
        child: TopButton(
            selectedStyle: selectedlabelLarge,
            unselectedStyle: labelLarge,
            name: 'Infantil'),
      ),
      //
      // Notifications
      //
      Positioned(
        left: width * 0.62,
        child: HoverWidget(
          icon: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomRight,
                width: 400,
                height: 20,
                child: const Icon(Icons.arrow_drop_up,
                    size: 30, color: Colors.white),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 17),
                  width: 401,
                  height: 501,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600.withOpacity(0.5),
                    border: const Border(
                        bottom: BorderSide(width: 1.0, color: Colors.white),
                        left: BorderSide(width: 1.0, color: Colors.white),
                        top: BorderSide(width: 2.0, color: Colors.white)),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(width: 12, height: 500, color: Colors.white),
                      SizedBox(
                        height: 400,
                        child: ListView(
                          children: [
                            for (int i = 0; i < 15; i++)
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 387,
                                    height: 100,
                                    color:
                                        Colors.grey.shade900.withOpacity(0.5),
                                    child: Center(
                                      child: Text(
                                        i.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      //
      // Profiles
      //
      Positioned(
        left: width * 0.65,
        child: HoverWidget(
          maxWidth: 420,
          rightPadding: 50,
          icon: const Padding(
              padding: EdgeInsets.only(top: 10), child: ProfileIcon()),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomRight,
                width: 400,
                height: 20,
                child: const Icon(Icons.arrow_drop_up,
                    size: 30, color: Colors.white),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 17),
                  width: 401,
                  height: 501,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600.withOpacity(0.5),
                    border: const Border(
                        bottom: BorderSide(width: 1.0, color: Colors.white),
                        left: BorderSide(width: 1.0, color: Colors.white),
                        top: BorderSide(width: 2.0, color: Colors.white)),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(width: 12, height: 500, color: Colors.white),
                      SizedBox(
                        height: 400,
                        child: ListView(
                          children: [
                            for (int i = 0; i < 15; i++)
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 387,
                                    height: 100,
                                    color:
                                        Colors.grey.shade900.withOpacity(0.5),
                                    child: Center(
                                      child: Text(
                                        i.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    ]);

    return SizedBox(
      width: width,
      height: widget.preferredSize.height,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 70,
            color: homeAppBarController.isAtTop
                ? Colors.transparent
                : Colors.grey.shade900,
          ),
          SizedBox(
            width: width,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeAppBarController extends ChangeNotifier {
  bool _isAtTop = true;
  bool get isAtTop => _isAtTop;

  void putAtTop(bool value) {
    _isAtTop = value;
    notifyListeners();
  }
}

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({super.key});

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  bool _hover = false;
  bool _isHover = false;

  static const duration = Duration(milliseconds: 500);

  void onExit() {
    _isHover = false;
    Future.delayed(const Duration(milliseconds: 50)).then(
      (value) {
        if (_isHover) {
          return;
        }
        setState(() {
          _hover = false;
        });
      },
    );
  }

  void onHover() {
    _isHover = true;
    setState(() {
      _hover = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onExit: (v) {
          onExit();
        },
        onHover: (v) {
          onHover();
        },
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 5,
            ),
            AnimatedRotation(
              turns: _hover ? 0.75 : 0.25,
              duration: duration,
              child: const Icon(Icons.arrow_forward_ios,
                  size: 15, color: Colors.white),
            ),
          ],
        ));
  }
}
