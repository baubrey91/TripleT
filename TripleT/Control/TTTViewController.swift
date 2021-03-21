import UIKit


// MARK: - Constants
fileprivate extension String {
    ///Localized incase we want to launch in another country
    static let playerLabel = NSLocalizedString("Player", comment: "player")
    static let computerLabel = NSLocalizedString("Computer", comment: "computer")
    static let currentSizeLabel = NSLocalizedString("Current Size", comment: "current size")
    static let firstPlayerLabel = NSLocalizedString("First Player", comment: "first player")
}

fileprivate extension Double {
    static let stepperMinimumValue: Double = 3
    static let stepperMaximumValue: Double = 25
}

fileprivate extension CGFloat {
    static let stackViewSpacing: CGFloat = 2
    static let padding: CGFloat = 20
}

fileprivate extension UIFont {
    static let TTTFont: UIFont = UIFont(name: "Avenir-Light", size: 20.0)!
}

final class TTTViewController: UIViewController {

    private var board: Board = Board(size: 3)
    private let boardView = UIView()
    private var computersTurn = false
    private var computerFirst = false

    private var playerScore = 0 {
        didSet {
            playerLabel.text = .playerLabel + " - \(playerScore)"
        }
    }
    private var computerScore = 0 {
        didSet {
            computerLabel.text = .computerLabel + " - \(computerScore)"
        }
    }

    // MARK: - Lazy vars

    private lazy var sizeStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = .stepperMinimumValue
        stepper.minimumValue = .stepperMinimumValue
        stepper.maximumValue = .stepperMaximumValue
        stepper.addTarget(self, action: #selector(changeBoardSize(stepper:)), for: .valueChanged)
        return stepper
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = .stackViewSpacing
        return stackView
    }()

    private lazy var firstPlayerLabel: UILabel = {
        let label = UILabel()
        label.font = .TTTFont
        label.text = .firstPlayerLabel
        return label
    }()

    private lazy var firstPlayerSwitch: UISwitch = {
        let playerSwitch = UISwitch()
        playerSwitch.isOn = true
        playerSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        return playerSwitch
    }()

    private lazy var boardSizeLabel: UILabel = {
        let label = UILabel()
        label.font = .TTTFont
        label.text = .currentSizeLabel + " - \(board.size)"
        return label
    }()

    private lazy var playerLabel: UILabel = {
        let label = UILabel()
        label.font = .TTTFont
        label.text = .playerLabel + " - \(playerScore)"
        return label
    }()

    private lazy var computerLabel: UILabel = {
        let label = UILabel()
        label.font = .TTTFont
        label.text = .computerLabel + " - \(computerScore)"
        return label
    }()

    private lazy var playersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [boardSizeLabel, firstPlayerLabel, firstPlayerSwitch, playerLabel, computerLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        view.addSubview(stackView)
        return stackView
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBoard()

        if computerFirst {
            firstMoveByComputer()
        }
    }

    // MARK: - UI Configuration

    private func configureBoard() {

        for row in 0..<board.size {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 2
            for column in 0..<board.size {

                let button = TTTButton()
                button.backgroundColor = .gray
                button.addTarget(self, action: #selector(playSquare(button:)), for: .touchUpInside)

                board.boardState[row][column] = button
                button.location = (row: row, column: column)
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
        ///Restart Button
        let restartButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetBoard))
        navigationItem.rightBarButtonItem = restartButton
        navigationItem.titleView = sizeStepper

        ///Board View
        boardView.backgroundColor = .black
        view.addSubview(boardView)

        let width = view.frame.width
        boardView.widthConstraint(width)
        boardView.heightConstraint(width)
        boardView.bottom(of: view, usingSafeArea: true)

        ///Scoreboard
        playersStackView.top(of: view, padding: .padding, usingSafeArea: true)
        playersStackView.left(equalTo: view, padding: .padding)
        playersStackView.right(equalTo: view, padding: .padding)
        playersStackView.above(view: boardView)
    }

    // MARK: - Helper
    private func firstMoveByComputer() {
        computersTurn = true
        DispatchQueue.global(qos: .background).async {
            let move = self.board.computersMove()
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                move.updateImage()
                strongSelf.computersTurn = false
            }
        }
    }

    // MARK: - Actions

    @objc func changeBoardSize(stepper: UIStepper) {
        computersTurn = false
        board = Board(size: Int(stepper.value))
        boardSizeLabel.text = .currentSizeLabel + " - \(board.size)"
        for stacks in verticalStackView.arrangedSubviews {
            stacks.removeFromSuperview()
        }
        configureBoard()
        if computerFirst {
            firstMoveByComputer()
        }
    }

    @objc func playSquare(button: TTTButton) {
        guard computersTurn == false, button.playState == .unplayed else { return }
        button.playState = .player
        button.updateImage()

        if let winningMoves = board.validateWin(lastPlayer: .player, lastMove: button.location) {
            for moves in winningMoves {
                moves.backgroundColor = .red
            }
            playerScore += 1
            return
        }

        //DRAW
        if board.validMoves.count == 0 { return }

        ///This might be a bit unnecessary but will help ensure the player doesn't move twice before the computer
        computersTurn = true

        DispatchQueue.global(qos: .background).async {
            let move = self.board.computersMove()
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                move.updateImage()
                if let winningMoves = strongSelf.board.validateWin(lastPlayer: .computer, lastMove: move.location) {
                    for moves in winningMoves {
                        moves.backgroundColor = .red
                    }
                    strongSelf.computerScore += 1
                    return
                }
                strongSelf.computersTurn = false
            }
        }
    }

    @objc private func resetBoard() {
        computersTurn = false
        board = Board(boardState: nil, size: board.size)
        for stacks in verticalStackView.arrangedSubviews {
            stacks.removeFromSuperview()
        }
        configureBoard()
        if computerFirst {
            firstMoveByComputer()
        }
    }

    @objc func switchValueDidChange(_ sender: UISwitch) {
        computerFirst = !sender.isOn
        resetBoard()
    }
}
