import 'package:flutter/material.dart';
import '../model/readable.dart';

class PastJournal extends StatelessWidget {
  final Readable readable;

  PastJournal({Key? key, required this.readable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 60.0),
        Icon(
          readable.icon,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          readable.title,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ],
    );

    final topContent = Container(
      padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
      decoration: BoxDecoration(color: readable.color),
      child: Center(
        child: topContentText,
      ),
    );

    final bottomContentText = Text(
      readable.content,
      style: TextStyle(fontSize: 18.0),
    );
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: [bottomContentText],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Past Journal Entry')),
      body: Column(
        children: [topContent, bottomContent],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
