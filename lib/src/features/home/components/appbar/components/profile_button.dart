import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
