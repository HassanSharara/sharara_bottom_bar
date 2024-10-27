
import 'package:flutter/material.dart';

class ShararaBottomBarController {
  ShararaBottomBarController(
  {
    this.nonActiveColor ,
    this.circleNotchBackgroundColor = Colors.blue,
    this.activeColor = Colors.white,
    this.backgroundColor ,
    this.onPageChangedByTap ,
    this.shadowColor ,
    this.items = const [],
    this.height = 70,
    this.duration = const Duration(milliseconds:500) ,
    this.bottomBarSize ,
    this.curves = Curves.linearToEaseOut ,
    final int initialIndex = 0,
    this.curveRadiusSize = 35 ,
    this.margin = const EdgeInsets.all(0)}
    ):
    indexNotifier = ValueNotifier(initialIndex)
  ;
  final Color activeColor,
   circleNotchBackgroundColor;
  Color? shadowColor,backgroundColor,nonActiveColor;
  final List<ShararaBottomItem> items ;
  Function(int)? onPageChangedByTap;
  final double height,curveRadiusSize;
  final Curve curves;
  final EdgeInsets margin;
  final Duration duration;
  Size? bottomBarSize;
  int get index => indexNotifier.value ;

  late final ValueNotifier<int> indexNotifier;

  changePageTo(final int index){
    if(this.index == index)return;
    indexNotifier.value = index ;
  }

  dispose(){
    indexNotifier.dispose();
  }
}

final class ShararaBottomItem {
  final Widget child;
  final String? label,badeString;
  const ShararaBottomItem({required this.child,this.label,
    this.nonActiveColor ,
    this.circleNotchBackgroundColor,
    this.activeColor ,
    this.badeString,
  });
  final Color? nonActiveColor,activeColor,
      circleNotchBackgroundColor
  ;
}
