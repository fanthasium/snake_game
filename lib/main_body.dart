import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/services/shared_pref.dart';
import 'package:snake_game/widgets/blank.pixel.dart';
import 'package:snake_game/widgets/food_pixel.dart';
import 'package:snake_game/widgets/snake_pixel.dart';

class MainBody extends StatefulWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _State();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _State extends State<MainBody> {

  int prefText = 0 ;
  //grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;
  int currentScore = 0;
  bool gameHasStarted = true;

  //snake position
  List<int> snakePos = [0, 1, 2];
  int foodPos = 0;
  //food position
  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
      foodPos = Random().nextInt(totalNumberOfSquares);
  }

  var currentDirection = snake_Direction.RIGHT;

  //start Game!
  void startGame() {
    gameHasStarted = false;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();

        if (gameOver()) {
          timer.cancel();

          showDialog(context: context, builder: (context){
            return AlertDialog(
                title: Center(child: Text("Game Over")),
                content: Column(
                  children: [
                    Text("score : $currentScore"),
                  ],
                ),
              actions: [
                MaterialButton(onPressed: (){
                  Navigator.pop(context);
                  newGame();
                } ,
                color: Colors.pink,
                child: Text("Submit"),)
              ],
            );
          });

        }
      });
    });
  }


  void newGame(){
   setState(() {

     currentScore = 0;
     gameHasStarted = true;
     snakePos = [0, 1, 2];
     foodPos = Random().nextInt(totalNumberOfSquares);
     currentDirection = snake_Direction.RIGHT;

   });
  }

  //game Over!
  bool gameOver() {
    // the game is over when the snake runs into it self

    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      PreferenceUtils.setString("count","$currentScore");
      return true;
    } else {
      return false;
    }
  }

  //eat food
  void eatFood() {
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
    currentScore++;
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last - 9);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last + 9);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //scores
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("current Score"),
                  Text(currentScore.toString(),
                    style: TextStyle(fontSize: 36) ,)
                ],
              ),
              Text("LAST SCORE: ${PreferenceUtils.getString("count")}")
            ],
          )),
          Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (detail) {
                  if (detail.delta.dy > 0 &&
                      currentDirection != snake_Direction.UP) {
                    currentDirection = snake_Direction.DOWN;
                  } else if (detail.delta.dy < 0 &&
                      currentDirection != snake_Direction.DOWN) {
                    currentDirection = snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: (detail) {
                  if (detail.delta.dx > 0 &&
                      currentDirection != snake_Direction.LEFT) {
                    currentDirection = snake_Direction.RIGHT;
                  } else if (detail.delta.dx < 0 &&
                      currentDirection != snake_Direction.RIGHT) {
                    currentDirection = snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: totalNumberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if(snakePos.last == index){
                      return SnakePixel(color: Colors.green,);
                    }else if (snakePos.contains(index)) {
                      return SnakePixel(color: Colors.white,);
                    } else if (foodPos == index) {
                      return FoodPixel();
                    }else {
                      return BlankPixel();
                    }
                  },
                ),
              )),
          Expanded(
              child: Container(
            child: Center(
              child: MaterialButton(
                onPressed: gameHasStarted? () {startGame();} : null,
                color: gameHasStarted? Colors.pink[900] : Colors.grey,
                child: Text("PLAY"),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
