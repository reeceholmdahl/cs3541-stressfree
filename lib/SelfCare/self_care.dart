import 'package:firstapp/SelfCare/favorite_tips.dart';
import 'package:firstapp/SelfCare/TipLists.dart';
import 'package:firstapp/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SelfCarePage());
}

class SelfCarePage extends StatelessWidget {
  const SelfCarePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Self Care Ideas',
      home: SelfCare(),
    );
  }
}

class SelfCare extends StatelessWidget {
  const SelfCare({Key? key}) : super(key: key);

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
      appBar: AppBar(title: const Text('Self Care')),
      drawer: sideDrawerLeft(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteTips()),
          );
        },
        backgroundColor: Colors.red,
        icon: Icon(Icons.favorite),
        label: Text("Favorites"),
        ),
      body: SelfCareIdeas()
    );
  }
}

class SelfCareIdeas extends StatefulWidget {
  @override
  _SelfCareIdeasState createState() => _SelfCareIdeasState();
}

class _SelfCareIdeasState extends State<SelfCareIdeas> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView.builder(
        itemCount: TipLists.ideas.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              onTap: () {},
              title: Text(TipLists.ideas[index].what),
              leading: CircleAvatar(
                child: Icon(pickIcon(TipLists.ideas[index].type),
                  color: iconColor(TipLists.ideas[index].type),
                ),
                backgroundColor: pickColor(TipLists.ideas[index].type),
              ),
              trailing: IconButton(
                icon: TipLists.ideas[index].isFavorited ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                color: TipLists.ideas[index].isFavorited ? Colors.red : Colors.grey,
                onPressed: () {
                  setState(() {
                    TipLists.ideas[index].switchFavorited();
                  });
                  favoritePressed(index);
                },
              ),
            ),
          );
        }
      )
    );
  }

  Color? pickColor(String type){
    if(type == "1")
      return Colors.deepPurple[100];
    else if(type == "2")
      return Colors.lightGreen[100];
    else if(type == "3")
      return Colors.pink[100];
    else if(type == "4")
      return Colors.cyan[100];
    else
      return Colors.amber[100];
  }

  IconData pickIcon(String type) {
    if(type == "1")
      return Icons.accessibility_new;
    else if(type == "2")
      return Icons.anchor;
    else if(type == "3")
      return Icons.api;
    else if(type == "4")
      return Icons.airline_seat_individual_suite;
    else
      return Icons.wb_sunny;
  }

  Color iconColor(String type){
    if(type == "1")
      return Colors.deepPurple;
    else if(type == "2")
      return Colors.green;
    else if(type == "3")
      return Colors.pink;
    else if(type == "4")
      return Colors.cyan;
    else
      return Colors.orange;
  }

  void favoritePressed(int idx) {
    if(TipLists.ideas[idx].isFavorited)
      TipLists.favIdeas.add(TipLists.ideas[idx]);
    else
      TipLists.favIdeas.remove(TipLists.ideas[idx]);
  }

}