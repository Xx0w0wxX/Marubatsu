import 'package:oktoast/oktoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool turnIsX = true;
  List<String> xo = List.generate(9, (i)=> '');

  final textStyle = GoogleFonts.kosugiMaru(
    textStyle: const TextStyle(color: Colors.white, fontSize: 20),
  );
  final errorStyle = GoogleFonts.kosugi(
    textStyle: const TextStyle(color: Colors.pinkAccent, fontSize: 20),
  );

  int scoreX = 0;
  int scoreO = 0;
  bool invalidClick = false;
  List<String> errorMessages = [
    '',
    '同じとこはあかん',
    'だからあかんて',
    'あかんゆーてるやろ'
  ];
  int invalidCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: OKToast(
          child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[800],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('プレイヤー X', style: textStyle),
                          Text(scoreX.toString(), style: textStyle),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('プレイヤー O', style: textStyle),
                          Text(scoreO.toString(), style: textStyle),
                        ],
                      ),
                    ],
                  ),
              ),
            ),
            Expanded(
              flex: 3,
                child: GridView.builder(
                padding: const EdgeInsets.all(35),
                itemCount: 9,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.8),
                ),
                itemBuilder: (BuildContext contect, int index){
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                      if (invalidClick){
                        showToast(
                          errorMessages[invalidCount],
                          duration: const Duration(milliseconds: 1500),
                          position: ToastPosition.top,
                          textStyle: errorStyle,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          radius: 3,
                        );
                      }
                    },
                      child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[700]),
                      ),
                      child: Center(
                        child: Text(
                          xo[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40
                        )
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[800],
                child: Center(
                  child: Text(
                    turnIsX? '``x`` のターン' : '``o`` のターン',
                    style: textStyle
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapped (int index) {
    setState(() {
      if (turnIsX && xo[index] == '') {
        xo[index] = 'x';
        turnIsX = !turnIsX;
        invalidClick = false;
      } else if (!turnIsX && xo[index] == '') {
        xo[index] = 'o';
        turnIsX = !turnIsX;
        invalidClick = false;
      } else if (xo[index] == 'x') {
        invalidClick = true;
        setErrorMessageCounter();
      } else if (xo[index] == 'o') {
        invalidClick = true;
        setErrorMessageCounter();
      }
      _checkWin();
    });
  }

  void setErrorMessageCounter () {
    if (invalidCount < 4) {
      invalidCount++;
    } else {
      invalidCount = 3;
    }
  }

  void _checkWin() {
    if(checkCol() || checkRow() || checkDiag()) {
      _showWinDialog(turnIsX? 'o' : 'x');
    }
  }

  bool checkCol(){
    for (var i = 0; i < 3; i++) {
      if(xo[i] == xo[i+3] && xo[i] == xo[i+6] && xo[i] != '') {
        return true;
      }
    }
    return false;
  }

  bool checkRow(){
    for (var i = 0; i < 7; i+=3) {
      if(xo[i] == xo[i+1] && xo[i] == xo[i+2] && xo[i] != '') {
        return true;
      }
    }
    return false;
  }

  bool checkDiag(){
      if(xo[0] == xo[4] && xo[0] == xo[8] && xo[0] != '') {
        return true;
      } else if(xo[2] == xo[4] && xo[2] == xo[6] && xo[2] != '') {
        return true;
      } else {
        return false;
      }
  }

  void _showWinDialog(String player) {
    showDialog<AlertDialog>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$player の勝ちやな'),
          actions: [
            FlatButton(
              child: const Text('もーやめたい'),
              onPressed: () {
                _resetBoard();
                var count = 0;
                Navigator.popUntil(context, (route) {
                    return count++ == 2;
                });
              },
            ),
            FlatButton(
              child: const Text('もっかいやろか'),
              onPressed: () {
                _resetBoard();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );

    if (player == 'x') {
      scoreX ++;
    } else if (player == 'o') {
      scoreO ++;
    }
  }

  void _resetBoard() {
    setState(() {
      xo = List.generate(9, (i)=> '');
    });
  }

}