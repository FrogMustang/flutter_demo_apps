import 'package:flutter/material.dart';
import 'package:flutter_demo_apps/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  /// set the board size to be [_gridSize] X [_gridSize]
  final int _gridSize = 3;

  /// used to keep track of the values in the squares of the board
  late List<List<String>> board;

  /// used to keep track of the state of the game
  late GameState _gameState;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    // fill the board with empty values
    board =
        List.generate(_gridSize, (x) => List.generate(_gridSize, (y) => ""));

    // initialise game state
    // set O as the last player to move because, theoretically,
    // X should start and therefore, the last play was made by O
    _gameState = GameState("O", Winner.none, false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _gameState.lastTurn == "X"
            ? Colors.lightBlue.withOpacity(0.5)
            : Colors.amber[700]?.withOpacity(0.7),
        body: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            /// SCREEN TITLE
            _gameState.winner == Winner.X
                ? Text(
                    "X won the game",
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                : _gameState.winner == Winner.Y
                    ? Text(
                        "O won the game",
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                    : _gameState.ended
                        ? Text(
                            "It's a tie!".toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          )
                        : SizedBox(height: 40.sp),

            SizedBox(height: 80.h),
            const Spacer(),

            /// GAME BOARD
            SizedBox(
              height: 0.6.sh,
              width: 1.sw,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: ScrollConfiguration(
                  behavior: NoMoreGlow(),
                  child: GridView.builder(
                    // make sure can't scroll the board
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                    ),
                    itemBuilder: _buildSquare,

                    /// set grid shape to square
                    itemCount: _gridSize * _gridSize,
                  ),
                ),
              ),
            ),
            const Spacer(),

            _gameState.ended
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initGame();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _gameState.lastTurn == "X"
                          ? Colors.lightBlue
                          : Colors.amber,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.r,
                        vertical: 10.r,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "Restart",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.sp,
                      ),
                    ),
                  )
                : SizedBox(height: 50.sp),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSquare(context, index) {
    /// get the row and column index
    int x = (index / _gridSize).floor();
    int y = (index % _gridSize);

    return Padding(
      padding: EdgeInsets.all(5.r),
      child: ElevatedButton(
        onPressed: () =>  board[x][y] == "" || !_gameState.ended
            ? _squarePressed(x, y)
            : null,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent,
          backgroundColor: board[x][y] == ""
              ? Colors.white
              : board[x][y] == "X"
                  ? Colors.amber
                  : Colors.lightBlue,
          foregroundColor: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        child: Text(
          board[x][y],
          style: TextStyle(
            fontSize: 26.sp,
          ),
        ),
      ),
    );
  }

  _squarePressed(int x, int y) {
    /// check if the button can be pressed
    /// so if the value is ""
    if (board[x][y] == "") {
      board[x][y] = _gameState.lastTurn == "X" ? "O" : "X";
      if (!_checkGameWon(x, y)) {
        setState(() {
          _gameState.lastTurn = _gameState.lastTurn == "X" ? "O" : "X";
        });
      }
    }
  }

  /// check if someone won the game and who
  bool _checkGameWon(int x, int y) {
    int n = _gridSize;
    int row = 0;
    int col = 0;
    int mainDiagonal = 0;
    int secondDiagonal = 0;

    debugPrint("Checking for square $x, $y. Turn: ${_gameState.lastTurn}");

    String lastTurn = _gameState.lastTurn == "X" ? "O" : "X";
    // String _lastTurn = _gameState.lastTurn;

    /// only have to search the board from the current selected square
    for (int i = 0; i < n; i++) {
      /// check rows
      if (board[x][i] == lastTurn) row++;

      /// check columns
      if (board[i][y] == lastTurn) col++;

      // check main diagonal
      if (board[i][i] == lastTurn) mainDiagonal++;

      // check second diagonal
      if (board[i][n - i - 1] == lastTurn) secondDiagonal++;
    }

    if (row == n || col == n || mainDiagonal == n || secondDiagonal == n) {
      setState(() {
        _gameState.winner = lastTurn == "X" ? Winner.X : Winner.Y;
        _gameState.ended = true;
      });
      return true;
    } else if (!board.any((x) => x.contains(""))) {
      /// check if the board has any empty squares left
      /// if not, then it's a tie
      setState(() {
        _gameState.winner = Winner.none;
        _gameState.ended = true;
      });
      return true;
    }

    return false;
  }
}

enum Winner {
  X,
  Y,
  none,
}

class GameState {
  String lastTurn;
  Winner winner;
  bool ended;

  GameState(this.lastTurn, this.winner, this.ended);
}
