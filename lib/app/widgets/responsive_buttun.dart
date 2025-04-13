import 'package:flutter/material.dart';


class ResponsiveButton extends StatelessWidget {

  final VoidCallback onPressed;
  final double? buttonWidth;
  final double? buttonHeight;
  final bool clickable;
  final ButtonStyle ?buttonStyle;
  final BoxDecoration? boxDecoration;

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? child;

  const ResponsiveButton(
      {
        required this.onPressed,
        super.key,
         this.buttonWidth,
         this.buttonHeight,
        required this.clickable,
        this.buttonStyle,
        this.boxDecoration,
        this.padding, this.margin, this.child
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: buttonWidth,
      height: buttonHeight,
      decoration: boxDecoration,
      padding: padding,




      child: ElevatedButton(

        style: buttonStyle,
        onPressed: (clickable == true) ? onPressed : null,
        child:child,
        ),

    );
  }
}
