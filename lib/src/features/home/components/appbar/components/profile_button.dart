import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileButton extends StatefulWidget {
  final bool showPicture;
  final double width;
  final Widget? picture;
  final String text;
  final Alignment alignment;
  final Color textColor;
  final TextStyle? textStyle;
  final double height;
  final void Function()? onClick;
  final double underline;
  const ProfileButton(
      {super.key,
      this.showPicture = true,
      this.onClick,
      this.underline = 1,
      this.height = 40,
      this.alignment = Alignment.center,
      this.textColor = Colors.white,
      required this.width,
      this.picture,
      this.textStyle,
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
    final style = widget.textStyle ?? GoogleFonts.robotoFlex();

    final text = Text(widget.text,
        style: style.copyWith(
          decoration: _hover ? TextDecoration.underline : TextDecoration.none,
          decorationThickness: widget.underline,
          color: widget.textColor,
        ));

    return MouseRegion(
      opaque: false,
      onExit: (event) {
        onExit();
      },
      onHover: (v) {
        onHover();
      },
      child: GestureDetector(
        onTap: widget.onClick,
        child: SizedBox(
          height: widget.height,
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
              : Align(
                  alignment: widget.alignment,
                  child: text,
                ),
        ),
      ),
    );
  }
}
