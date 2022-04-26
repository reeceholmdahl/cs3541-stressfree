import 'package:firstapp/self_care/favorite_tips.dart';
import 'package:firstapp/self_care/tips_list.dart';
import 'package:firstapp/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/self_care/idea.dart';

class SelfCare extends StatelessWidget {
  const SelfCare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Self Care'),
          backgroundColor: Color(0xff41544e),
        ),
        drawer: SideDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteTips()),
            );
          },
          backgroundColor: Color(0xff9f1818),
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
            itemCount: allIdeas.length + 1,
            itemBuilder: (context, index) {
              if (index == allIdeas.length)
                return Column(
                    key: Key("blank"), children: [SizedBox(height: 70)]);
              Idea idea = allIdeas[index];
              return Card(
                child: ListTile(
                  tileColor: Color(0xffefeae7),
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
                    color: idea.isFavorited ? Color(0xff9f1818) : Colors.grey,
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
