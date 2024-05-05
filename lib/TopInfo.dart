import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hw3_2/main.dart';
import 'package:flutter_hw3_2/ScoreNotifier.dart';

import 'package:flutter/widgets.dart';

//最上方資訊欄
class TopInfo extends StatefulWidget {
  @override
  State<TopInfo> createState() => _TopInfoState();
}

class _TopInfoState extends State<TopInfo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ScoreNotifier>(
        builder: (context, scoreNotifier, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(color: Colors.black, width: 3.0),
                  color: Color.fromARGB(255, 234, 196, 234),
                ),
                child: Center(
                  child: Text(
                    '朋友\n對戰',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 95,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.black, width: 3.0),
                  color: isATurn
                      ? Color.fromARGB(255, 190, 151, 241)
                      : Color.fromARGB(255, 194, 194, 194),
                ),
                child: Center(
                  child: Text(
                    'A玩家\n${scoreNotifier.scoreA}分',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 95,
                height: 80,
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.black, width: 3.0),
                  color: Color.fromARGB(255, 234, 196, 234),
                ),
                child: Center(
                  child: Text(
                    'Round:\n${scoreNotifier.currentRound}/13',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 95,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.black, width: 3.0),
                  color: !isATurn
                      ? Color.fromARGB(255, 190, 151, 241)
                      : Color.fromARGB(255, 194, 194, 194),
                ),
                child: Center(
                  child: Text(
                    'B玩家\n${scoreNotifier.scoreB}分',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
