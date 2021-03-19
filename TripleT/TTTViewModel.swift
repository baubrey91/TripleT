import Foundation

final class TTTViewModel {

    enum CurrentPlayer {
        case player
        case computer
        case over
    }

    var boardSize: Int = 3
    var currentPlayer: CurrentPlayer = .player

    lazy var board = Array(repeating: Array(repeating: TTTButton(), count: boardSize), count: boardSize)

    func computerTurn() {
        ///Look for a winning move
        var validMoves = [TTTButton]()
        for b in board {
            validMoves += b.filter  { $0.playState == .unplayed }
        }

        for validMove in validMoves {
            validMove.playState = .computer
            if validateWin(lastPlayer: .computer) {
                return
            }
            validMove.playState = .unplayed
        }

        ///If no winning move, look for a blocking move
        for validMove in validMoves {
            validMove.playState = .player
            if validateWin(lastPlayer: .player, markWin: false) {
                validMove.playState = .computer
                return
            }
            validMove.playState = .unplayed
        }


        ///Random Move
        let random = Int.random(in: 0..<validMoves.count)
        validMoves[random].playState = .computer
    }
    

    func validateWin(lastPlayer: PlayState, markWin: Bool = true) -> Bool {

        ///Checking rows

        for row in board {
            if row.filter({ $0.playState == lastPlayer }).count == boardSize {
                if markWin {
                    for b in row {
                        b.backgroundColor = .red
                    }
                    currentPlayer = .over
                }
                return true
            }
        }

        ///Checking Columns

        for column in 0..<boardSize {
            var vertical = [TTTButton]()
            for row in 0..<boardSize {
                if board[row][column].playState == lastPlayer {
                    vertical.append(board[row][column])

                } else {
                    //Leave for loop
                    break
                }
                if vertical.count == boardSize {
                    if markWin {

                        for button in vertical {
                            button.backgroundColor = .red
                        }
                        currentPlayer = .over
                    }
                    return true
                }
            }
        }

        ///Checking vertical wins

        //TODO: see if I can migrate these
        var downVertical = [TTTButton]()
        for index in 0..<boardSize {
            if board[index][index].playState == lastPlayer {
                downVertical.append(board[index][index])
            } else {
                //leave for loop
                break
            }
            if downVertical.count == boardSize {
                if markWin {

                    for b in downVertical {
                        b.backgroundColor = .red
                    }
                    currentPlayer = .over
                }
                return true
            }
        }
        

        var upVertical = [TTTButton]()
        //Can also use stride
        for index in 0..<boardSize {
            let uprightIndex = boardSize - index - 1
            if board[uprightIndex][index].playState == lastPlayer {
                upVertical.append(board[uprightIndex][index])
            } else {
                //leave for loop
            }
            if upVertical.count == boardSize {
                if markWin {
                    for b in upVertical {
                        b.backgroundColor = .red
                    }
                    currentPlayer = .over
                }
                return true
            }
        }
        return false
    }

    func resetBoard() {
        currentPlayer = .player
        for row in board {
            for button in row {
                button.playState = .unplayed
                button.backgroundColor = .gray
            }
        }

    }

    func changeBoardSize(boardSize: Int) {
        self.boardSize = boardSize
    }
}
