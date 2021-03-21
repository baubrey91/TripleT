import XCTest
@testable import TripleT

class TripleTTests: XCTestCase {

    var board: Board!
    var size: Int!

    override func setUp() {
        board = Board(size: 3)
        size = 3
        board.boardState = Array(repeating: Array(repeating: TTTButton(), count: board.size), count: board.size)

        for row in 0..<size{
            for column in 0..<size {
                board.boardState[row][column].location = (row: row, column: column)
            }
        }
    }

    override func tearDown() {
        board = nil
        size = nil
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlayerRowWin() throws {
        var lastMove: TTTButton!
        for column in 0..<board.size {
            lastMove = board.boardState[0][column]
            lastMove.playState = .player
        }

        let winningSection = board.validateWin(lastPlayer: .player, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .player)
    }

    func testPlayerColumnWin() throws {
        var lastMove: TTTButton!
        for row in 0..<board.size {
            lastMove = board.boardState[row][0]
            lastMove.playState = .player
        }

        let winningSection = board.validateWin(lastPlayer: .player, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .player)
    }

    func testPlayerDownDiagonalWin() throws {
        var lastMove: TTTButton!
        for index in 0..<board.size {
            lastMove = board.boardState[index][index]
            lastMove.playState = .player
        }

        let winningSection = board.validateWin(lastPlayer: .player, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .player)
    }

    func testPlayerUpDiagonalWin() throws {
        var lastMove: TTTButton!
        for index in 0..<board.size {
            lastMove = board.boardState[board.size - 1 - index][index]
            lastMove.playState = .player
        }

        let winningSection = board.validateWin(lastPlayer: .player, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .player)
    }

    func testComputerRowWin() throws {
        var lastMove: TTTButton!
        for column in 0..<board.size {
            lastMove = board.boardState[0][column]
            lastMove.playState = .computer
        }

        let winningSection = board.validateWin(lastPlayer: .computer, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .computer)
    }

    func testComputerColumnWin() throws {
        var lastMove: TTTButton!
        for row in 0..<board.size {
            lastMove = board.boardState[row][0]
            lastMove.playState = .computer
        }

        let winningSection = board.validateWin(lastPlayer: .computer, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .computer)
    }

    func testComputerDownDiagonalWin() throws {
        var lastMove: TTTButton!
        for index in 0..<board.size {
            lastMove = board.boardState[index][index]
            lastMove.playState = .computer
        }

        let winningSection = board.validateWin(lastPlayer: .computer, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .computer)
    }

    func testComputerUpDiagonalWin() throws {
        var lastMove: TTTButton!
        for index in 0..<board.size {
            lastMove = board.boardState[board.size - 1 - index][index]
            lastMove.playState = .computer
        }

        let winningSection = board.validateWin(lastPlayer: .computer, lastMove: lastMove.location)
        XCTAssert(winningSection?.count == size && winningSection?.first?.playState == .computer)
    }
}
