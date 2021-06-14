import 'package:flutter/material.dart';
import 'package:memory_game/providers/game_state.dart';
import 'package:memory_game/theme/theme.dart';
import 'package:provider/provider.dart';

class Config extends StatelessWidget {
  GameState gameState;
  DarkThemeProvider themeState;
  @override
  Widget build(BuildContext context) {
    themeState = Provider.of<DarkThemeProvider>(context);
    gameState = Provider.of<GameState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Configurações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Dark Theme'),
                      Switch(
                        value: themeState.darkTheme,
                        onChanged: (bool value) {
                          themeState.darkTheme = value;
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // minimumSize:
                          //     Size.fromWidth(MediaQuery.of(context).size.width),
                          ),
                      onPressed: () => showResetGameScoreDialog(context),
                      child: Text(
                        'Resetar Placar',
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
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

  Future<void> showResetGameScoreDialog(BuildContext context) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (context) => Dialog(
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
                  'Tem certeza que deseja resetar o Placar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Os dados serão perdidos para sempre.',
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
                        child: OutlinedButton(
                          // style: ElevatedButton.styleFrom(
                          //   primary: gameState.difficulty.color,
                          // ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            gameState.resetGameScoreList();
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
                        child: ElevatedButton(
                          // style: OutlinedButton.styleFrom(
                          //   primary: gameState.difficulty.color,
                          // ),
                          onPressed: () {
                            Navigator.of(context).pop();
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
  }
}
