import 'package:flutter/material.dart';
import 'package:memory_game/models/game_card.dart';
import 'package:memory_game/providers/game_state.dart';
import 'package:memory_game/widgets/cross_fade.dart';
import 'package:memory_game/widgets/game_table_card.dart';
import 'package:provider/provider.dart';

class GameTable extends StatelessWidget {
  showResetBottomMessage(BuildContext context) {
    if (gameState.showResetMessage) {
      Future.delayed(Duration.zero, () async {
        print('reset');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 600),
            content: const Text(
              'Jogo reiniciado!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            // action: SnackBarAction(
            //   label: 'Action',
            //   onPressed: () {
            //     // Code to execute.
            //   },
            // ),
          ),
        );
      });
    }
  }

  showWinDialog(BuildContext context) {
    if (gameState.showWinPopup) {
      Future.delayed(Duration(milliseconds: 500), () async {
        await showDialog(
          context: buildContext,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (context) => Dialog(
            key: Key(gameState.showWinPopup.toString()),
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(Size.fromWidth(1024)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Você Ganhou!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tentar novamente?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: gameState.difficulty.color,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                gameState.restartGame();
                              },
                              child: Text(
                                'Sim',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: gameState.difficulty.color,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                gameState.exitGame();
                              },
                              child: Text(
                                'Não',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  showLoseDialog(BuildContext context) {
    if (gameState.showLosePopup) {
      Future.delayed(Duration(milliseconds: 500), () async {
        await showDialog(
          context: buildContext,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (context) => Dialog(
            key: Key(gameState.showWinPopup.toString()),
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(Size.fromWidth(1024)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Você Perdeu!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tentar novamente?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: gameState.difficulty.color,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                gameState.restartGame();
                              },
                              child: Text(
                                'Sim',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: gameState.difficulty.color,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                gameState.exitGame();
                              },
                              child: Text(
                                'Não',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  GameState gameState;
  BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    gameState = Provider.of<GameState>(context);
    showResetBottomMessage(context);
    showWinDialog(context);
    showLoseDialog(context);
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.6;
    final double itemWidth = (size.width > 768 ? 768 : size.width) / 2;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${gameState.difficulty.label}'),
        backgroundColor: gameState.difficulty.color,
        actions: [
          IconButton(
            tooltip: 'Placar',
            onPressed: () => gameState.scoreboardPage(),
            icon: Icon(Icons.emoji_events),
          ),
          IconButton(
            tooltip: 'Reiniciar',
            onPressed: () => gameState.restartGame(),
            icon: Icon(Icons.restore),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: size.width > 768 ? 768 : size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: gameState.difficulty.color,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tempo',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '${gameState.formattedTimer}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: gameState.difficulty.color,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Movimentos',
                                style: TextStyle(fontSize: 20),
                              ),
                              CrossFade(
                                initialData: gameState.moves,
                                data: gameState.moves,
                                builder: (moves) => Text(
                                  '$moves',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: gameState.difficulty.color,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pontos',
                                style: TextStyle(fontSize: 20),
                              ),
                              CrossFade(
                                initialData: gameState.points,
                                data: gameState.points,
                                builder: (points) => Text(
                                  '$points',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width > 768 ? 768 : size.width,
                    child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: (itemWidth / itemHeight),
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: gameState.cards.map((gameCard) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GameTableCard(gameCard),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Desenvolvido por Marcelo Assunção - 2021',
              ),
            ),
          )
        ],
      ),
    );
  }
}
