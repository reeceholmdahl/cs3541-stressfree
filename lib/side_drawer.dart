import 'package:firstapp/journal/journal.dart';
import 'package:firstapp/main.dart';
import 'package:firstapp/stress_management/stress_management.dart';
import 'package:firstapp/youtube_stress.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/self_care/self_care.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(201, 189, 182, 10),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://cdn.sixtyandme.com/wp-content/uploads/2020/12/iStock-848645812-scaled.jpg'),
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
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          ),
          ListTile(
            title: const Text('Self Care Journal'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DailyJournal()));
            },
          ),
          ListTile(
            title: const Text('Stress Release Videos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const YoutubeStressPage()));
            },
          ),
          ListTile(
            title: const Text('Stress Management Techniques'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StressManagement()));
            },
          ),
          ListTile(
            title: const Text('Self Care Ideas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const SelfCare()));
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
