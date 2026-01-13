import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oldflix/core/colors/color_controller.dart';
import 'package:oldflix/src/features/login/login_controller.dart';

class CustomTextField extends StatefulWidget {
  final double textFieldWidth;
  final TextStyle textStyle;
  final String text;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.textFieldWidth,
    required this.textStyle,
    required this.text,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode inputFocusNode;

  bool selected = false;
  bool isOccult = false;

  @override
  void initState() {
    super.initState();
    isOccult = widget.isPassword;
    inputFocusNode = FocusNode();
    inputFocusNode.addListener(() {
      isSelected();
    });
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
  }

  void isSelected() {
    setState(() {
      selected = (inputFocusNode.hasFocus || widget.controller.text != '');
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleInput = widget.textStyle.copyWith(color: Colors.white);

    final loginController = context.watch<LoginController>();
    final colorController = Modular.get<ColorController>();
    final Color textFieldColor =
        colorController.currentScheme.loginTextFieldColor;

    return Container(
      width: widget.textFieldWidth,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: textFieldColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: selected ? 15 : 0, left: 7),
        child: Row(
          children: [
            SizedBox(
              width: widget.textFieldWidth - (widget.isPassword ? 110 : 20),
              child: TextField(
                onTap: (() {
                  isSelected();
                }),
                onChanged: ((value) {
                  widget.isPassword
                      ? loginController.changeSenha(value)
                      : loginController.changeEmail(value);
                }),
                focusNode: inputFocusNode,
                controller: widget.controller,
                obscureText: isOccult,
                style: textStyleInput,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textFieldColor,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  label: Text(
                    widget.text,
                    style: widget.textStyle,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  isCollapsed: true,
                ),
              ),
            ),
            if (widget.isPassword && selected)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextButton(
                  onPressed: () {
                    setState(() => inputFocusNode.requestFocus());
                    isOccult = !isOccult;
                  },
                  child: Text(isOccult ? 'MOSTRAR' : 'OCULTAR',
                      style: widget.textStyle),
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
