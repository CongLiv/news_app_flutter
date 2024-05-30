import 'package:flutter/cupertino.dart';
import '../helpers/const_data.dart';

class TitleName extends StatelessWidget {
  TitleName({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'FS Magistral',
        color: redViettel,
        fontSize: 23,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}