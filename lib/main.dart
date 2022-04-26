import 'dart:core';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import 'Informatics/Informatics.dart';
import 'home/home.dart';
import 'Alarms/alarm.dart';
import 'testBed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(homePage());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("StressFree!"),
              ),
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
    );
  }
}

