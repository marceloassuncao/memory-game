import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memory_game/models/game_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameStatus {
  none,
  playing,
  win,
  lose,
  scoreboard,
  info,
  config,
}

enum Difficulty {
  easy,
  medium,
  hard,
}

extension DifficultyStats on Difficulty {
  int get time {
    switch (this) {
      case Difficulty.easy:
        return 90;
      case Difficulty.medium:
        return 60;
      case Difficulty.hard:
        return 30;
      default:
        return 0;
    }
  }

  Color get color {
    switch (this) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.blue;
      case Difficulty.hard:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  int get basePoint {
    switch (this) {
      case Difficulty.easy:
        return 30;
      case Difficulty.medium:
        return 60;
      case Difficulty.hard:
        return 120;
      default:
        return 0;
    }
  }

  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Fácil';
      case Difficulty.medium:
        return 'Médio';
      case Difficulty.hard:
        return 'Difícil';
      default:
        return '';
    }
  }
}

class GameHistory {
  final int timer;
  final int move;
  final int point;
  GameHistory({this.timer, this.move, this.point});
}

class GameScore {
  final int points;
  final int timer;
  final int moves;
  final DateTime date;
  final Difficulty difficulty;

  String get formattedTimer {
    return Duration(seconds: timer).toString().substring(2, 7);
  }

  GameScore({this.points, this.timer, this.moves, this.date, this.difficulty});
}

class GameState with ChangeNotifier {
  GameState() {
    this.loadGameScoreList();
  }
  Timer timerObj;

  startTimer() {
    timerObj = Timer.periodic(Duration(seconds: 1), (Timer t) {
      // canFlipCard = true;
      if (_timer > 0) _timer--;
      notifyListeners();
      if (_timer == 0) {
        loseGame();
      }
    });
  }

  cancelTimer() {
    if (timerObj != null) timerObj.cancel();
  }

  int _lastPoint = 0;
  int _points = 0;
  int _moves = 0;
  Difficulty _difficulty;
  int _timer = 0;
  List<GameCard> _cards = [];
  GameStatus _gameStatus = GameStatus.none;
  List<GameHistory> gameHistory = [];
  final int gameCardsQuantity = 12;

  GameHistory get lastGameHistory =>
      gameHistory.length > 0 ? gameHistory.last : null;

  int get points => _points;
  int get lastPoint => _lastPoint;
  int get timer => _timer;

  String get formattedTimer {
    return Duration(seconds: _timer).toString().substring(2, 7);
  }

  int get moves => _moves;
  GameStatus get gameStatus => _gameStatus;
  Difficulty get difficulty => _difficulty;
  List<GameCard> get cards => _cards;
  GameCard _lastFlippedCard;
  bool canFlipCard = true;

  bool showResetMessage = false;

  List<GameScore> _gameScoreList = [];
  List<GameScore> get gameScoreList => _gameScoreList;

  List<GameScore> get gameScoreListEasy => _gameScoreList
      .where((gameScore) => gameScore.difficulty == Difficulty.easy)
      .toList()
        ..sort((a, b) {
          var byPoints = b.points.compareTo(a.points);
          if (byPoints != 0) return byPoints;
          return a.moves.compareTo(b.moves);
        });
  List<GameScore> get gameScoreListMedium => _gameScoreList
      .where((gameScore) => gameScore.difficulty == Difficulty.medium)
      .toList()
        ..sort((a, b) {
          var byPoints = b.points.compareTo(a.points);
          if (byPoints != 0) return byPoints;
          return a.moves.compareTo(b.moves);
        });
  List<GameScore> get gameScoreListHard => _gameScoreList
      .where((gameScore) => gameScore.difficulty == Difficulty.hard)
      .toList()
        ..sort((a, b) {
          var byPoints = b.points.compareTo(a.points);
          if (byPoints != 0) return byPoints;
          return a.moves.compareTo(b.moves);
        });

  get isPlayingGame => gameStatus == GameStatus.playing;

  get showWinPopup => gameStatus == GameStatus.win && points > 0;

  get showLosePopup => gameStatus == GameStatus.lose && timer <= 0;

