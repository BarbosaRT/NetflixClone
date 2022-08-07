import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  final ScrollController scrollController;
  const HomeAppBar({
    super.key,
    required this.child,
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
    start();

    super.initState();
  }

  void start() {
    if (started) {
      return;
    }
    final homeAppBarController = context.read<HomeAppBarController>();

    widget.scrollController.addListener(() {
      homeAppBarController.putAtTop(widget.scrollController.offset < 10);
    });

    started = true;
  }

  @override
  Widget build(BuildContext context) {
    final homeAppBarController = context.watch<HomeAppBarController>();
    start();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: widget.preferredSize.height,
      color: homeAppBarController.isAtTop
          ? Colors.transparent
          : Colors.grey.shade900,
      alignment: Alignment.center,
      child: widget.child,
    );
  }
}

class HomeAppBarController extends ChangeNotifier {
  bool _isAtTop = false;
  bool get isAtTop => _isAtTop;

  void putAtTop(bool value) {
    _isAtTop = value;
    notifyListeners();
  }
}
