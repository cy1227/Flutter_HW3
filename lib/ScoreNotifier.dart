import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hw3_2/main.dart';
import 'package:flutter_hw3_2/ScoreBoard.dart';
import 'package:flutter_hw3_2/TopInfo.dart';
import 'dart:math';

class ScoreNotifier extends ChangeNotifier {
  int scoreA = 0;
  int scoreB = 0;
  int currentRound = 1;
  int rollLeft = 3;
  int bonusA = 0, bonusB = 0;
  bool isRemindMode = false;
  Map<String, int> scoreofA = {
    '一點': 0,
    '二點': 0,
    '三點': 0,
    '四點': 0,
    '五點': 0,
    '六點': 0,
    '三條': 0,
    '四條': 0,
    '小順': 0,
    '大順': 0,
    '葫蘆': 0,
    '快艇': 0,
    '??': 0
  };
  Map<String, int> tempScoreofA = {
    '一點': 0,
    '二點': 0,
    '三點': 0,
    '四點': 0,
    '五點': 0,
    '六點': 0,
    '三條': 0,
    '四條': 0,
    '小順': 0,
    '大順': 0,
    '葫蘆': 0,
    '快艇': 0,
    '??': 0
  };
  Map<String, int> scoreofB = {
    '一點': 0,
    '二點': 0,
    '三點': 0,
    '四點': 0,
    '五點': 0,
    '六點': 0,
    '三條': 0,
    '四條': 0,
    '小順': 0,
    '大順': 0,
    '葫蘆': 0,
    '快艇': 0,
    '??': 0
  };
  Map<String, int> tempScoreofB = {
    '一點': 0,
    '二點': 0,
    '三點': 0,
    '四點': 0,
    '五點': 0,
    '六點': 0,
    '三條': 0,
    '四條': 0,
    '小順': 0,
    '大順': 0,
    '葫蘆': 0,
    '快艇': 0,
    '??': 0
  };
  Map<String, bool> doneA = {
    '一點': false,
    '二點': false,
    '三點': false,
    '四點': false,
    '五點': false,
    '六點': false,
    '三條': false,
    '四條': false,
    '小順': false,
    '大順': false,
    '葫蘆': false,
    '快艇': false,
    '??': false
  };
  Map<String, bool> doneB = {
    '一點': false,
    '二點': false,
    '三點': false,
    '四點': false,
    '五點': false,
    '六點': false,
    '三條': false,
    '四條': false,
    '小順': false,
    '大順': false,
    '葫蘆': false,
    '快艇': false,
    '??': false
  };
  Random random = Random();
  void setRollLeft() {
    rollLeft -= 1;
    notifyListeners();
  }

  void setScoreA(int a) {
    scoreA += a;
    notifyListeners();
  }

  void setScoreB(int b) {
    scoreB += b;
    notifyListeners();
  }

  void plusRound() {
    //增加回合數
    currentRound++;
    notifyListeners();
  }

  void checkABonus() {
    //檢查是否達到bonus標準
    if (scoreofA['一點']! +
            scoreofA['二點']! +
            scoreofA['三點']! +
            scoreofA['四點']! +
            scoreofA['五點']! +
            scoreofA['六點']! >=
        63) {
      scoreA += 35;
      bonusA = 35;
      notifyListeners();
    }
  }

  void checkBBonus() {
    //檢查是否達到bonus標準
    if (scoreofB['一點']! +
            scoreofB['二點']! +
            scoreofB['三點']! +
            scoreofB['四點']! +
            scoreofB['五點']! +
            scoreofB['六點']! >=
        63) {
      scoreA += 35;
      bonusB = 35;
      notifyListeners();
    }
  }

  void calculateScore(String scoreKind) {
    int thisScore = returnCalculateScore(scoreKind);
    if (isATurn) {
      scoreofA[scoreKind] = thisScore;
      tempA = thisScore;
      doneA[scoreKind] = true; //該格已經填寫完成
    } else {
      scoreofB[scoreKind] = thisScore;
      tempB = thisScore;
      doneB[scoreKind] = true; //該格已經填寫完成
    }
    isATurn = !isATurn; //換對手玩
    notifyListeners();
  }

  void initRound() {
    //新的一回合
    // print(isATurn);
    rollLeft = 3;
    diceValues = [0, 0, 0, 0, 0];
    !isATurn ? null : plusRound(); //第二次才增加回合數
    isATurn ? checkABonus() : checkBBonus();
    thrownDice = false;
    isSelected = [false, false, false, false, false];
    selectedIndex.clear(); //清除保留的骰子
    tempScoreofA = {
      '一點': 0,
      '二點': 0,
      '三點': 0,
      '四點': 0,
      '五點': 0,
      '六點': 0,
      '三條': 0,
      '四條': 0,
      '小順': 0,
      '大順': 0,
      '葫蘆': 0,
      '快艇': 0,
      '??': 0
    };
    tempScoreofB = {
      '一點': 0,
      '二點': 0,
      '三點': 0,
      '四點': 0,
      '五點': 0,
      '六點': 0,
      '三條': 0,
      '四條': 0,
      '小順': 0,
      '大順': 0,
      '葫蘆': 0,
      '快艇': 0,
      '??': 0
    };
    notifyListeners();
  }

