import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  final textController = TextEditingController();
  final  databaseRef = FirebaseDatabase.instance.ref('Messages');
  //final ref = FirebaseDatabase.instance.ref();



/*
  Pull data from the database child "Messages" and returns the values fetched.
 */
  Future<String> pullData() async
  {

    DatabaseReference ref = FirebaseDatabase.instance.ref('Messages');
    DatabaseEvent event = await ref.once();

    return (event.snapshot.value.toString());

  }
  /*
  Awaits the data to be pulled from pullData() and prints to the console.
   */

  Future<void> fetchData () async
  {
    var data =  await pullData();
    print(data);
  }

  void addData(String data) {
    databaseRef.push().set({'Name': data, 'Date': DateTime.now().toString()});
  }



  @override
  Widget build(BuildContext context) {
    //printFirebase();
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Demo"),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 200.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textController,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                        children: <Widget>[
                          RaisedButton(
                              color: Colors.pinkAccent,
                              child: Text("Save to Database"),
                              onPressed: () {
                                addData(textController.text);
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Test'),
                                      content: const Text('Test successful!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],

                                    )
                                );
                                //call method flutter upload
                              }
                          ),
                          RaisedButton(
                              color: Colors.pinkAccent,
                              child: Text("Pull From DB"),
                              onPressed: () {
                                fetchData();
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Pull test'),
                                      content:  Text("null"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],

                                    )
                                );
                                //call method flutter upload
                              }
                          )
                        ]
                    )

                  ],
                ),
              );
            }
          }
      ),
    );
  }
}