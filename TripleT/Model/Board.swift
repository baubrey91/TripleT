import Foundation

struct Board {
    init(boardState: [[TTTButton]]? = nil, size: Int) {
        self.size = size
        self.boardState = boardState ?? Array(repeating: Array(repeating: TTTButton(), count: size), count: size)
    }

    var boardState: [[TTTButton]]
    var size: Int

    var validMoves: [TTTButton] {
        return boardState.flatMap { $0.filter { $0.playState == .unplayed }}
    }

    func computersMove() -> TTTButton {
        guard ProcessInfo.processInfo.arguments.contains("MiniMaxAI") && size == 3 else { return DummyAI() }

        let bestResult = miniMax(game: self, player: .computer, depth: 0, lastMove: (row: -1, column: -1))
        guard let move = bestResult.move else {
            let random = Int.random(in: 0..<validMoves.count)
            let move = validMoves[random]
            move.playState = .computer
            return move
        }
        move.playState = .computer
        return move
    }


    func validateWin(lastPlayer: PlayState, lastMove: Location) -> [TTTButton]? {

        ///Checking row for win

        let row = boardState[lastMove.row]
        if row.filter({ $0.playState == lastPlayer }).count == size {
            return row
        }

        ///Checking Column for win

        let column = boardState.map { $0[lastMove.column]}
        if column.filter({ $0.playState == lastPlayer }).count == size {
            return column
        }

        ///Checking vertical wins

        if lastMove.row == lastMove.column {
            let diagonalOne: [TTTButton] = boardState.enumerated().map( { $1[$0] })
            if diagonalOne.filter( { $0.playState == lastPlayer } ).count == size {
                return diagonalOne
            }
        }

        if lastMove.row == (size - lastMove.column - 1) {
            let diagonalTwo = boardState.enumerated().map( { $1.reversed()[$0] })
            if diagonalTwo.filter( { $0.playState == lastPlayer } ).count == size {
                return diagonalTwo
            }
        }

        return nil
    }
}

//AI

extension Board {
    private func miniMax(game: Board, player: PlayState, depth: Int, lastMove: Location) -> (score: Int, move: TTTButton?) {
        var bestMove: TTTButton?
        var bestScore: Int = player == .computer ? Int.min : Int.max
        var score: Int

        if validMoves.count == 0 {
            return (0, bestMove)
        }

        let oppositePlayer: PlayState = player == .computer ? .player : .computer

        if lastMove != (row: -1, column: -1) && validateWin(lastPlayer: oppositePlayer, lastMove: lastMove) != nil {
            let depth = player == .computer ? depth - 10 : 10 - depth
            return (depth, bestMove)
        }

        for move in validMoves {
            move.playState = player
            score = miniMax(game: game, player: oppositePlayer, depth: depth + 1, lastMove: move.location).score
            switch player {
            //Maximize for computer
            case .computer:
                if score > bestScore {
                    bestScore = score
                    bestMove = move
                }
            case .player:
            //Minimize for player
                if score < bestScore {
                    bestScore = score
                    bestMove = move
                }
            default:
                break
            }
            move.playState = .unplayed
        }
        return (bestScore, bestMove)
    }

    private func DummyAI() -> TTTButton {
        ///Look for a winning move
        for move in validMoves {
            move.playState = .computer
            if validateWin(lastPlayer: .computer, lastMove: move.location) != nil {
                return move
            }
            move.playState = .unplayed
        }

        ///If no winning move, look for a blocking move
        for move in validMoves {
            move.playState = .player
            if validateWin(lastPlayer: .player, lastMove: move.location) != nil {
                move.playState = .computer
                return move
            }
            move.playState = .unplayed
        }

        ///Random Move
        let random = Int.random(in: 0..<validMoves.count)
        let move = validMoves[random]

        move.playState = .computer
        return move
    }
}