  void initGame() {
    rollLeft = 3;
    diceValues = [0, 0, 0, 0, 0];
    currentRound = 1;
    thrownDice = false;
    isSelected = [false, false, false, false, false];
    selectedIndex.clear(); //清除保留的骰子
    isATurn = true;
    scoreA = 0;
    scoreB = 0; //總分歸零
    //清除分數顯示
    scoreofA = {
      '一點': 0,
      '二點': 0,
      '三點': 0,
      '四點': 0,
      '五點': 0,
      '六點': 0,
      '三條': 0,
      '四條': 0,
      '小順': 0,
      '大順': 0,
      '葫蘆': 0,
      '快艇': 0,
      '??': 0
    };
    scoreofB = {
      '一點': 0,
      '二點': 0,
      '三點': 0,
      '四點': 0,
      '五點': 0,
      '六點': 0,
      '三條': 0,
      '四條': 0,
      '小順': 0,
      '大順': 0,
      '葫蘆': 0,
      '快艇': 0,
      '??': 0
    };
    tempScoreofA = {
      '一點': 0,
      '二點': 0,
      '三點': 0,
      '四點': 0,
      '五點': 0,
      '六點': 0,
      '三條': 0,
      '四條': 0,
      '小順': 0,
      '大順': 0,
      '葫蘆': 0,
      '快艇': 0,
      '??': 0
    };
    tempScoreofB = {
      '一點': 0,
      '二點': 0,
      '三點': 0,
      '四點': 0,
      '五點': 0,
      '六點': 0,
      '三條': 0,
      '四條': 0,
      '小順': 0,
      '大順': 0,
      '葫蘆': 0,
      '快艇': 0,
      '??': 0
    };
    //清除每個格子的狀態
    doneA = {
      '一點': false,
      '二點': false,
      '三點': false,
      '四點': false,
      '五點': false,
      '六點': false,
      '三條': false,
      '四條': false,
      '小順': false,
      '大順': false,
      '葫蘆': false,
      '快艇': false,
      '??': false
    };
    doneB = {
      '一點': false,
      '二點': false,
      '三點': false,
      '四點': false,
      '五點': false,
      '六點': false,
      '三條': false,
      '四條': false,
      '小順': false,
      '大順': false,
      '葫蘆': false,
      '快艇': false,
      '??': false
    };
    notifyListeners();
  }

  int returnCalculateScore(String scoreKind) {
    int thisScore = 0;
    switch (scoreKind) {
      case '一點':
        for (int i = 0; i < 5; i++) {
          if (diceValues[i] == 1) {
            thisScore += diceValues[i];
          }
        }
        break;
      case '二點':
        for (int i = 0; i < 5; i++) {
          if (diceValues[i] == 2) {
            thisScore += diceValues[i];
          }
        }
        break;
      case '三點':
        for (int i = 0; i < 5; i++) {
          if (diceValues[i] == 3) {
            thisScore += diceValues[i];
          }
        }
        break;
      case '四點':
        for (int i = 0; i < 5; i++) {
          if (diceValues[i] == 4) {
            thisScore += diceValues[i];
          }
        }
        break;
      case '五點':
        for (int i = 0; i < 5; i++) {
          if (diceValues[i] == 5) {
            thisScore += diceValues[i];
          }
        }
        break;
      case '六點':
        for (int i = 0; i < 5; i++) {
          if (diceValues[i] == 6) {
            thisScore += diceValues[i];
          }
        }
        break;
      case '三條':
        if (diceValues
            .toSet()
            .any((value) => diceValues.where((v) => v == value).length >= 3)) {
          thisScore = diceValues.reduce((value, element) => value + element);
        }
        break;
      case '四條':
        if (diceValues
            .toSet()
            .any((value) => diceValues.where((v) => v == value).length >= 4)) {
          thisScore = diceValues.reduce((value, element) => value + element);
        }
        break;
      case '小順':
        if (diceValues.toSet().containsAll({1, 2, 3, 4}) ||
            diceValues.toSet().containsAll({2, 3, 4, 5}) ||
            diceValues.toSet().containsAll({3, 4, 5, 6})) {
          thisScore = 30;
        }
        break;
      case '大順':
        if (diceValues.toSet().containsAll({1, 2, 3, 4, 5}) ||
            diceValues.toSet().containsAll({2, 3, 4, 5, 6})) {
          thisScore = 40;
        }
        break;
      case '葫蘆':
        if (diceValues.toSet().any(
                (value) => diceValues.where((v) => v == value).length == 3) &&
            diceValues.toSet().any(
                (value) => diceValues.where((v) => v == value).length == 2)) {
          thisScore = 25;
        }
        break;
      case '快艇':
        if (diceValues
            .toSet()
            .any((value) => diceValues.where((v) => v == value).length == 5)) {
          if (hasYahtzee) {
            //二次以上快艇得100分
            thisScore = 100;
          } else {
            thisScore = 50;
          }
          hasYahtzee = true;
        }
        break;
      case '??':
        thisScore = diceValues.reduce((value, element) => value + element);
        break;
    }
    return thisScore;
  }

  void setRemindScore() {
    //設定分數預測值
    if (isATurn) {
      tempScoreofA.forEach((key, value) {
        if (!(doneA[key] ?? false)) {
          tempScoreofA[key] = returnCalculateScore(key);
        } else {
          tempScoreofA[key] = scoreofA[key]!;
        }
      });
    } else {
      tempScoreofB.forEach((key, value) {
        if (!(doneB[key] ?? false)) {
          tempScoreofB[key] = returnCalculateScore(key);
        } else {
          tempScoreofB[key] = scoreofB[key]!;
        }
      });
    }
    notifyListeners();
  }
}
