import 'dart:core';

import 'package:firstapp/Music/music.dart';
import 'package:firstapp/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

<<<<<<< HEAD
import 'alarm/alarms.dart';
import 'Informatics/informatics.dart';
import 'planner/planner.dart';
import 'pressable_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF19201E),
    ),
  );
  runApp(Home());
}

ThemeData makeTheme(BuildContext context) {
  final theme = Theme.of(context);
  return ThemeData.from(
          colorScheme: theme.colorScheme, textTheme: theme.textTheme)
      .copyWith(
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: Color(0xFF41544E))),
          dialogBackgroundColor: Color(0xFFEFEAE7),
          brightness: Brightness.light,
          primaryColor: Color(0xFF41545E),
          canvasColor: Color(0xFFC4CBC0),
          cardColor: Color(0xFFEFEAE7),
          colorScheme: ColorScheme.light(secondary: Color(0xFF78645A)),
          scaffoldBackgroundColor: Color(0xFFC9BDB6),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              foregroundColor: Color(0xFFEFEAE7),
              backgroundColor: Color(0xFF78645A)),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF41544E),
          ));
=======
import 'Informatics/Informatics.dart';
import 'home/home.dart';
import 'Alarms/alarm.dart';
import 'testBed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(homePage());
>>>>>>> a329cbfe442af7339bc3043d43bc26833701a4bf
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = makeTheme(context);
    return MaterialApp(
      title: 'Stress Free',
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        drawer: SideDrawer(),
        body: Builder(builder: (context) {
          return ListView(
            children: [
              PageCard(
                name: 'Tip of the Day',
                color: Theme.of(context).canvasColor,
                onPressed: () {},
              ),
<<<<<<< HEAD
              PageCard(
                name: 'Planner',
                color: Theme.of(context).canvasColor,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => Planner(),
                  ),
                ),
              ),
              PageCard(
                name: 'Informatics',
                color: Theme.of(context).canvasColor,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => Informatics(),
                  ),
                ),
              ),
              PageCard(
                name: 'Alarms',
                color: Theme.of(context).canvasColor,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => Alarms(),
                  ),
                ),
              ),
              PageCard(
                name: 'Soothing Music',
                color: Theme.of(context).canvasColor,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => SoothingMusic(),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
=======
              body: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Text("StressFree!",style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green), textScaleFactor: 4,)
                      ,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green
                      ),
                      child: Text('TestBed'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return TestPage();
                        }));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red
                      ),
                      child: Text('Home'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return homePage();
                        }));
                      },
                    ),
                  ],
                )
              ),
            )
        )
>>>>>>> a329cbfe442af7339bc3043d43bc26833701a4bf
    );
  }
}

<<<<<<< HEAD
/*
Used for creation of each tile
*/
class PageCard extends StatelessWidget {
  const PageCard({
    required this.name,
    required this.color,
    // required this.transitionAnimation,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String name;
  final Color color;
  final VoidCallback? onPressed;
  final Animation<double> transitionAnimation =
      const AlwaysStoppedAnimation(0); //not going to use, but can do later

  @override
  Widget build(context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: AnimatedBuilder(
        animation: transitionAnimation,
        builder: (context, child) {
          return PressableCard(
            onPressed: transitionAnimation.value == 0 ? onPressed : null,
            //image: image,
            color: color,
            flattenAnimation: transitionAnimation,
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -80 * transitionAnimation.value,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
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
      ),
    );
  }
}
=======
>>>>>>> a329cbfe442af7339bc3043d43bc26833701a4bf
