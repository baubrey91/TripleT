import XCTest
@testable import TripleT

class TripleTTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRowWin() throws {
        let viewModel = TTTViewModel()
        viewModel.boardSize = 3
        viewModel.board = Array(repeating: Array(repeating: TTTButton(), count: viewModel.boardSize), count: viewModel.boardSize)
        for column in 0..<viewModel.boardSize {
            viewModel.board[0][column].playState = .player
        }

        XCTAssert(viewModel.validateWin(lastPlayer: .player))
    }

    func testColumnWin() throws {
        let viewModel = TTTViewModel()
        viewModel.boardSize = 3
        viewModel.board = Array(repeating: Array(repeating: TTTButton(), count: viewModel.boardSize), count: viewModel.boardSize)
        for row in 0..<viewModel.boardSize {
            viewModel.board[row][0].playState = .player
        }

        XCTAssert(viewModel.validateWin(lastPlayer: .player))
    }
}
