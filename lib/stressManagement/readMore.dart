
import 'package:firstapp/stressManagement/techniquesData/techniques.dart';
import 'package:flutter/material.dart';
import 'techniquesData/techniques.dart';


class readMore extends StatelessWidget {
  final Technique technique;
  readMore({Key? key, required this.technique}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 120.0),
        Icon(
          Icons.wysiwyg,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          technique.title,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(40.0),
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 255, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      technique.content,
      style: TextStyle(fontSize: 18.0),
    );
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}