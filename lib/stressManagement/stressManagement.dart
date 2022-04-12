import 'package:firstapp/drawer.dart';
import 'package:flutter/material.dart';

import 'readMore.dart';
import 'techniquesData/techniques.dart';
import 'techniquesData/techniquesList.dart';

class stressManagement extends StatelessWidget {
  const stressManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Stress Management Techniques';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        resizeToAvoidBottomInset: false,
        drawer: sideDrawerLeft(),
        body: ListPage(),
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List techniques;

  @override
  void initState() {
    techniques = getTechniques();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Technique technique) => ListTile(
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.article_rounded, color: Colors.white),
      ),
      title: Text(
        technique.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => readMore(technique: technique)));
      },
    );

    Card makeCard(Technique technique) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 255, .9)),
        child: makeListTile(technique),
      ),
    );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: techniques.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(techniques[index]);
        },
      ),
    );


    return Scaffold(
      body: makeBody,
      resizeToAvoidBottomInset: false,
    );
  }
}





