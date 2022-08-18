import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/src/features/home/components/appbar/hover_widget.dart';
import 'package:netflix/src/features/home/components/appbar/top_button.dart';

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

    final child = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 50, top: 10),
        child: SizedBox(
            width: width * 0.075, child: Image.asset('assets/images/logo.png')),
      ),
      const SizedBox(
        width: 30,
      ),
      for (var item in buttonLabels)
        TopButton(
            selectedStyle: selectedlabelLarge,
            unselectedStyle: labelLarge,
            name: item),
      SizedBox(
        width: (width - 940),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      const SizedBox(width: 10),
      TopButton(
          selectedStyle: selectedlabelLarge,
          unselectedStyle: labelLarge,
          name: 'Infantil'),
      const SizedBox(
        width: 10,
      ),
      const HoverWidget(
        icon: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
      ),
    ]);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: widget.preferredSize.height,
      color: homeAppBarController.isAtTop
          ? Colors.transparent
          : Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: child,
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
