import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hw3_2/main.dart';
import 'package:flutter/widgets.dart';

//骰子顯示
class Dice extends StatefulWidget {
  final int value, index;

  Dice({Key? key, required this.value, required this.index}) : super(key: key);

  @override
  State<Dice> createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (thrownDice) {
          setState(() {
            isSelected[widget.index] = !isSelected[widget.index]; // 切換選中狀態
          });
          if (isSelected[widget.index]) {
            selectedIndex.add(widget.index);
          } else {
            selectedIndex.remove(widget.index);
          }
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected[widget.index]
              ? Border.all(
                  color: Color.fromARGB(255, 190, 151, 241), width: 8.0)
              : Border.all(color: Colors.black, width: 3.0),
          color: Color.fromARGB(255, 241, 151, 181),
        ),
        child: Center(
          child: Text(
            '${widget.value}',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
