import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/api/content_controller.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/content_list/content_list_widget.dart';
import 'package:netflix/src/features/home/home_page.dart';

enum ContentListAnchor { top, middle, bottom }

class ListContentController extends ChangeNotifier {
  final List<int> _pages = List.generate(36, (index) => 1);

  void setPage(int index, int page) {
    _pages[index] = page;
    notifyListeners();
  }

  int getPage(int index) {
    return _pages[index];
  }
}

class ListContents extends StatefulWidget {
  final void Function(ContentModel content) onDetail;
  final void Function(String content) onSeeMore;
  final void Function(bool value) onPlay;
  const ListContents(
      {super.key,
      required this.onSeeMore,
      required this.onPlay,
      required this.onDetail});

  @override
  State<ListContents> createState() => ListContentsState();
}

class ListContentsState extends State<ListContents> {
  static const Duration duration = Duration(milliseconds: 300);
  static double spacing = 220.0;
  int current = 0;
  List<Widget> widgets = [];
  List<Widget> oldWidgets = [];
  HomePages currentPage = HomePages.inicio;

  static const List<String> titles = [
    'Outsiders',
    'Em Alta',
    'Top 10 no Brasil',
    'Só na Netflix',
    'Séries de ação',
    'Filmes para toda a familia',
    'Assistir Novamente',
    'Assistir Novamente',
    'Assistir Novamente',
    'Produções de Hollywood',
    'Comédia',
    'Populares na Netflix',
    'Mundos épicos',
    'Porque você viu Click',
    'Porque você viu Breaking Bad',
    'Dicas para você',
    'Para maratonar',
    'Futuro distopico',
    'Elas dominam a tela',
    'Principais escolhas para você',
    'Filmes Empolgantes',
    'Minha Lista',
    'Novelas',
    'Para assistir juntos: crianças mais velhas',
    'Comédias teen',
    'Recém adicionados',
    'Séries sobre o crime',
    'Filmes de ação',
    'Produções Estrangeiras',
    'Programas de ação',
    'Dramas adolescentes',
    'Lançamentos',
    'Estrelas da semana',
    'Ação e aventura',
  ];
  static const totalListCount = 12;
  static const listSize = totalListCount ~/ 3;

  @override
  void initState() {
    final controller = Modular.get<ContentController>();
    controller.init();
    super.initState();
    widgetBuilder();
  }

  ContentListAnchor getAnchorFromValue(int index) {
    switch (index) {
      case 0:
        return ContentListAnchor.top;
      case const (listSize - 1):
        return ContentListAnchor.bottom;
      default:
        return ContentListAnchor.middle;
    }
  }

  final Map<HomePages, int> homePages = {
    HomePages.inicio: 0,
    HomePages.series: 1,
    HomePages.filmes: 2
  };

  List<List<Widget>> loadedPages = [];

  void rebuild(HomePages page) {
    currentPage = page;
    widgets = loadedPages[homePages[currentPage] ?? 0];
    oldWidgets = widgets.toList();
    setState(() {});
  }

  void widgetBuilder() {
    for (int p = 0; p <= 3; p++) {
      widgets = [];
      for (int j = listSize - 1; j >= 0; j--) {
        int i = j * 3 + p;
        if (i >= titles.length) {
          i = titles.length - 1;
        }
        widgets.add(
          Positioned(
            key: UniqueKey(),
            top: spacing * j,
            left: 0,
            right: 0,
            child: ContentListWidget(
              key: UniqueKey(),
              index: j,
              title: titles[i],
              anchor: getAnchorFromValue(i),
              horizontalPadding: 100.0, // Use 100px padding for home page
              onHover: () {
                onHover(j);
              },
              onPlay: widget.onPlay,
              onSeeMore: widget.onSeeMore,
              onDetail: widget.onDetail,
            ),
          ),
        );
      }
      loadedPages.add(widgets.toList());
    }
    rebuild(currentPage);
  }

  void onHover(int index) {
    if (current == index) {
      return;
    }
    current = index;
    switch (getAnchorFromValue(index)) {
      case ContentListAnchor.middle:
        Future.delayed(duration).then((v) {
          //
          widgets = oldWidgets.toList();
          if (widgets.length - index < 0) {
            return;
          }
          Widget element = widgets[widgets.length - index];
          //
          widgets.removeAt(widgets.length - index);
          widgets.insert(widgets.length - index, element);

          if (mounted) {
            setState(() {});
          }
        });
        break;
      case ContentListAnchor.top:
        Future.delayed(duration).then((v) {
          if (mounted) {
            setState(() {
              widgets = oldWidgets.toList();
            });
          }
        });
        break;
      case ContentListAnchor.bottom:
        Future.delayed(duration).then((v) {
          if (mounted) {
            setState(() {
              widgets = oldWidgets.reversed.toList();
            });
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //final height = MediaQuery.of(context).size.height;

    // Adjust spacing based on screen width
    spacing = width < 600
        ? 180.0
        : width < 1200
            ? 200.0
            : 220.0;

    return SizedBox(
      width: width,
      height: 3000,
      child: Stack(
        children: widgets,
      ),
    );
  }
}
