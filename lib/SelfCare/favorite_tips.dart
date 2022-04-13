import 'package:firstapp/SelfCare/self_care.dart';
import 'package:firstapp/SelfCare/TipLists.dart';
import 'package:firstapp/SelfCare/Idea.dart';
import 'package:firstapp/drawer.dart';
import 'package:flutter/material.dart';

class FavoriteTips extends StatelessWidget {
  const FavoriteTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: null,
          ),
        ],
      appBar: AppBar(title: const Text('Favorites')),
      drawer: sideDrawerLeft(),
      body: Favorites(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelfCare()),
          );
        },
        backgroundColor: Colors.grey,
        label: Text("All Ideas"),
        icon: Icon(Icons.arrow_back),
      )
    );
  }
}

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView.builder(
        onReorder: (int oldIdx, int newIdx) {
          setState(() {
            if (oldIdx < newIdx) {
              newIdx -= 1;
            }
            final Idea item = TipLists.favIdeas.removeAt(oldIdx);
            TipLists.favIdeas.insert(newIdx, item);
          });
        },
        itemCount: TipLists.favIdeas.length,
        itemBuilder: (context,index){
          return Card(
            child: ListTile(
              onTap: (){},
              title: Text(TipLists.favIdeas[index].what),
            ),
            key: Key('$index'),
          );
        }
      )

    );
  }
}

