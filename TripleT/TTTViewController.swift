import UIKit


// MARK: - Constants
fileprivate extension String {
    ///Localized incase we want to launch in another country
    static let newGame = NSLocalizedString("New Game", comment: "new game")
}

fileprivate extension Double {
    static let stepperMinimumValue: Double = 3
    static let stepperMaximumValue: Double = 25
}

fileprivate extension CGFloat {
    static let stackViewSpacing: CGFloat = 2
}

final class TTTViewController: UIViewController {

    private var viewModel: TTTViewModel = TTTViewModel()
    private var movesMade = 0
    private let boardView = UIView()

    // MARK: - Lazy vars

    lazy var sizeStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = .stepperMinimumValue
        stepper.minimumValue = .stepperMinimumValue
        stepper.maximumValue = .stepperMaximumValue
        stepper.addTarget(self, action: #selector(changeBoardSize(stepper:)), for: .valueChanged)
        return stepper
    }()

    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = .stackViewSpacing
        return stackView
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBoard()
    }

    // MARK: - UI Configuration

    private func configureBoard() {

        //TODO: This should be moved to viewModel
        viewModel.board = Array(repeating: Array(repeating: TTTButton(), count: viewModel.boardSize), count: viewModel.boardSize)
        
        for row in 0..<viewModel.boardSize {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 2
            for column in 0..<viewModel.boardSize {

                let button = TTTButton()
                button.backgroundColor = .gray
                button.addTarget(self, action: #selector(playSquare(button:)), for: .touchUpInside)

                viewModel.board[row][column] = button
                horizontalStackView.addArrangedSubview(button)
                horizontalStackView.alignment = .fill
                horizontalStackView.distribution = .fillEqually

            }
            verticalStackView.addArrangedSubview(horizontalStackView)
        }

        boardView.addSubview(verticalStackView)
        verticalStackView.pinEdges(to: boardView)
    }

    private func configureUI() {
        let restartButton = UIBarButtonItem(title: .newGame, style: .plain, target: self, action: #selector(resetBoard(button:)))
        navigationItem.rightBarButtonItem = restartButton
        navigationItem.titleView = sizeStepper

        boardView.backgroundColor = .black
        view.addSubview(boardView)
        let width = view.frame.width
        boardView.widthConstraint(width)
        boardView.heightConstraint(width)
        boardView.bottom(of: view, usingSafeArea: true)
    }

    // MARK: - Actions

    @objc func changeBoardSize(stepper: UIStepper) {
        movesMade = 0
        viewModel.changeBoardSize(boardSize: Int(stepper.value))
        for stacks in verticalStackView.arrangedSubviews {
            stacks.removeFromSuperview()
        }
        configureBoard()
    }

    @objc func playSquare(button: TTTButton) {
        //TODO: Major refactoring
        guard viewModel.currentPlayer == .player, button.playState == .unplayed else { return }
        button.playState = .player

        if viewModel.validateWin(lastPlayer: .player) { return }

        movesMade += 1
        ///This might be a bit unnecessary but will help ensure the player doesn't move twice before the computer
        viewModel.currentPlayer = .computer

        //TODO: This logic is wrong as it could be the final move
        guard movesMade < viewModel.boardSize * viewModel.boardSize else {
            print("Draw")
            return
        }
        viewModel.computerTurn()

        movesMade += 1
        if viewModel.validateWin(lastPlayer: .computer) { return }
        viewModel.currentPlayer = .player
    }

    @objc private func resetBoard(button: UIButton) {
        movesMade = 0
        viewModel.resetBoard()
    }
}
