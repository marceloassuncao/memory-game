import 'package:flutter/material.dart';
import 'package:memory_game/config.dart';
import 'package:memory_game/info.dart';
import 'package:memory_game/providers/game_state.dart';
import 'package:memory_game/router/router_delegate.dart';
import 'package:memory_game/scoreboard.dart';
import 'package:memory_game/theme/theme.dart';
import 'package:memory_game/widgets/game_table.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MaterialApp(
      home: MemoryGameApp(),
      title: 'Memory Game',
    ),
  );
}

class MemoryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameState(),
        ),
        ChangeNotifierProvider(
          create: (_) => DarkThemeProvider(),
        ),
      ],
      builder: (BuildContext context, Widget widget) {
        DarkThemeProvider theme = Provider.of<DarkThemeProvider>(context);
        GameState gameState = Provider.of<GameState>(context);
        GameState gameStateListenFalse =
            Provider.of<GameState>(context, listen: false);
        return MemoryGameShell(
          theme: theme,
          gameState: gameState,
          gameStateListenFalse: gameStateListenFalse,
        );
      },
    );
  }
}

class MemoryGameShell extends StatefulWidget {
  MemoryGameShell({
    Key key,
    @required this.theme,
    @required this.gameState,
    @required this.gameStateListenFalse,
  }) : super(key: key);

  final DarkThemeProvider theme;
  final GameState gameState;
  final GameState gameStateListenFalse;

  @override
  _MemoryGameShellState createState() => _MemoryGameShellState();
}

class _MemoryGameShellState extends State<MemoryGameShell> {
  @override
  void dispose() {
    print('dispose MemoryGameShell');
    widget.gameStateListenFalse.exitGame();
    super.dispose();
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Styles.themeData(widget.theme.darkTheme, context),
      child: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
        // child: Router(
        //   routerDelegate: MemoryGameRouterDelegate(
        //     gameState,
        //     gameStateListenFalse,
        //     theme,
        //   ),
        // ),
        child: Navigator(
          // reportsRouteUpdateToEngine: true,
          key: _navigatorKey,
          pages: [
            MaterialPage(child: MyHomePage()),
            if (widget.gameState.gameStatus == GameStatus.playing ||
                widget.gameState.gameStatus == GameStatus.lose ||
                widget.gameState.gameStatus == GameStatus.win)
              MaterialPage(child: GameTable()),
            if (widget.gameState.gameStatus == GameStatus.scoreboard)
              MaterialPage(child: ScoreBoard()),
            if (widget.gameState.gameStatus == GameStatus.info)
              MaterialPage(child: Info()),
            if (widget.gameState.gameStatus == GameStatus.config)
              MaterialPage(child: Config()),
          ],
          onPopPage: (route, result) {
            print('onPopPage memoryGame');
            widget.gameStateListenFalse.exitGame();
            if (!route.didPop(result)) return false;
            return true;
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context, listen: false);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Jogo da Memória',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width > 768
                ? 768
                : MediaQuery.of(context).size.width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Difficulty.easy.color,
                          minimumSize:
                              Size.fromWidth(MediaQuery.of(context).size.width),
                        ),
                        onPressed: () => gameState.startGame(Difficulty.easy),
                        child: Text(
                          Difficulty.easy.label,
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Difficulty.medium.color,
                          minimumSize:
                              Size.fromWidth(MediaQuery.of(context).size.width),
                        ),
                        onPressed: () => gameState.startGame(Difficulty.medium),
                        child: Text(
                          Difficulty.medium.label,
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Difficulty.hard.color,
                          minimumSize:
                              Size.fromWidth(MediaQuery.of(context).size.width),
                        ),
                        onPressed: () => gameState.startGame(Difficulty.hard),
                        child: Text(
                          Difficulty.hard.label,
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.yellow[800],
                              minimumSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width),
                            ),
                            onPressed: () => gameState.scoreboardPage(),
                            // label: Text(
                            //   'Placar',
                            //   style: TextStyle(fontSize: 20),
                            // ),
                            child: Icon(
                              Icons.emoji_events,
                              size: MediaQuery.of(context).size.height * 0.07,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              minimumSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width),
                            ),
                            onPressed: () => gameState.configPage(),
                            // label: Text(
                            //   'Config',
                            //   style: TextStyle(fontSize: 20),
                            // ),
                            child: Icon(
                              Icons.settings,
                              size: MediaQuery.of(context).size.height * 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        minimumSize:
                            Size.fromWidth(MediaQuery.of(context).size.width),
                      ),
                      onPressed: () => gameState.infoPage(),
                      // label: Text(
                      //   'Info',
                      //   style: TextStyle(fontSize: 20),
                      // ),
                      child: Icon(
                        Icons.info,
                        size: MediaQuery.of(context).size.height * 0.07,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Desenvolvido por Marcelo Assunção - 2021',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
