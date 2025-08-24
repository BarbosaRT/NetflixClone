import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:netflix/core/app_consts.dart';
import 'package:netflix/core/colors/color_controller.dart';
import 'package:netflix/core/fonts/app_fonts.dart';
import 'package:netflix/core/video/get_impl.dart';
import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/models/content_model.dart';
import 'package:netflix/src/features/home/components/content_list/components/content_button.dart';
import 'package:netflix/src/features/home/components/content_list/components/like_button.dart';
import 'package:netflix/src/features/home/components/content_list/content_inner_widget.dart';
import 'package:netflix/src/features/home/home_page.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ContentContainer extends StatefulWidget {
  final ContentContainerAnchor anchor;
  final String id;
  final int localIndex;
  final ContentModel content;
  final Function(int) onHover;
  final Function(bool value) onPlay;
  final Function(ContentModel content)? onDetail;
  final Function()? onExit;
  final double containerWidth; // Calculated container width
  const ContentContainer({
    super.key,
    required this.anchor,
    required this.localIndex,
    required this.onHover,
    required this.id,
    this.onExit,
    this.onDetail,
    required this.content,
    required this.onPlay,
    required this.containerWidth,
  });

  @override
  State<ContentContainer> createState() => _ContentContainerState();
}

class _ContentContainerState extends State<ContentContainer> {
  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeInOut;
  static const delay = Duration(milliseconds: 400);
  static const trailerDelay = Duration(milliseconds: 3000);
  //static const double realWidth = 325;
  double width = 245;
  //It is here to help with the text that get outside of the container
  static const double rightPadding = 10;
  double height = 132;
  static const double factor = 1.45;

  double infoHeight = 566;
  static const double border = 5;
  static const double hoverBorder = 10;

  bool isHover = false;
  bool hover = false;
  ValueNotifier<bool> added = ValueNotifier(false);

  VideoInterface? videoController;
  GestureDetector? button;

