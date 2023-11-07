import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function()? onPressed;
  final double? borderRadius;
  final String? text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  const CustomButton(
      {super.key,
      this.onPressed,
      this.borderRadius,
      this.text,
      this.textColor,
      this.fontSize,
      this.fontWeight});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return TextButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Colors.transparent;
          },
        ),
        splashFactory: NoSplash.splashFactory,
        shape: MaterialStateProperty.all<CircleBorder>(
          const CircleBorder(),
        ),
        fixedSize:
            MaterialStateProperty.resolveWith((states) => const Size(200, 200)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Colors.white;
          },
        ),
        // shape: const CircleBorder(),
        // padding: EdgeInsets.zero,
        // fixedSize: Size(
        //     Responsive.isDesktop(context) ? width * 0.2 : width * 0.3,
        //     height * 0.2),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                maxLines: 1,
                widget.text.toString(),
                style: TextStyle(
                  color: widget.textColor ?? Colors.black,
                  fontSize: widget.fontSize ?? 13,
                  fontWeight: widget.fontWeight ?? FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
