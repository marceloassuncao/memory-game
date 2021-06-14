import 'package:flutter/material.dart';
import 'package:memory_game/models/game_card.dart';
import 'package:memory_game/providers/game_state.dart';
import 'package:memory_game/widgets/cross_fade.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class GameTableCard extends StatefulWidget {
  final GameCard gameCard;
  GameTableCard(this.gameCard);

  @override
  _GameTableCardState createState() => _GameTableCardState();
}

class _GameTableCardState extends State<GameTableCard> {

  @override
  void dispose() {
    super.dispose();
  }

  get isFlipped => widget.gameCard.flipped;
  get isWin => widget.gameCard.win;

  GameState get gameState => Provider.of<GameState>(context);

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(isFlipped) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFlipAnimation() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: gameState.canFlipCard
            ? () => Provider.of<GameState>(context, listen: false)
                .setLastFlippedCard(widget.gameCard)
            : null,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 350),
          transitionBuilder: __transitionBuilder,
          layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
          child: __buildLayout(isFront: isFlipped),
          switchInCurve: Curves.fastOutSlowIn,
          switchOutCurve: Curves.fastOutSlowIn.flipped,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation();
  }

  Widget __buildLayout({bool isFront = true}) {
    return Container(
        key: ValueKey(isFront),
        child: CrossFade(
            initialData: isWin,
            data: isWin,
            builder: (win) => Container(
                  child: isFront
                      ? Center(
                          child: Text(
                            widget.gameCard.image,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )
                      : null,
                  decoration: BoxDecoration(
                    color: isFront
                        ? (win ? Colors.yellow : Colors.white)
                        : gameState.difficulty.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                )));
  }
}
