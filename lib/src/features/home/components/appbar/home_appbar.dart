import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/appbar/profile_icon.dart';
import 'package:netflix/src/features/home/components/appbar/components/top_button.dart';

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

  @override
  void initState() {
    start(context);
    super.initState();
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

    final labelLarge = AppFonts().labelLarge;

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
        left: width * 0.606,
        child: const NotificationBar(),
      ),
      //
      // Profiles
      //
      Positioned(
        left: width * 0.653,
        child: const ProfileIcon(),
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
            width: width - 12,
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

class NotificationBar extends StatelessWidget {
  const NotificationBar({super.key});

  static const double containerHeight = 330;
  static final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
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
