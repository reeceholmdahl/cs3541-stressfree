import 'package:firstapp/journal/journal.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';

class sideDrawerLeft extends StatelessWidget {

  const sideDrawerLeft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(

            decoration: BoxDecoration(

              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                image: NetworkImage('https://cdn.sixtyandme.com/wp-content/uploads/2020/12/iStock-848645812-scaled.jpg'),
                fit: BoxFit.cover,
              ),

              //color: Colors.blue,
              //alignment: Alignment.center,
            ),

            child: Text(
              ' ',
              style: const TextStyle(
                fontSize: 45,
              ),
            ),
            margin: EdgeInsets.all(0),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const homePage()));
            },
          ),
          ListTile(
            title: const Text('Self Care Journal'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const journal()));
            },
          ),
          ListTile(
            title: const Text('Stress Release Videos'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Stress Management Techniques'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Self Care Ideas'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('More Soothing Music'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}