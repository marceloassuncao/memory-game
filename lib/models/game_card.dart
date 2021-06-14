import 'package:flutter/cupertino.dart';

class GameCard with ChangeNotifier {
  final int index;
  final int id;
  final String image;
  bool win;
  bool flipped;

  void flipCard() {
    flipped = !flipped;
    notifyListeners();
  }

  void winCard() {
    if (flipped) {
      win = true;
      notifyListeners();
    }
  }

  GameCard(
      {this.index,
      this.id,
      this.image,
      this.flipped = false,
      this.win = false});
}
