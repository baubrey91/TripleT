import Foundation
import UIKit

enum PlayState {
    case unplayed
    case player
    case computer
}

final class TTTButton: UIButton {
    var playState: PlayState = .unplayed {
        didSet {
            switch playState {
            case .player:
                self.setImage(UIImage.xImage, for: .normal)
            case .computer:
                self.setImage(UIImage.oImage, for: .normal)
            default:
                self.setImage(nil, for: .normal)
            }
        }
    }
}
