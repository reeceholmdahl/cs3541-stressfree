import 'package:flutter/material.dart';

import 'package:firstapp/constants.dart';
import 'package:firstapp/side_drawer.dart';
import 'package:firstapp/model/technique.dart';

import 'read_more.dart';

class StressManagement extends StatelessWidget {
  const StressManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Stress Management Techniques';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      resizeToAvoidBottomInset: false,
      drawer: SideDrawer(),
      body: ListPage(),
    );
  }
}

class ListPage extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);

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
                    builder: (context) => ReadMore(technique: technique)));
          },
        );

    Card makeCard(Technique technique) => Card(
          color: Colors.transparent,
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFFA28F84),
                borderRadius: BorderRadius.circular(8)),
            child: makeListTile(technique),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: TechniquesList.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(TechniquesList[index]);
        },
      ),
    );

    return Scaffold(
      body: makeBody,
      resizeToAvoidBottomInset: false,
    );
  }
}
