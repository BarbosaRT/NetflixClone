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

    final buttonLabels = ['Bombando', 'Minha lista', 'Navegar Por Idiomas'];

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
          TopButton(
            selectedStyle: selectedlabelLarge,
            unselectedStyle: labelLarge,
            name: 'Inicio',
            onClick: () {},
          ),
          TopButton(
            selectedStyle: selectedlabelLarge,
            unselectedStyle: labelLarge,
            name: 'Séries',
            onClick: () {},
          ),
          TopButton(
            selectedStyle: selectedlabelLarge,
            unselectedStyle: labelLarge,
            name: 'Filmes',
            onClick: () {},
          ),
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

  static final notifications = [
    {
      'title': 'Novidade',
      'subtitle': 'Escola do Bem e do Mal',
      'detail': 'há 2 dias',
      'image': 'assets/images/notifications/escola_poster.jpg'
    },
    {
      'title': 'Assista Agora',
      'subtitle': 'El Camino',
      'detail': 'há 4 dias',
      'image': 'assets/images/notifications/el_camino_poster.jpg'
    },
    {
      'title': 'Novidade',
      'subtitle': 'Cuphead Show',
      'detail': 'há 1 semana',
      'image': 'assets/images/notifications/cuphead_poster.jpg'
    },
    {
      'title': 'Assista Agora',
      'subtitle': 'Temporada 3',
      'detail': 'há 2 semanas',
      'image': 'assets/images/notifications/sintonia_poster.jpg'
    },
    {
      'title': 'Novidade',
      'subtitle': 'Justiceiras',
      'detail': 'há 2 semanas',
      'image': 'assets/images/notifications/justiceiras_poster.jpg'
    },
    {
      'title': 'Assista Agora',
      'subtitle': 'Temporada 5',
      'detail': 'há 1 mês',
      'image': 'assets/images/notifications/cobra_kai_poster.jpg'
    },
    {
      'title': 'Novidade',
      'subtitle': 'The Witcher',
      'detail': 'há 2 meses',
      'image': 'assets/images/notifications/the_witcher_poster.jpg'
    },
  ];

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
                          for (int i = 0; i < notifications.length; i++)
                            NotificationContainer(
                              title: notifications[i]['title'] ?? 'Novidade',
                              subtitle: notifications[i]['subtitle'] ??
                                  'Escola do Bem e do Mal',
                              detail: notifications[i]['detail'] ?? 'há 2 dias',
                              icon: Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                        image: AssetImage(notifications[i]
                                                ['image'] ??
                                            'assets/images/notifications/escola_poster.jpg'))),
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
  final String detail;
  final Widget icon;
  const NotificationContainer(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.detail});

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
    final textStyle = AppFonts().headline7;
    final textStyle2 = AppFonts().labelIntermedium;

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
                    width: 10,
                  ),
                  SizedBox(
                    width: 180,
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
                        Text(
                          widget.detail,
                          style: textStyle2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
