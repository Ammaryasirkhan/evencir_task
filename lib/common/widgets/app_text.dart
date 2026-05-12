import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.size = 14,
    this.weight = FontWeight.w400,
    this.color = Colors.white,
    this.height,
    this.align,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final double size;
  final FontWeight weight;
  final Color color;
  final double? height;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: size.sp,
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}
