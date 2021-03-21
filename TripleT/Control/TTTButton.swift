import Foundation
import UIKit

enum PlayState {
    case unplayed
    case player
    case computer
}
typealias Location = (row: Int, column: Int)

final class TTTButton: UIButton {
    var location: Location = (row: -1, column: -1)
    var playState: PlayState = .unplayed

    ///Originally I had the image updated via the Play State but thought this is inefficient during the miniMax AI as the state is constantly updated. If not using the MiniMax you can use the observer and remove the update image functioon
    /*
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
 */

    func updateImage() {
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
