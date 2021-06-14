import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memory_game/providers/game_state.dart';
import 'package:provider/provider.dart';

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context);
    print('height: ${MediaQuery.of(context).size.height}');
    print('width: ${MediaQuery.of(context).size.width}');

    return DefaultTabController(
      initialIndex:
          gameState.difficulty != null ? gameState.difficulty.index : 0,
      length: Difficulty.values.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.yellow[800],
          title: Text('Placar'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            buildHeader(context),
            Expanded(
              child: buildContent(gameState, context),
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
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: Colors.yellow[800],
      child: MediaQuery.of(context).size.width < 1024
          ? TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: Difficulty.values
                  .map(
                    (difficulty) => Tab(
                      child: Text(
                        difficulty.label,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Difficulty.values
                  .map(
                    (difficulty) => Tab(
                      child: Text(
                        difficulty.label,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget buildContent(GameState gameState, BuildContext context) {
    return MediaQuery.of(context).size.width < 1024
        ? TabBarView(
            children: <Widget>[
              ...Difficulty.values
                  .map((difficulty) => buildList(gameState, difficulty))
                  .toList(),
            ],
          )
        : Row(
            children: [
              ...Difficulty.values
                  .map((difficulty) => Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              border: difficulty == Difficulty.medium
                                  ? Border.symmetric(
                                      vertical: BorderSide(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color,
                                      ),
                                    )
                                  : null,
                            ),
                            child: buildList(gameState, difficulty)),
                      ))
                  .toList(),
            ],
          );
  }

  Widget buildList(GameState gameState, Difficulty difficulty) {
    List list = difficulty == Difficulty.easy
        ? gameState.gameScoreListEasy
        : (difficulty == Difficulty.medium
            ? gameState.gameScoreListMedium
            : gameState.gameScoreListHard);

    return list.length > 0
        ? ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, int index) =>
                buildGameScore(index, list),
          )
        : buildNoScoreMessage();
  }

  Widget buildNoScoreMessage() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Sem placar definido.',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  ListTile buildGameScore(int index, List<GameScore> listGameScore) {
    final df = new DateFormat('dd/MM/yyyy');
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${(index + 1).toString()}#',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Text(
        df.format(listGameScore[index].date),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      title: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          child: Text(
            '${listGameScore[index].points.toString()} pontos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${listGameScore[index].formattedTimer}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${listGameScore[index].moves.toString()} Movimentos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
