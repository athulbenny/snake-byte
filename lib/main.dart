import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';

void main() {
  runApp(const MApp());
}

class MApp extends StatelessWidget {
  const MApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static List<int> snakepos=[45,65,85,105,125];
  int sqnum=760;
  var score=0;
  static var randnum=Random();
  int food=randnum.nextInt(760);
  void generateNewFood(){
    food =randnum.nextInt(760);
  }
  void startGame(){
    snakepos=[45,65,85,105,125];
    const duration= Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {updateSnake();
    if(gameOver()){
      timer.cancel();
      _showGameOverScreen();
    }
    });
  }

  var direction = 'down';
  void updateSnake(){
    setState(() {
      switch(direction){
        case 'down': if(snakepos.last>740){
          snakepos.add(snakepos.last+20-760);
        }else snakepos.add(snakepos.last+20);
      break;
        case 'up': if(snakepos.last<20){
          snakepos.add(snakepos.last-20+760);
        }else snakepos.add(snakepos.last-20);
        break;
        case 'right': if((snakepos.last+1)%20==0){
          snakepos.add(snakepos.last+1-20);
        }else snakepos.add(snakepos.last+1);
        break;
        case 'left': if((snakepos.last%20)==0){
          snakepos.add(snakepos.last-1+20);
        }else snakepos.add(snakepos.last-1);
        break;
        default: break;
      }
      if(snakepos.last==food){
        generateNewFood();
      }else snakepos.removeAt(0);
    });
  }

  bool gameOver(){
    for(int i=0;i<snakepos.length;i++){
      int count=0;
      for(int j=0;j<snakepos.length;j++){
        if(snakepos[i]==snakepos[j]) count++;
        if(count==2) return true;
      }
    }return false;
  }

  void _showGameOverScreen(){
    showDialog(context: context, builder: (BuildContext context){
     return AlertDialog(
       title: Text('GaMe OVeR'),
       content: Text('your score: '+(((snakepos.length)*5)-25).toString(),
         style: TextStyle(color: Colors.pink),),
       actions: [
         TextButton(onPressed: (){
           startGame();
           Navigator.of(context).pop();
         }, child: Text('PLAY AGAIN')),
         TextButton(onPressed: ()=> SystemNavigator.pop(),
          child: Text('QUIT')),
       ],
     );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: GestureDetector(
                  onVerticalDragUpdate: (details){
                    if(direction!='up' && details.delta.dy>0){
                      direction='down';
                    }else if(direction!='down' && details.delta.dy<0){
                      direction='up';
                    }
                  },
                  onHorizontalDragUpdate: (details){
                    if(direction!='left' && details.delta.dx>0){
                      direction='right';
                    }else if(direction!='right' && details.delta.dx<0){
                      direction='left';
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width/25,
                        bottom: MediaQuery.of(context).size.width/10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 5)
                    ),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: sqnum,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20,
                      ),
                      itemBuilder: (BuildContext context,int index){
                        if(snakepos.contains(index)){
                          return Center(
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                        if(food==index){
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                        child: Container(
                        color: Colors.red,
                        ),
                        ),
                          );
                        }else {
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.grey[900],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )),
            Padding(padding: EdgeInsets.only(bottom: 20.0,left: 20.0,right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: startGame,
                  child: Text('start',
                    style: TextStyle(color: Colors.white),),
                ),
                GestureDetector(child: Text('stop',
                  style: TextStyle(color: Colors.white,),),
                  onTap: (){_showGameOverScreen();},),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
