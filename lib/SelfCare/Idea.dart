class Idea {

  late String what;
  late String type;
  late bool isFavorited;


  Idea(String what, String type) {
    this.what = what;
    this.type = type;
    this.isFavorited = false;
  }

  void switchFavorited() {
    isFavorited = !isFavorited;
  }

  String toString() {
    return what;
  }

}