  void callback() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // Use the calculated container width
    width = widget.containerWidth;
  }

  double getValueFromAnchor() {
    switch (widget.anchor) {
      case ContentContainerAnchor.left:
        return 0;
      case ContentContainerAnchor.center:
        return -(width * factor - width) / 2;
      case ContentContainerAnchor.right:
        return -(width * factor - width);
    }
  }

  void onExit() {
    videoController?.seek(Duration.zero);
    if (widget.onExit != null) {
      widget.onExit!();
    }
    isHover = false;
    widget.onPlay(false);
    if (mounted) {
      setState(() {
        hover = false;
        videoController?.enableFrame(false);
        videoController?.pause();
      });
    }
  }

  void onHover() {
    isHover = true;
    widget.onHover(widget.localIndex);
    Future.delayed(delay).then((value) {
      if (!isHover) {
        return;
      }
      if (mounted) {
        setState(() {
          hover = true;
        });
      }

      widget.onPlay(true);

      if (videoController.runtimeType != GetImpl().getImpl().runtimeType) {
        videoController = GetImpl()
            .getImpl(id: myGlobals.random.nextInt(69420), isOnline: true);
        videoController?.init(widget.content.trailer,
            w: width * factor,
            h: height * factor,
            callback: callback,
            isOnline: widget.content.isOnline);
        videoController?.defineThumbnail(
            widget.content.poster, widget.content.isOnline);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(trailerDelay).then((value) {
          if (!isHover) {
            return;
          }
          startTrailer();
        });
      });
    });
  }

  void startTrailer() {
    if (mounted) {
      setState(() {
        videoController?.isPlaying(enable: true);
        videoController?.enableFrame(true);
        videoController?.play();
        videoController?.setVolume(1);
        videoController?.enableFrame(true);
      });
    }
  }

  void onClick() {
    if (widget.content.hasDetailPage && widget.content.episodes != {}) {
      if (widget.onDetail != null) {
        widget.onDetail!(widget.content);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final headline = AppFonts().headline7;
    final headline6 = AppFonts().headline6;
    //final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.width;
    final colorController = Modular.get<ColorController>();
    final backgroundColor = colorController.currentScheme.containerColor;
    final bool playing = videoController?.isPlaying() ?? false;

    //final double scale = (screenWidth / 1366).clamp(0.9, 1.07);
    // Update width with the calculated container width
    width = widget.containerWidth;
    // Calculate height to maintain 16:9 aspect ratio
    height = width / (16.0 / 9.0);
    infoHeight = width * factor - height * factor;

    final decoration = BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(border)),
      //color: Colors.red,
      image: DecorationImage(
        image: AppConsts()
            .getImage(widget.content.poster, widget.content.isOnline),
        fit: BoxFit.cover,
      ),
    );

    final movieDecoraion = BoxDecoration(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(hoverBorder),
        topLeft: Radius.circular(hoverBorder),
      ),
      //color: Colors.blue,
      image: DecorationImage(
        image: AppConsts()
            .getImage(widget.content.poster, widget.content.isOnline),
        fit: BoxFit.cover,
      ),
    );

    const infoContainer = BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(hoverBorder),
        bottomLeft: Radius.circular(hoverBorder),
      ),
    );

    final usedRightPadding =
        widget.anchor == ContentContainerAnchor.right ? 0 : rightPadding;

    return AnimatedContainer(
      curve: curve,
      duration: duration,
      //
      height: hover ? height * factor + infoHeight : height * factor,
      //
      width: hover ? width * factor : width,
      //
      transform: Matrix4.translation(
        vector.Vector3(hover ? getValueFromAnchor() : 0, hover ? 20 : 140, 0),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          //
          // Content Container
          //
          AnimatedContainer(
            curve: curve,
            duration: duration,
            width: hover ? width * factor - usedRightPadding : width,
            height: hover ? height * factor : height,
            decoration: hover ? movieDecoraion : decoration,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  AnimatedContainer(
                    curve: curve,
                    duration: duration,
                    height: hover ? height * factor : height,
                    width: hover ? width * factor : width,
                    child: videoController?.frame(),
                  ),
                  playing && hover
                      ? Container(
                          height: height * factor - 10,
                          width: width * factor - 8,
                          alignment: Alignment.bottomRight,
                          child: VolumeButton(
                            scale: 8 / 7,
                            videoController: videoController,
                            iconOn: Icons.volume_up,
                            iconOff: Icons.volume_off,
                          ),
                        )
                      : Container(),
                  widget.content.onlyOnNetflix
                      ? Positioned(
                          top: 5,
                          left: 10,
                          child: Image.asset(
                            'assets/images/icon.png',
                            width: 15,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          //
          // Info Container
          //
          AnimatedPositioned(
            curve: curve,
            duration: duration,
            top: hover ? height * factor - 52 : height,
            child: AnimatedOpacity(
              duration: duration,
              curve: curve,
              opacity: hover ? 1 : 0,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  AnimatedContainer(
                    duration: duration,
                    margin: EdgeInsets.only(top: hover ? 50 : 0),
                    width: hover ? width * factor - usedRightPadding : width,
                    height: infoHeight,
                    decoration: infoContainer.copyWith(
                      color: backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: backgroundColor,
                          spreadRadius: 1,
                          blurRadius: 6,
                        )
                      ],
                    ),
                  ),
                  //
                  // Icons
                  //
                  AnimatedContainer(
                    duration: duration,
                    curve: curve,
                    margin: EdgeInsets.only(
                      right: hover ? 0 : width,
                    ),
                    width: hover
                        ? width * factor // +100 for the texts
                        : width,
                    height: 200,
                    child: Stack(
                      children: [
                        //
                        // Play
                        //
                        Positioned(
                          left: 15,
                          top: 70,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              onClick();
                            },
                            icon: const Icon(
                              Icons.play_circle,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        //
                        // Add to list
                        //
                        Positioned(
                          top: 2,
                          left: -43,
                          child: ContentButton(
                              onClick: () {
                                added.value = !added.value;
                                startTrailer();
                              },
                              text: ValueListenableBuilder(
                                valueListenable: added,
                                builder:
                                    (BuildContext context, bool value, child) {
                                  return Text(
                                    value
                                        ? 'Remover da lista'
                                        : 'Adicionar à lista',
                                    textAlign: TextAlign.center,
                                    style: headline6.copyWith(
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                              icon: ValueListenableBuilder(
                                valueListenable: added,
                                builder:
                                    (BuildContext context, bool value, child) {
                                  return Icon(
                                    value ? Icons.done : Icons.add,
                                    size: 25,
                                    color: Colors.white,
                                  );
                                },
                              )),
                        ),
                        //
                        // Like
                        //
                        const Positioned(
                          top: 2,
                          left: -40,
                          child: LikeButton(),
                        ),
                        //
                        // Mais Informações
                        //
                        Positioned(
                          top: 2,
                          left: width * factor - 170,
                          child: ContentButton(
                            rightPadding:
                                widget.anchor == ContentContainerAnchor.right
                                    ? 37
                                    : 35,
                            text: Text(
                              'Mais Informações',
                              textAlign: TextAlign.center,
                              style: headline6.copyWith(color: Colors.black),
                            ),
                            onClick: () {
                              onClick();
                            },
                            icon: const Icon(
                              Icons.expand_more_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  // Infos
                  //
                  Positioned(
                    left: 15,
                    top: 130,
                    child: SizedBox(
                      width: width * factor,
                      child: Row(
                        children: [
                          Text(
                            '${widget.content.rating}% relevante',
                            style: headline.copyWith(color: Colors.green),
                          ),
                          const SizedBox(width: 8),
                          //
                          Image.asset(
                            AppConsts.classifications[widget.content.age] ??
                                'assets/images/classifications/L.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.content.detail,
                            style: headline,
                          ),
                          const SizedBox(width: 5),
                          Container(
                            height: 25,
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: Colors.transparent),
                            child: Center(
                              child: Text(
                                'HD',
                                style: headline.copyWith(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  // Tags
                  //
                  Positioned(
                    left: 15,
                    top: 170,
                    child: SizedBox(
                      width: width * factor,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0;
                                i <= widget.content.tags.length - 2;
                                i++)
                              Row(
                                children: [
                                  Text(
                                    widget.content.tags[i],
                                    style: headline,
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            //
                            //
                            Text(
                              widget
                                  .content.tags[widget.content.tags.length - 1],
                              style: headline,
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //
          // Mouse Region
          //
          AnimatedPositioned(
            duration: duration,
            curve: curve,
            child: MouseRegion(
              opaque: false,
              onEnter: (event) {
                onHover();
              },
              onHover: (v) {
                onHover();
              },
              //
              //
              onExit: (event) {
                onExit();
              },
              child: Container(
                  //
                  height: hover
                      ? height * factor + infoHeight
                      : height * factor - 60,
                  //
                  width: hover ? width * factor : width,
                  //
                  color: Colors.yellow.withValues(alpha: 0.0)),
            ),
          ),
        ],
      ),
    );
  }
}
