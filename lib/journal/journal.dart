import 'package:firstapp/drawer.dart';
import 'package:flutter/material.dart';

class journal extends StatelessWidget {
  const journal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Self Care Journal';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        drawer: sideDrawerLeft(),
        body: const journalArea(),
      ),
    );
  }
}

class journalArea extends StatelessWidget {
  const journalArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: Center(
              child: Row(
                children: <Widget>[
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.red,
                    highlightedBorderColor: Colors.red,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.red
                    ),
                    child: Icon(Icons.assignment_ind_outlined),
                    onPressed: () { },
                  ),
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.amber,
                    highlightedBorderColor: Colors.amber,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.amber
                    ),
                    onPressed: () { },
                    child: Text('2'),
                  ),
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.lime,
                    highlightedBorderColor: Colors.lime,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.lime
                    ),
                    onPressed: () { },
                    child: Text('3'),
                  ),
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.green,
                    highlightedBorderColor: Colors.green,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.green
                    ),
                    onPressed: () { },
                    child: Text('4'),
                  ),
                ],
              ),
            ),
        ),
        Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 20,
                decoration: InputDecoration.collapsed(
                    hintText: "Write about your day here!",
                ),
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Center(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    fixedSize: const Size(180, 60),
                  ),
                  child: Text(
                    'Save',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    //implement later
                  },
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}