import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/appbar/top_button.dart';
import 'package:netflix/src/features/profile/controllers/profile_controller.dart';

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
  int currentOn = 0;

  HoverNotification? hoverNotification;
  NotificationBar? notificationBar;
  ProfileIcon? profileIcon;

  @override
  void initState() {
    start(context);
    hoverNotification = Modular.get<HoverNotification>();
    notificationBar = NotificationBar(onHover: () {
      onHover(0);
    });
    profileIcon = ProfileIcon(onHover: () {
      onHover(1);
    });
    super.initState();
  }

  void onHover(int c) {
    if (c != currentOn) {
      switch (currentOn) {
        case 1:
          hoverNotification!.notify(true, 0);
          break;
        case 0:
          hoverNotification!.notify(true, 1);
          break;
      }
      currentOn = c;
    }
  }

  void start(BuildContext c) {
    if (started) {
      return;
    }
    final homeAppBarController = Modular.get<HomeAppBarController>();

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
        left: width * 0.605,
        child: notificationBar!,
      ),
      //
      // Profiles
      //
      Positioned(
        left: width * 0.639,
        child: profileIcon!,
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
  final void Function() onHover;

  const ProfileIcon({super.key, required this.onHover});

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  bool _hover = false;
  bool _isHover = false;

  static const duration = Duration(milliseconds: 400);
  static const durationOut = Duration(milliseconds: 300);
  Duration currentfadeDuration = const Duration(milliseconds: 50);
  static const fadeDuration = Duration(milliseconds: 50);
  static const width = 215.0;
  static const height = 340.0;

  HoverNotification? hoverNotification;

  @override
  void initState() {
    super.initState();
    hoverNotification = Modular.get<HoverNotification>();
    hoverNotification!.addListener(() {
      if (hoverNotification!.hoverOff[0]) {
        hoverOff();
      }
    });
  }

  void hoverOff() {
    currentfadeDuration = const Duration(seconds: 0);
    _isHover = false;
    setState(() {
      _hover = false;
    });
    hoverNotification!.notify(false, 0);
  }

  void onExit() {
    _isHover = false;
    Future.delayed(durationOut).then(
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
    widget.onHover();
    currentfadeDuration = Duration(milliseconds: fadeDuration.inMilliseconds);
    _isHover = true;
    setState(() {
      _hover = true;
    });
  }

  Widget iconWidget(BuildContext context) {
    final profileController = Modular.get<ProfileController>();
    profileController.start();
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
              width: 32,
              height: 30,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Image.asset(
                  profileController.profiles[profileController.selected].icon,
                  fit: BoxFit.fill),
            ),
            AnimatedRotation(
              turns: _hover ? 0 : 0.5,
              duration: duration,
              child: const Icon(Icons.arrow_drop_up,
                  size: 25, color: Colors.white),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Modular.get<ProfileController>();

    final options = ['Gerenciar Perfis', 'Conta', 'Central de Ajuda'];
    const optionsWidgets = [
      Icon(Icons.edit, color: Colors.white),
      Icon(Icons.person_off_outlined, color: Colors.white),
      Icon(Icons.help_center_outlined, color: Colors.white),
    ];

    final List<Widget> items = [];
    for (int i = 0; i < profileController.profiles.length; i++) {
      if (i == profileController.selected) {
        continue;
      }
      items.add(ProfileButton(
        width: width,
        picture: Image.asset(
          profileController.profiles[i].icon,
          fit: BoxFit.fill,
        ),
        text: profileController.profiles[i].name,
      ));
    }
    for (int i = 0; i < options.length; i++) {
      items.add(ProfileButton(
        width: width,
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
        width: width - 20,
        height: 20,
        child: const Icon(Icons.arrow_drop_up, size: 30, color: Colors.white),
      ),
      Container(
          margin: const EdgeInsets.only(top: 17),
          width: width + 1,
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
                      width: width,
                      color: Colors.grey.withOpacity(0.2))),
              const Positioned(
                top: 300,
                child: ProfileButton(
                  showPicture: false,
                  width: width,
                  picture: null,
                  text: 'Sair da Netflix',
                ),
              )
            ],
          )),
    ]);

    final widget = SizedBox(
      height: 1000,
      width: 420,
      child: Stack(alignment: Alignment.topRight, children: [
        Positioned(
          left: 420 - 50,
          child: MouseRegion(
            opaque: false,
            onExit: (event) {
              onExit();
            },
            onHover: (v) {
              onHover();
            },
            child: icon,
          ),
        ),
        _hover
            ? Positioned(
                top: 30,
                child: MouseRegion(
                  onExit: (event) {
                    onExit();
                  },
                  onHover: (v) {
                    onHover();
                  },
                  child: AnimatedOpacity(
                    opacity: _hover ? 1 : 0,
                    duration: currentfadeDuration,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: child,
                    ),
                  ),
                ),
              )
            : Container(),
      ]),
    );
    return widget;
  }
}

