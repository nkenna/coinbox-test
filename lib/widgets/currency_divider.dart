import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget currencyDivider(){
  return  SizedBox(
    height: 44,
    width: double.infinity,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Divider(
            height: 0,
            color: const Color(0xffE7E7EE),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xff26278D),
              shape: BoxShape.circle
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/images/up_down.svg'),
          )
        ),
      ],
    ),
  );
}