// how to use it: http://stackoverflow.com/questions/1103148/how-do-i-make-uilabel-display-outlined-text/30918752#30918752

import UIKit

class UIOutlinedLabel: UILabel {

    var outlineWidth: CGFloat = 1
    var outlineColor: UIColor = UIColor.whiteColor()

    override func drawTextInRect(rect: CGRect) {

        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
        ]

        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawTextInRect(rect)
    }
}