class ProfileButton extends StatefulWidget {
  final bool showPicture;
  final double width;
  final Widget? picture;
  final String text;
  const ProfileButton(
      {super.key,
      this.showPicture = true,
      required this.width,
      required this.picture,
      required this.text});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool _hover = false;
  bool _isHover = false;

  static const delayOut = Duration(milliseconds: 50);

  void onExit() {
    _isHover = false;
    Future.delayed(delayOut).then((value) {
      if (_isHover) {
        return;
      }
      if (mounted) {
        setState(() {
          _hover = false;
        });
      }
    });
  }

  void onHover() {
    _isHover = true;
    setState(() {
      _hover = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(widget.text,
        style: GoogleFonts.robotoFlex(
          textStyle: TextStyle(
            decoration: _hover ? TextDecoration.underline : TextDecoration.none,
            decorationThickness: 1,
            color: Colors.white,
          ),
        ));

    return MouseRegion(
      opaque: false,
      onExit: (event) {
        onExit();
      },
      onHover: (v) {
        onHover();
      },
      child: SizedBox(
        height: 40,
        width: widget.width,
        child: widget.showPicture
            ? Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 9),
                child: Row(
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: widget.picture),
                    const SizedBox(
                      width: 10,
                    ),
                    text,
                  ],
                ),
              )
            : Center(
                child: text,
              ),
      ),
    );
  }
}

class NotificationBar extends StatelessWidget {
  final void Function() onHover;
  const NotificationBar({super.key, required this.onHover});

  static const double containerHeight = 330;
  static final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      onHover: onHover,
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
            child:
                const Icon(Icons.arrow_drop_up, size: 30, color: Colors.white),
          ),
          Container(
              margin: const EdgeInsets.only(top: 17),
              width: 401,
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(0.6),
                border: const Border(
                    left: BorderSide(width: 1.0, color: Colors.white),
                    top: BorderSide(width: 2.0, color: Colors.white)),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                      width: 12, height: containerHeight, color: Colors.white),
                  SizedBox(
                    height: containerHeight + 70,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          for (int i = 0; i < 15; i++)
                            NotificationContainer(
                              title: 'Novidade',
                              subtitle: 'Como Seria se...?',
                              icon: Container(
                                height: 120,
                                width: 100,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Colors.purple,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class NotificationContainer extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  const NotificationContainer(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {
  bool _hover = false;

  void onExit() {
    setState(() {
      _hover = false;
    });
  }

  void onHover() {
    setState(() {
      _hover = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: _hover ? FontWeight.bold : FontWeight.normal,
    );

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
            margin: const EdgeInsets.only(bottom: 2),
            width: 387,
            height: 100,
            color: Colors.black.withOpacity(_hover ? 0.8 : 0.6),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 120,
                    height: 100,
                    child: widget.icon,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 160,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: textStyle,
                        ),
                        Text(
                          widget.subtitle,
                          style: textStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'há 2 dias',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
    );
  }
}
