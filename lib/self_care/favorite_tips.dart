import 'package:firstapp/side_drawer.dart';
import 'package:flutter/material.dart';

import 'idea.dart';
import 'self_care.dart';
import 'tips_list.dart';

class FavoriteTips extends StatelessWidget {
  const FavoriteTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        drawer: SideDrawer(),
        body: Favorites(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelfCare()),
            );
          },
          label: Text("All Ideas"),
          icon: Icon(Icons.arrow_back),
        ));
  }
}

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Idea> allIdeas = TipLists.ideas;
  List<Idea> favorites = TipLists.favIdeas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ReorderableListView.builder(
      buildDefaultDragHandles: false,
      itemCount: favorites.length,
      onReorder: (int oldIdx, int newIdx) {
        setState(() {
          if (oldIdx < newIdx) newIdx -= 1;
          final Idea item = favorites.removeAt(oldIdx);
          favorites.insert(newIdx, item);
        });
      },
      itemBuilder: (context, index) {
        Idea idea = favorites[index];

        return Dismissible(
          key: Key(idea.what),
          onDismissed: (direction) {
            setState(() {
              int regListIdx = allIdeas.indexOf(idea);
              allIdeas[regListIdx].switchFavorited();
              favorites.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Removed from favorites")));
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text("Remove",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )),
          ),
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
              trailing: ReorderableDragStartListener(
                index: index,
                child: Icon(
                  Icons.view_headline,
                  color: Colors.blueGrey,
                ),
              )),
        );
      },
    ));
  }
}
