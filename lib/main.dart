import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter_hw3_2/Dice.dart';
import 'package:flutter_hw3_2/TopInfo.dart';
import 'package:flutter_hw3_2/ScoreBoard.dart';
import 'package:flutter_hw3_2/ScoreNotifier.dart';

import 'package:flutter/widgets.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ScoreNotifier(),
      child: const MyApp(),
    ),
  );
}

List<int> selectedIndex = []; //選中保留的骰子
List<bool> isSelected = [false, false, false, false, false];
bool isATurn = true; //是A玩家的輪次
bool thrownDice = false; //該輪是否有擲骰子過
List<int> diceValues = [0, 0, 0, 0, 0];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yahtzee',
      theme: ThemeData(
        // This is the theme of your application.
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 50,
          ),
        ),
      ),
      home: YahtzeeBoard(
        title: "yahtzee by flutter",
      ),
    );
  }
}

class YahtzeeBoard extends StatefulWidget {
  final String title;
  YahtzeeBoard({super.key, required this.title});

  @override
  _YahtzeeBoardState createState() => _YahtzeeBoardState();
}

class _YahtzeeBoardState extends State<YahtzeeBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/564x/9d/05/d9/9d05d95790b47d651602c0c352085452.jpg'), // 从网络加载图片
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop), // 调整透明度为50%
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              TopInfo(), //最上方資訊欄
              SizedBox(height: 3.0),
              Expanded(
                flex: 7,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                child: (ScoreBoard()),
              ),
              Expanded(
                flex: 2,
                child: DiceRows(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiceRows extends StatefulWidget {
  const DiceRows({Key? key}) : super(key: key);

  @override
  State<DiceRows> createState() => _DiceRowsState();
}

class _DiceRowsState extends State<DiceRows> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreNotifier>(
      builder: (context, scoreNotifier, child) {
        Random random = Random();
        void rollDice() {
          setState(() {
            //改變骰子狀態
            for (int i = 0; i < diceValues.length; i++) {
              if (!selectedIndex.contains(i)) {
                //不是保留值
                diceValues[i] = random.nextInt(6) + 1; // 擲骰子
              }
            }
          });
          scoreNotifier.isRemindMode = true;
          scoreNotifier.setRemindScore();
          // print(diceValues);
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < diceValues.length; i++)
                  Dice(value: diceValues[i], index: i),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    thrownDice = true;
                    scoreNotifier.rollLeft <= 0 ? null : rollDice();
                    scoreNotifier.setRollLeft();
                  },
                  child: Container(
                    width: 320, //190
                    height: 60,
                    // padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: scoreNotifier.rollLeft == 0
                          ? Color.fromARGB(255, 161, 161, 161)
                          : Color.fromARGB(255, 222, 56, 111),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black, width: 3.0),
                    ),
                    child: Center(
                      child: Text(
                        'Roll Dice : ${scoreNotifier.rollLeft}',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   //play
                //   onTap: () {
                //     // thrownDice = true;
                //     // scoreNotifier.rollLeft <= 0 ? null : rollDice();
                //     // scoreNotifier.setRollLeft();
                //   },
                //   child: Container(
                //     width: 140,
                //     height: 60,
                //     margin: EdgeInsets.all(5),
                //     decoration: BoxDecoration(
                //       color: scoreNotifier.rollLeft == 0
                //           ? Color.fromARGB(255, 161, 161, 161)
                //           : Color.fromARGB(255, 222, 56, 111),
                //       borderRadius: BorderRadius.circular(20.0),
                //       border: Border.all(color: Colors.black, width: 3.0),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Play',
                //         style: TextStyle(
                //           fontSize: 25.0,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            '確定要開始新一局的遊戲嗎',
                            style: TextStyle(fontSize: 25),
                          ),
                          content: Text(
                            '當前的得分將全部清除',
                            style: TextStyle(fontSize: 22),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  setState(() {
                                    scoreNotifier.initGame();
                                  });
                                  // print(scoreNotifier.currentRound);
                                  // print(scoreNotifier.scoreA);
                                },
                                child: const Text(
                                  '確認',
                                  style: TextStyle(fontSize: 20),
                                )

                                // onPressed: scoreNotifier.initGame,
                                ),
                            TextButton(
                              child: const Text(
                                '取消',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                diceValues = [0, 0, 0, 0, 0];
                                Navigator.pop(context, false);
                              },
                            )
                          ],
                        );
                      },
                    ).then((value) {
                      if (value != null && value == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return YahtzeeBoard(
                                title: 'yahtzee by flutter',
                              );
                            },
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    width: 70,
                    height: 60,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 222, 56, 111),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black, width: 3.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.refresh,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
