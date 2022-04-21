import 'package:firstapp/drawer.dart';
import 'package:firstapp/journal/pastJournal.dart';
import 'package:firstapp/journal/readableData/readable.dart';
import 'package:firstapp/journal/readableData/readableList.dart';
import 'package:flutter/material.dart';


class historyView extends StatelessWidget {
  const historyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Stress Management Techniques';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        resizeToAvoidBottomInset: false,

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
  late List readable;

  @override
  void initState() {
    readable = getReadable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Readable readable) => ListTile(
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(readable.icon, color: Colors.white),
      ),
      title: Text(
        readable.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => pastJournal(readable: readable)));
      },
    );

    Card makeCard(Readable readable) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            color: readable.color,
            borderRadius: BorderRadius.circular(6),
            //backgroundBlendMode: Colors.fromRGBO(0, 0, 0, 0),
        ),
        child: makeListTile(readable),
      ),
    );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: readable.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(readable[index]);
        },
      ),
    );


    return Scaffold(
      body: makeBody,
      resizeToAvoidBottomInset: false,
    );
  }
}





