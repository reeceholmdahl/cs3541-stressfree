/*
Allows for each tile to have an animation
when pressed.
*/
import 'package:flutter/material.dart';

class PressableCard extends StatefulWidget {
  const PressableCard({
    this.onPressed,
    required this.color,
    //required this.image,
    /*
    ********************************************
    * TODO: Impliment image background on tiles*
    * ******************************************
    */
    required this.flattenAnimation,
    this.child,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Color color;
  //final var image;
  final Animation<double> flattenAnimation;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _PressableCardState();
}

/*
From Book
*/
class _PressableCardState extends State<PressableCard>
    with SingleTickerProviderStateMixin {
  bool pressed = false;
  late final AnimationController controller;
  late final Animation<double> elevationAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
    );
    elevationAnimation =
        controller.drive(CurveTween(curve: Curves.easeInOutCubic));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double get flatten => 1 - widget.flattenAnimation.value;

  @override
  Widget build(context) {
    return Listener(
      onPointerDown: (details) {
        if (widget.onPressed != null) {
          controller.forward();
        }
      },
      onPointerUp: (details) {
        controller.reverse();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.onPressed?.call();
        },
        child: AnimatedBuilder(
          animation:
              Listenable.merge([elevationAnimation, widget.flattenAnimation]),
          child: widget.child,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 - elevationAnimation.value * 0.03,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16) *
                        flatten,
                child: PhysicalModel(
                  elevation:
                      ((1 - elevationAnimation.value * 0.75) * 20) * flatten,
                  borderRadius: BorderRadius.circular(60 * flatten),
                  clipBehavior: Clip.antiAlias,
                  color: widget.color,
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
