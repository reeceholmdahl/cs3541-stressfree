import 'dart:math' as math;
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pie_chart/pie_chart.dart';

class Informatics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pie Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: HomePage(storage: CounterStorage()),
    );
  }
}

enum LegendShape { Circle, Rectangle }

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataMap = <String, double>{
    "Happy": 5,
    "Mildly Happy": 3,
    "Mildly Sad": 2,
    "Sad": 2,
  };



  final colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
  ];

  ChartType? _chartType = ChartType.disc;
  bool _showCenterText = true;
  double? _ringStrokeWidth = 32;
  double? _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = false;
  bool _showLegendLabel = false;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  bool _showGradientColors = false;

  LegendShape? _legendShape = LegendShape.Circle;
  LegendPosition? _legendPosition = LegendPosition.right;

  int key = 0;

  buildNewPopup(BuildContext context, String title, List<String> activityList) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("When you were " + title + " you did ",),
                Container(
                    height: 200,
                    width: 200,
                    child: ListView.builder(
                        itemCount: activityList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(activityList.elementAt(index));
                        }))
              ],
            ),
            actions: <Widget>[],
          );
        }); //showDialog
  }

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];
    final List<String> activityList = <String>['A', 'B', 'C'];

    String myString = "";

    @override
    void initState() {
      super.initState();
      widget.storage.readCounter().then((String value) {
        setState(() {
          myString = value;
        });
      });
    }

    //do action, maybe not needed for this application

    Future<File> _incrementCounter(String value) {
      setState(() {
        myString = value;
      });

      // Write the variable as a string to the file.
      return widget.storage.writeCounter(myString);
    }

    //final dataMap = readDataFromFile();

    final chart = PieChart(
      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing!,
      chartRadius: math.min(MediaQuery.of(context).size.width / 2, 400),
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType!,

      // legendLabels: _showLegendLabel ? legendLabels : {},

      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth!,
      emptyColor: Colors.grey,
    );

    return Scaffold(
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
        appBar: AppBar(
          title: const Text('Sample Code'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 300,
                child: chart,
                margin: EdgeInsets.symmetric(
                  vertical: 32,
                ),
              ),
              Flexible(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: dataMap.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          for (int i = 0; i < dataMap.length; ++i) {
                            if (index == i) {
                              buildNewPopup(
                                  context,
                                  '${dataMap.keys.elementAt(index)}',
                                  activityList);
                            }
                          }
                        },
                        child: Center(
                            child: Text('${dataMap.keys.elementAt(index)}')),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}

//Map<String, double> readDataFromFile() {

//return null;
//}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "Problem";
    }
  }
}