  GameScore fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return GameScore(
        points: map['points'],
        date: DateTime.parse(map['date']),
        timer: map['timer'],
        moves: map['moves'],
        difficulty: Difficulty.values[map['difficulty']]);
  }

  String toJson(GameScore gameScore) {
    Map<String, dynamic> map = {
      'points': gameScore.points,
      'timer': gameScore.timer,
      'moves': gameScore.moves,
      'date': gameScore.date.toIso8601String(),
      'difficulty': gameScore.difficulty.index
    };
    return jsonEncode(map);
  }

  Future<void> saveGameScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> gameScoreListStrings = prefs.getStringList('gameScore');
    if (gameScoreListStrings == null) gameScoreListStrings = [];
    gameScoreListStrings.add(toJson(GameScore(
      date: DateTime.now(),
      points: points,
      timer: difficulty.time - timer,
      moves: moves,
      difficulty: difficulty,
    )));
    prefs.setStringList('gameScore', gameScoreListStrings);
    print('setedGameScore $gameScoreListStrings');
  }

  Future<void> loadGameScoreList() async {
    _gameScoreList = [];
    final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    final gameScoreListStrings = prefs.getStringList('gameScore');
    if (gameScoreListStrings != null && gameScoreListStrings.length > 0) {
      print('loadedGameScore $gameScoreListStrings');
      for (var gameScoreString in gameScoreListStrings) {
        _gameScoreList.add(fromJson(gameScoreString));
      }
      notifyListeners();
    }
  }

  Future<void> resetGameScoreList() async {
    _gameScoreList = [];
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('gameScore');
    notifyListeners();
  }

  void winCondition() {
    if (gameStatus != GameStatus.win) {
      if (cards.where((card) => !card.win).length == 0) {
        _gameStatus = GameStatus.win;
        notifyListeners();
        winGame();
      }
    }
  }

  GameCard get lastFlippedCard => _lastFlippedCard;
  Future setLastFlippedCard(GameCard flippedCard) async {
    if (canFlipCard && !flippedCard.flipped) {
      if (_lastFlippedCard == null) {
        _lastFlippedCard = flippedCard;
        flippedCard.flipCard();
        canFlipCard = false;
        notifyListeners();
      } else {
        if (_lastFlippedCard.id == flippedCard.id &&
            _lastFlippedCard.index != flippedCard.index) {
          flippedCard.flipCard();
          canFlipCard = false;
          notifyListeners();
          await Future.delayed(Duration(milliseconds: 400), () {
            addMove();
            flippedCard.winCard();
            _lastFlippedCard.winCard();
            addPoints();
            canFlipCard = true;
            _lastFlippedCard = null;
            notifyListeners();
          });
        } else {
          if (_lastFlippedCard != null) {
            flippedCard.flipCard();
            canFlipCard = false;
            notifyListeners();
            await Future.delayed(Duration(milliseconds: 400), () {
              addMove();
              flippedCard.flipCard();
              _lastFlippedCard.flipCard();
              canFlipCard = true;
              _lastFlippedCard = null;
              notifyListeners();
            });
          }
        }
      }
      canFlipCard = true;
      notifyListeners();
    }
  }

  void addGameHistory() {
    gameHistory.add(GameHistory(timer: timer, move: moves, point: _lastPoint));
  }

  void addPoints() {
    _lastPoint = difficulty.basePoint * timer;
    _points += _lastPoint;
    addGameHistory();
    winCondition();
    notifyListeners();
  }

  void restartGame() {
    startGame(difficulty);
    showResetMessage = true;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 100), () {
      showResetMessage = false;
      notifyListeners();
    });
  }

  void startGame(Difficulty difficulty, [GameStatus newGameStatus]) {
    setCards();
    _lastPoint = 0;
    _points = 0;
    _moves = 0;
    _gameStatus = newGameStatus == null
        ? (difficulty == null ? GameStatus.none : GameStatus.playing)
        : newGameStatus;
    _difficulty = difficulty;
    gameHistory = [];
    _lastFlippedCard = null;
    // canFlipCard = false;

    _timer = _difficulty.time;
    if (gameStatus == GameStatus.playing && _timer > 0) {
      cancelTimer();
      startTimer();
    }
    notifyListeners();
  }

  void loseGame() {
    _gameStatus = GameStatus.lose;
    cancelTimer();
    notifyListeners();
  }

  void winGame() {
    _gameStatus = GameStatus.win;
    cancelTimer();
    saveGameScore();
    loadGameScoreList();
    print(_gameScoreList);
    print('easy list $gameScoreListEasy');

    notifyListeners();
  }

  void exitGame() {
    _gameStatus = GameStatus.none;
    cancelTimer();
    notifyListeners();
  }

  void scoreboardPage() {
    _gameStatus = GameStatus.scoreboard;
    cancelTimer();
    notifyListeners();
  }

  void infoPage() {
    _gameStatus = GameStatus.info;
    notifyListeners();
  }

  void configPage() {
    _gameStatus = GameStatus.config;
    notifyListeners();
  }

  void addMove() {
    _moves++;
    notifyListeners();
  }

  void setCards() {
    _cards = [];
    for (var i = 1; i < (gameCardsQuantity + 1); i++) {
      _cards.add(GameCard(index: i, id: i, image: i.toString()));
    }
    for (var i = 1; i < (gameCardsQuantity + 1); i++) {
      _cards.add(
          GameCard(index: i + gameCardsQuantity, id: i, image: i.toString()));
    }
    // _cards.shuffle();
    // _cards.shuffle();
    // _cards.shuffle();
    _cards = shuffle(_cards);
    notifyListeners();
  }

  List shuffle(List items) {
    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = Random().nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}
