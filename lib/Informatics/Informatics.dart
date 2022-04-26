import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firstapp/data/mood.dart';
import 'package:pie_chart/pie_chart.dart';

import '../drawer.dart';

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
      home: HomePage(),
    );
  }
}

enum LegendShape { Circle, Rectangle }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataMap = <String, double>{
    "Great": 5,
    "Good": 3,
    "Medium": 2,
    "Bad": 2,
  };

  Future<String> pullData() async {
    final ref = FirebaseDatabase.instance.ref('Planner');
    DatabaseEvent event = await ref.once();

    String myString = event.snapshot.value.toString();

    return myString;
    //return event.snapshot.children.first.toString();
  }


  String insertChar(String endString, int pos, String toInsert) {
    endString = endString.substring(0, pos + 1) +
        toInsert +
        endString.substring(pos + 1);
    return endString;
  }

  static String skipOver(String endString, int pos, int newPos) {
    endString =
        endString.substring(0, pos + 1) + endString.substring(newPos + 1);
    return endString;
  }

  final colorList = <Color>[
    (Mood.moods["great"]!.color),
    Mood.moods["good"]!.color,
    Mood.moods["medium"]!.color,
    Mood.moods["bad"]!.color,
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
          return Wrap(children: [
            AlertDialog(
              title: Text(title),
              content: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "When you felt " + title + " you",
                  ),
                  Container(
                      height: 200,
                      width: 200,
                      child: ListView.builder(
                          itemCount: activityList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(activityList.elementAt(index),);
                          }))
                ],
              ),
              actions: <Widget>[],
            )
          ]);
        }); //showDialog
  }
  @override
  Widget build(BuildContext context) {


    @override
    void initState() {
      super.initState();
    }

    //do action, maybe not needed for this application

    //final dataMap = readDataFromFile();

    return Scaffold(
        drawer: sideDrawerLeft(),
        appBar: AppBar(
          title: const Text('Informatics'),
        ),
        body: FutureBuilder(
            future: pullData(),
            builder: (context, AsyncSnapshot<String> snapshot) {
              return Container(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      child: PieChart(
                        key: ValueKey(key),
                        dataMap: getDataMap(snapshot.toString()),
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: _chartLegendSpacing!,
                        chartRadius: math.min(
                            MediaQuery.of(context).size.width / 2, 400),
                        colorList: colorList,
                        initialAngleInDegree: 0,
                        chartType: _chartType!,

                        // legendLabels: _showLegendLabel ? legendLabels : {},

                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: _showChartValueBackground,
                          showChartValues: _showChartValues,
                          showChartValuesInPercentage:
                          _showChartValuesInPercentage,
                          showChartValuesOutside: _showChartValuesOutside,
                        ),
                        ringStrokeWidth: _ringStrokeWidth!,
                        emptyColor: Colors.grey,
                      ),
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
                                MaterialStateProperty.all<Color>(
                                    colorList.elementAt(index)),
                              ),
                              onPressed: () {
                                for (int i = 0; i < dataMap.length; ++i) {
                                  if (index == i) {
                                    print(index);
                                    buildNewPopup(
                                        context,
                                        dataMap.keys.elementAt(index), //fix this
                                        generateMoodActivityLists(snapshot.toString())
                                            .elementAt(i)); //very inefficient
                                  }
                                }
                              },
                              child: Center(
                                  child:
                                  Text('${dataMap.keys.elementAt(index)}')),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }));
  }

  Map<String, double> getDataMap(String myString) {
    int numOfGood = 0;
    int numOfBad = 0;
    int numOfGreat = 0;
    int numOfMedium = 0;

    numOfGood = countInstance(myString, "Good");
    numOfBad = countInstance(myString, "Bad");
    numOfGreat = countInstance(myString, "Great");
    numOfMedium = countInstance(myString, "Medium");

    return <String, double>{
      "Great": numOfGreat.toDouble(),
      "Good": numOfGood.toDouble(),
      "Medium": numOfMedium.toDouble(),
      "Bad": numOfBad.toDouble(),
    };
  }

  int countInstance(String data, String check) {
    int count = 0;

    for (int i = 0; i < data.length - check.length; ++i) {
      if (data.substring(i, i + check.length) == check) {
        count++;
      }
    }
    return count;
  }

  List<List<String>> generateMoodActivityLists(String data) {

    String theString = "";
    List<String> list1 = [];
    List<String> list2= [];
    List<String> list3= [];
    List<String> list4= [];

    print(data);


    int j = 0;


    for (int i = 0; i < data.length; ++i) {
      if (data[i] == '{') {
        while (data[i + j] != '}') {
          ++j;
          if (data[i + j] == '{') {

            j=0;
            break;
          }

        }

        // print(data[i+j]);
        if(data[i+j] == '}') {
           print(data.substring(i, i+j+1));

          for(int k=i; k < i+j+1; ++k) {
            if(data.substring(k, k+8) == "Activity") {
              theString = data.substring(k+10, i+j);



              if(data.substring(i, i+j+1).contains(": Great")) {
                if(!list1.contains(theString))
                  list1.add(theString);
              } else if(data.substring(i,  i+j+1).contains(": Good")) {
                if(!list2.contains(theString))
                  list2.add(theString);
              } else if(data.substring(i,  i+j+1).contains(": Medium")) {
                if(!list3.contains(theString))
                  list3.add(theString);
              }
              else if(data.substring(i,  i+j+1).contains(": Bad")) {
                if(!list4.contains(theString))
                  list4.add(theString);
              }

              break;
            }
          }

        }
        j=0;
      }
    }

    List<List<String>> returnList = [];
    returnList.add(list1);
    returnList.add(list2);
    returnList.add(list3);
    returnList.add(list4);

    return returnList;
  }
}
