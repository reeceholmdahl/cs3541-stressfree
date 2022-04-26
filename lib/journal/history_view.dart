import 'package:firstapp/journal/past_journal.dart';
import 'package:flutter/material.dart';

import 'readable_data/readable.dart';
import 'readable_data/readable_list.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Journals'),
        // automaticallyImplyLeading: sfalse,
        // leading: new IconButton(
        //   icon: new Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      resizeToAvoidBottomInset: false,
      body: ListPage(),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tileColor: readable.color.shade400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Icon(readable.icon, color: Colors.white),
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
                    builder: (context) => PastJournal(readable: readable)));
          },
        );

    Card makeCard(Readable readable) => Card(
          color: Colors.transparent,
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: makeListTile(readable),
        );

    final makeBody = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: readable.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(readable[index]);
      },
    );

    return makeBody;
  }
}
