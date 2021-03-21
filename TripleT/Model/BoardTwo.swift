//import Foundation
//
//struct Board {
//
//    enum CurrentPlayer {
//        case player
//        case computer
//        case over
//    }
//
//    enum PlayStatus {
//        case unplayed
//        case player
//        case computer
//
//        var opposite: PlayStatus {
//            switch self {
//            case .computer:
//                return .player
//            case .player:
//                return .computer
//            case .unplayed:
//                return .unplayed
//            }
//        }
//    }
//
//    init(boardState: [[PlayStatus]]? = nil, size: Int, turn: PlayStatus) {
//        self.boardState = boardState ?? Array(repeating: Array(repeating: .unplayed, count: size), count: size)
//        self.size = size
//        self.turn = turn
//    }
//
//
//    var size: Int
//    var boardState: [[PlayStatus]]
//    let turn: PlayStatus
//
//
//    var validMoves: Int {
//        return boardState.flatMap( { $0.filter { $0 == .unplayed } }).count
//    }
//
//    var isDraw: Bool {
//        return validMoves == 0 && !isWin()
//    }
//
//    func isWin() -> Bool {
//
//        ///Checking rows
//
//        for row in boardState {
//            if row.filter({ $0 == turn }).count == size {
//                return true
//            }
//        }
//
//        ///Checking Columns
//
//        for column in 0..<size {
//            var vertical = [PlayStatus]()
//            for row in 0..<size {
//                if boardState[row][column] == turn {
//                    vertical.append(boardState[row][column])
//
//                } else {
//                    //Leave for loop
//                    break
//                }
//                if vertical.count == size {
//                    return true
//                }
//            }
//        }
//
//        ///Checking vertical wins
//
//        //TODO: see if I can migrate these
//        var downVertical = [PlayStatus]()
//        for index in 0..<size {
//            if boardState[index][index] == turn {
//                downVertical.append(boardState[index][index])
//            } else {
//                //leave for loop
//                break
//            }
//            if downVertical.count == size {
//                return true
//            }
//        }
//
//
//        var upVertical = [PlayStatus]()
//        //Can also use stride
//        for index in 0..<size {
//            let uprightIndex = size - index - 1
//            if boardState[uprightIndex][index] == turn {
//                upVertical.append(boardState[uprightIndex][index])
//            } else {
//                break
//                //leave for loop
//            }
//            if upVertical.count == size {
//                return true
//            }
//        }
//        return false
//    }
//
//
//    ///---------------------------------------------//
//
//    func move(location: (row: Int, column: Int)) -> Board {
//        var tempPosition = boardState
//        tempPosition[location.row][location.column] = turn
//        let board = Board(boardState: tempPosition, size: size, turn: turn.opposite)
//        return board
//    }
//
//
//    func findBestMove(board: Board) -> (row: Int, column: Int) {
//        var bestEval = Int.min
//        var bestMove = (row: -1, column: -1)
//        for row in 0..<size {
//            for column in 0..<size {
//                if board.boardState[row][column] == .unplayed {
//                    let result = minimax(board.move(location: (row: row, column: column)), maximizing: false, originalPlayer: turn)
//                    if result > bestEval {
//                        bestEval = result
//                        bestMove = (row: row, column: column)
//                    }
//                }
//            }
//        }
//        return bestMove
//    }
//
//    // Find the best possible outcome for originalPlayer
//    func minimax(_ board: Board, maximizing: Bool, originalPlayer: PlayStatus) -> Int {
//        // Base case - evaluate the position if it is a win or a draw
//        if isWin() && turn == .computer { return -1 } // win
//        else if isWin() && turn == .player { return 1 } // loss
//        else if board.isDraw { return 0 } // draw
//
//
//        // Recursive case - maximize your gains or minimize the opponent's gains
//        if maximizing {
//            var bestEval = Int.min
//
//            for row in 0..<size {
//                for column in 0..<size {
//                    if board.boardState[row][column] == .unplayed {
//                        let result = minimax(board.move(location: (row: row, column: column)), maximizing: false, originalPlayer: originalPlayer)
//                        bestEval = max(result, bestEval)
//                    }
//                }
//            }
//            return bestEval
//        } else {
//
//            var worstEval = Int.max
//            for row in 0..<size {
//                for column in 0..<size {
//                    if board.boardState[row][column] == .unplayed {
//                        let result = minimax(board.move(location: (row: row, column: column)), maximizing: true, originalPlayer: originalPlayer)
//                        worstEval = min(result, worstEval)
//                    }
//                }
//            }
//            return worstEval
//        }
//
//
//
//
//
////            for move in board.validMoves { // find the move with the highest evaluation
////                let result = minimax(board.move(move), maximizing: false, originalPlayer: originalPlayer)
////                bestEval = max(result, bestEval)
////            }
////            return bestEval
////        } else { // minimizing
////            var worstEval = Int.max
////            for move in board.legalMoves {
////                let result = minimax(board.move(move), maximizing: true, originalPlayer: originalPlayer)
////                worstEval = min(result, worstEval)
////            }
////            return worstEval
////        }
//    }
//}
//
//
////    mutating func miniMax(game: Board, player: CurrentPlayer, depth: Int) -> (Int, TTTButton?) {
////
////        var bestMove: TTTButton?
////        var bestScore: Int = player == .computer ? Int.min : Int.max
////        var score: Int
////
////        let newBoard = game
////        if validateWin(lastPlayer: .computer) || validateWin(lastPlayer: .player) || validMoves.count == 0 {
////            return evaluateScore(depth: depth, bestMove: bestMove)
////        }
////
////        for move in newBoard.validMoves {
//////            let nextGameState: Board = Board(boardState: boardState, size: size)
//////            nextGameState.addMove(player, atPosition: move)
////
////            if (player == .computer){
////                move.playState = .computer
////
////                score = miniMax(game: game, player: .player, depth: depth + 1).0
////                //Maxmizes for the computer
////                if score > bestScore {
////                    bestScore = score
////                    bestMove = move
////                }
//////                move.playState = .unplayed
////            } else {
////                move.playState = .player
////
////                score = miniMax(game: game, player: .computer, depth: depth + 1).0
////                //Minimizes for the player
////                if score < bestScore {
////                    bestScore = score
////                    bestMove = move
////                }
//////                move.playState = .unplayed
////
////            }
////        }
////
////        return (bestScore, bestMove)
////    }
////
////    private mutating func evaluateScore(depth: Int, bestMove: TTTButton?) -> (Int, TTTButton?) {
////        if validateWin(lastPlayer: .player) {
////            return (depth - 10, bestMove)
////        } else {
////            if validateWin(lastPlayer: .computer){
////                return (10 - depth, bestMove)
////            } else {
////                return (0, bestMove)
////            }
////        }
////    }
//
////    mutating func miniMax(board: [[TTTButton]], maximizing: Bool, originalPlayer: CurrentPlayer) -> Int {
////
////        if isWin(lastPlayer: .computer) {
////            return 1
////        }
////        if isWin(lastPlayer: .player) {
////            return -1
////        }
////        if validMoves.isEmpty {
////            return 0
////        }
////
////        let newBoard = Board(boardState: board, size: size)
////
////        if maximizing {
////            var bestEval = Int.min
////            for move in newBoard.validMoves { // find the move with the highest evaluation
////                move.playState = .computer
////                let result = miniMax(board: board, maximizing: false, originalPlayer: originalPlayer)
////                bestEval = max(result, bestEval)
//////                move.playState = .unplayed
////
////            }
////            return bestEval
////        } else { // minimizing
////            var worstEval = Int.max
////            for move in newBoard.validMoves {
////                move.playState = .player
////                let result = miniMax(board: board, maximizing: true, originalPlayer: originalPlayer)
////                worstEval = min(result, worstEval)
//////                move.playState = .unplayed
////            }
////            return worstEval
////        }
////    }

