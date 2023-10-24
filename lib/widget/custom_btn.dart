import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function()? onPressed;
  final double? borderRadius;
  final String? text;
  final Color? textColor;
  // final double? fontSize;
  // final FontWeight? fontWeight;
  const CustomButton({
    super.key,
    this.onPressed,
    this.borderRadius,
    this.text,
    this.textColor,
    // this.fontSize,
    // this.fontWeight
  });

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
    return SizedBox(
      width: Responsive.isDesktop(context) ? width * 0.13 : width * 0.16,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 3),
          ),
          padding: EdgeInsets.zero,
          fixedSize: Size(
              Responsive.isDesktop(context) ? width * 0.07 : width * 0.3,
              height * 0.05),
        ),
        child: Container(
          alignment: Alignment.center,
          // padding: const EdgeInsets.all(3),
          child: Text(
            maxLines: 1,
            widget.text.toString(),
            style: TextStyle(
              color: widget.textColor ?? Colors.black,
              fontSize:
                  Responsive.isDesktop(context) ? height * .018 : height * .012,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
