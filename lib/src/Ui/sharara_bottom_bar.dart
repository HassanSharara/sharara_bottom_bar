import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sharara_bottom_bar/src/Controller/controller.dart';

class ShararaBottomBar extends StatelessWidget {
  const ShararaBottomBar({super.key,
    required this.controller
  });
  final ShararaBottomBarController controller;
  @override
  Widget build(BuildContext context) {
    return _ShararaBottomBar(
      controller:controller,
      size:MediaQuery.of(context).size,
    );
  }
}
class _ShararaBottomBar extends StatefulWidget {
  const _ShararaBottomBar({
    required this.controller,
    required this.size
  });
  final Size size;
  final ShararaBottomBarController controller;
  @override
  State<_ShararaBottomBar> createState() => __ShararaBottomBarState();
}
class __ShararaBottomBarState extends State<_ShararaBottomBar> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation animation;
  double get eachWidgetSize => widget.size.width  / items.length ;
  double get animationFactor => 1 / (items.length  );
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
     duration: widget.controller.duration,
      lowerBound:animationFactor
    );
    animation = CurvedAnimation(parent:_animationController, curve:
     widget.controller.curves
    );
    super.initState();
  }

  @override
  dispose(){
    _animationController.dispose();
    super.dispose();
  }

  int get index => widget.controller.index;
  List<ShararaBottomItem> get items => widget.controller.items;
  double get getWidgetDx{
    final double dx =  (index * eachWidgetSize) - (
    eachWidgetSize / 2);

    return dx;
  }
  double get animationFDx {
    return (index ) * (animationFactor);
  }
  _indexListener(){
    final TextDirection directionality = Directionality.of(context);
    final int index =
        directionality == TextDirection.ltr ?
        this.index + 1 :
        items.length - (this.index)
    ;
    final double animationTo = animationFactor * index;
    if(animationTo > _animationController.value){
      _animationController.animateTo(
          animationTo,
          duration:widget.controller.duration,
          curve:widget.controller.curves
      );
    }
    else{
      _animationController.animateBack(
          animationTo,
          duration:widget.controller.duration,
          curve:widget.controller.curves
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return
      ValueListenableBuilder(
          valueListenable:widget.controller.indexNotifier,
          builder:(BuildContext context,final int index,_){
            _indexListener();
           return Container(
              clipBehavior:Clip.none,
              height:widget.controller.height,
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context,constraints){
                      if(constraints.maxWidth>0){
                        widget.controller.bottomBarSize
                        = Size(
                            widget.controller.height,
                            constraints.maxWidth
                        );
                      }
                      return SizedBox.expand(
                          child:AnimatedBuilder(
                            animation: animation,
                            builder:(BuildContext context,_){
                              return  CurvePainterWidget(
                                controller:widget.controller,
                                animationValue:animation.value,
                                dx:_animationController.value * widget.size.width,
                                eachWidgetSize: eachWidgetSize,
                              );
                            },
                          )
                      );
                    },
                  ),
                  Row(
                    children: [
                      for(int i = 0; i<widget.controller.items.length;i++)
                        Builder(
                            builder: (context) {
                              final bool selected = index  == i;
                              final ShararaBottomItem item = widget.controller.items[i];
                              final child = !selected && widget.controller.nonActiveColor==null?
                              item.child:
                              ColorFiltered(colorFilter:ColorFilter.mode(
                                  selected?widget.controller.activeColor:
                                  widget.controller.nonActiveColor!
                                  , BlendMode.srcIn),
                                child:item.child,
                              );
                              return GestureDetector(
                                onTap:(){
                                  widget.controller.changePageTo(i);
                                  if(widget.controller.onPageChangedByTap!=null){
                                    widget.controller.onPageChangedByTap!(i);
                                  }
                                },
                                child: Container(
                                  decoration:const BoxDecoration(),
                                  height:widget.controller.height,
                                  width:eachWidgetSize,
                                  margin:const EdgeInsets.only(
                                      bottom:3
                                  ),
                                  child:Column(
                                    children: [
                                      Expanded(
                                        child: AnimatedContainer(
                                            margin:const EdgeInsets.all(2),
                                            decoration:BoxDecoration(
                                                shape:BoxShape.circle,
                                                color:selected?
                                                widget.controller.circleNotchBackgroundColor
                                                    :
                                                null
                                            ),
                                            padding:EdgeInsets
                                                .all(
                                                selected?
                                                6:
                                                20
                                            ),
                                            duration:widget.controller.duration,
                                            child:selected ?
                                            FittedBox(
                                              child:child,
                                            ):child),
                                      ),
                                      const SizedBox(height:3,),
                                      AnimatedContainer(
                                        duration:widget.controller.duration,
                                        height: selected ?20 : 15,
                                        width:eachWidgetSize,
                                        child:FittedBox(
                                            fit:BoxFit.contain,
                                            child: Text(item.label??"",
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),

                    ],
                  ),
                ],
              ),
            );
          });
  }
}

class CurvePainterWidget extends StatefulWidget {
  const CurvePainterWidget({super.key,
   required this.animationValue,
   required this.controller,
   required this.dx,
   required this.eachWidgetSize,

  });
  final ShararaBottomBarController controller;
  final double
  animationValue,
      eachWidgetSize,
      dx;
  @override
  State<CurvePainterWidget> createState() => _CurvePainterWidgetState();
}
class _CurvePainterWidgetState extends State<CurvePainterWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:CurvePainter(
        controller:widget.controller,
        animationValue:widget.animationValue,
        dx:widget.dx,
        eachWidgetSize:widget.eachWidgetSize
      ),
    );
  }
}

final class CurvePainter extends  CustomPainter {
  final double
      animationValue,
      eachWidgetSize,
      dx;
  final ShararaBottomBarController controller;
  double get curveSize => controller.curveRadiusSize;
  const CurvePainter({
    required this.animationValue,
    required this.dx,
    required this.eachWidgetSize,
    required this.controller,
    });
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final Paint shadowPaint = Paint()
    ..color = controller.shadowColor ?? Colors.blueGrey.withOpacity(0.3)
    ..maskFilter = const MaskFilter.blur(BlurStyle.outer,2);
    final Paint backgroundPaint = Paint();
    if(controller.backgroundColor!=null){
      backgroundPaint.color = controller.backgroundColor!;
    }

    path.moveTo(0,0);
    drawCurve(path,canvas,size);
    path.lineTo(size.width,size.height);
    path.lineTo(0,size.height);
    canvas.drawPath(path,backgroundPaint);
    canvas.drawPath(path,shadowPaint);
  }

  void drawCurve(
      final Path path,
      Canvas canvas, Size size,[final bool forTop = true]) {
    final Paint backgroundPaint = Paint();
    if(controller.backgroundColor!=null){
      backgroundPaint.color = controller.backgroundColor!;
    }
      path.lineTo(dx-eachWidgetSize, 0);
      path.quadraticBezierTo(
          dx - (eachWidgetSize/2),
          - curveSize,
           dx
          ,0) ;
      path.lineTo(size.width,0);
      canvas.drawPath(path,backgroundPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return true;
  }

}