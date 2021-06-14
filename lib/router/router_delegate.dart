import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory_game/config.dart';
import 'package:memory_game/info.dart';
import 'package:memory_game/main.dart';
import 'package:memory_game/memory_game.dart';
import 'package:memory_game/providers/game_state.dart';
import 'package:memory_game/scoreboard.dart';
import 'package:memory_game/theme/theme.dart';
import 'package:memory_game/widgets/game_table.dart';
import 'package:provider/provider.dart';

class MemoryGameRouterDelegate extends RouterDelegate<dynamic>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<dynamic> {
  MemoryGameRouterDelegate(
      this.gameState, this.gameStateListenFalse, this.theme);

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  final GameState gameState;
  final GameState gameStateListenFalse;
  final DarkThemeProvider theme;

  @override
  dynamic get currentConfiguration {
    print('currentConfiguration memory game');
    // if(gameState.isPlayingGame) gameStateListenFalse.exitGame();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Styles.themeData(theme.darkTheme, context),
      child: WillPopScope(
        onWillPop: () async => !await navigatorKey.currentState.maybePop(),
        child: Navigator(
          reportsRouteUpdateToEngine: true,
          key: navigatorKey,
          pages: [
            MaterialPage(child: MyHomePage()),
            if (gameState.gameStatus == GameStatus.playing ||
                gameState.gameStatus == GameStatus.lose ||
                gameState.gameStatus == GameStatus.win)
              MaterialPage(child: GameTable()),
            if (gameState.gameStatus == GameStatus.scoreboard)
              MaterialPage(child: ScoreBoard()),
            if (gameState.gameStatus == GameStatus.info)
              MaterialPage(child: Info()),
            if (gameState.gameStatus == GameStatus.config)
              MaterialPage(child: Config()),
          ],
          onPopPage: (route, result) {
            print('onPopPage memoryGame');
            gameStateListenFalse.exitGame();
            if (!route.didPop(result)) return false;
            return true;
          },
        ),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(dynamic homeRoutePath) async {
    print('setNewRoutePath memoryGame');
    gameStateListenFalse.exitGame();
  }
}
