import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hw3_2/main.dart';
import 'package:flutter_hw3_2/ScoreNotifier.dart';
// import 'package:flutter_hw3/CalculateFunction.dart';

final List<String> scoreKind = [
  //分數判別的種類
  '一點',
  '二點',
  '三點',
  '四點',
  '五點',
  '六點',
  '三條',
  '四條',
  '小順',
  '大順',
  '葫蘆',
  '快艇',
  '??'
];
bool hasYahtzee = false;
int tempA = 0, tempB = 0;
// bool isRemindMode = false;

enum ConfirmAction { ACCEPT, CANCEL }

class ScoreBoard extends StatefulWidget {
  ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreNotifier>(
      builder: (context, scoreNotifier, child) {
        return Column(
          children: [
            for (var kind in scoreKind) ScoreBoardRow(scoreKind: kind),
            //bonus
            Row(
              children: [
                Container(
                  width: 80,
                  height: 30,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Center(
                    child: Text(
                      'Bonus',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  height: 30,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      border: Border.all(color: Colors.black, width: 3.0),
                      color: Color.fromARGB(255, 234, 196, 234)),
                  child: Center(
                    child: Text(
                      '${scoreNotifier.bonusA}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  height: 30,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(color: Colors.black, width: 3.0),
                    color: Color.fromARGB(255, 234, 196, 234),
                  ),
                  child: Center(
                    child: Text(
                      '${scoreNotifier.bonusB}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class ScoreBoardRow extends StatefulWidget {
  ScoreBoardRow({super.key, required this.scoreKind});
  final String scoreKind;

  @override
  State<ScoreBoardRow> createState() => _ScoreBoardRowState();
}

class _ScoreBoardRowState extends State<ScoreBoardRow> {
  //計分種類
  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreNotifier>(
      builder: (context, scoreNotifier, child) {
        bool doneA = scoreNotifier.doneA[widget.scoreKind] ?? false;
        bool doneB = scoreNotifier.doneB[widget.scoreKind] ?? false;
        return Row(
          children: [
            Container(
              width: 80,
              height: 30,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Center(
                child: Text(
                  widget.scoreKind,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!doneA && isATurn && thrownDice) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          '確定要填入該格嗎',
                          style: TextStyle(fontSize: 30),
                        ),
                        content: Text(
                          '所選的是${widget.scoreKind}',
                          style: TextStyle(fontSize: 25),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              'Play',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              scoreNotifier.calculateScore(widget.scoreKind);
                              scoreNotifier.setScoreA(tempA);
                              scoreNotifier.initRound();
                              setState(() {
                                scoreNotifier.isRemindMode = false;
                              });

                              Navigator.of(context).pop(ConfirmAction.ACCEPT);
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(ConfirmAction.CANCEL);
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                width: 160,
                height: 30,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(color: Colors.black, width: 3.0),
                  color: !doneA
                      ? Color.fromARGB(255, 234, 196, 234)
                      : Color.fromARGB(255, 194, 194, 194),
                ),
                child: Center(
                  child: Text(
                    scoreNotifier.isRemindMode && isATurn
                        ? '${scoreNotifier.tempScoreofA[widget.scoreKind]}'
                        : '${scoreNotifier.scoreofA[widget.scoreKind]}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!doneB && !isATurn && thrownDice) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          '確定要填入該格嗎',
                          style: TextStyle(fontSize: 30),
                        ),
                        content: Text(
                          '所選的是${widget.scoreKind}',
                          style: TextStyle(fontSize: 25),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              '確認',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              scoreNotifier
                                  .calculateScore(widget.scoreKind); //計算得分
                              scoreNotifier.setScoreB(tempB);
                              scoreNotifier.initRound();
                              setState(() {
                                scoreNotifier.isRemindMode = false;
                              });
                              int a = scoreNotifier.scoreA;
                              int b = scoreNotifier.scoreB;
                              Navigator.of(context).pop(ConfirmAction.ACCEPT);

                              if (scoreNotifier.currentRound > 13) {
                                //改13
                                //  結束遊戲
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('遊戲結束',
                                          style: TextStyle(fontSize: 30)),
                                      content: () {
                                        if (a > b) {
                                          return Text(
                                              'A玩家獲勝！\nA玩家得分：$a\nB玩家得分：$b',
                                              style: TextStyle(fontSize: 25));
                                        } else if (a == b) {
                                          return const Text('平手！',
                                              style: TextStyle(fontSize: 25));
                                        } else {
                                          return Text(
                                              'B玩家獲勝！\nA玩家得分：$a\nB玩家得分：$b',
                                              style: TextStyle(fontSize: 25));
                                        }
                                      }(),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('確定',
                                              style: TextStyle(fontSize: 20)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                //重置遊戲數據
                                scoreNotifier.initGame();
                              }
                            },
                          ),
                          TextButton(
                            child: const Text(
                              '取消',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(ConfirmAction.CANCEL);
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                width: 160,
                height: 30,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(color: Colors.black, width: 3.0),
                  color: doneB
                      ? const Color.fromARGB(255, 194, 194, 194)
                      : const Color.fromARGB(255, 234, 196, 234),
                ),
                child: Center(
                  child: Text(
                    scoreNotifier.isRemindMode && !isATurn
                        ? '${scoreNotifier.tempScoreofB[widget.scoreKind]}'
                        : '${scoreNotifier.scoreofB[widget.scoreKind]}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
