import 'package:firstapp/home/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'clickDirector.dart';

class homeTab extends StatefulWidget {

  static const title = 'Home';

  const homeTab({Key? key, this.sideDrawer}) : super(key: key);
  final Widget? sideDrawer;

  @override
  homeTabState createState() => homeTabState();

}

class homeTabState extends State<homeTab> {
  static const tabsLength = 6;
  late List<String> tileNames = homePageItemsList;
  late List<Color> colors = colorsForTiles;
  //late List<String> images = imagesForTiles;

  Widget itemBuilder(BuildContext context, int index) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Hero(
          tag: index,
          child: tile(
            name: tileNames[index],
            color: colors[index],
            //image: images[index],
            transitionAnimation: const AlwaysStoppedAnimation(0),
            onPressed: () =>
                Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (context) => clickDirector(
                          id: index,
                        ),
                  ), // Where the click will lead you. Implement from here
                ),
          ),
        ),
    );
  }

  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: widget.sideDrawer,
      body: ListView.builder(
            itemCount: homePageItemsList.length,
            itemBuilder: itemBuilder,
        ),
      persistentFooterButtons: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(Icons.pause),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}



/*
Allows for each tile to have an animation
when pressed.
*/
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
  //final String image;
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
                  ((1 - elevationAnimation.value) * 20) * flatten,
                  borderRadius: BorderRadius.circular(120 * flatten),
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

/*
Used for creation of each tile
*/
class tile extends StatelessWidget {


  const tile({
    required this.name,
    required this.color,
    //required this.image,
    required this.transitionAnimation,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String name;
  final Color color;
  //final String image;
  final VoidCallback? onPressed;
  final Animation<double> transitionAnimation; //not going to use, but can do later


  @override
  Widget build(context) {
    return AnimatedBuilder(
      animation: transitionAnimation,
      builder: (context, child) {
        return PressableCard(
          onPressed: transitionAnimation.value == 0 ? onPressed : null,
          //image: image,
          color: color,
          flattenAnimation: transitionAnimation,
          child: SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -80 * transitionAnimation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.black12,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



