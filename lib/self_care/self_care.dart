import 'package:firstapp/side_drawer.dart';
import 'package:flutter/material.dart';

import 'favorite_tips.dart';
import 'idea.dart';
import 'tips_list.dart';

class SelfCare extends StatelessWidget {
  const SelfCare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Self Care')),
        drawer: SideDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteTips()),
            );
          },
          backgroundColor: Colors.red,
          icon: Icon(Icons.favorite),
          label: Text("Favorites"),
        ),
        body: SelfCareIdeas());
  }
}

class SelfCareIdeas extends StatefulWidget {
  @override
  _SelfCareIdeasState createState() => _SelfCareIdeasState();
}

class _SelfCareIdeasState extends State<SelfCareIdeas> {
  List<Idea> allIdeas = TipLists.ideas;
  List<Idea> favorites = TipLists.favIdeas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: allIdeas.length,
            itemBuilder: (context, index) {
              Idea idea = allIdeas[index];

              return Card(
                child: ListTile(
                  onTap: () {},
                  title: Text(idea.what),
                  leading: CircleAvatar(
                    child: Icon(
                      idea.icon,
                      color: idea.iconColor,
                    ),
                    backgroundColor: idea.backgroundColor,
                  ),
                  trailing: IconButton(
                    icon: idea.isFavorited
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    color: idea.isFavorited ? Colors.red : Colors.grey,
                    onPressed: () {
                      setState(() {
                        idea.switchFavorited();
                      });
                      favoritePressed(index);
                    },
                  ),
                ),
              );
            }));
  }

  void favoritePressed(int idx) {
    if (TipLists.ideas[idx].isFavorited)
      TipLists.favIdeas.add(TipLists.ideas[idx]);
    else
      TipLists.favIdeas.remove(TipLists.ideas[idx]);
  }
}
