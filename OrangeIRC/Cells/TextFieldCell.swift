// This file of part of the iOS IRC client application OrangeIRC.
//
// Copyright © 2016 Andrew Hyatt
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import UIKit
@IBDesignable

class TextFieldCell : UITableViewCell {
    
    var textField = UITextField()
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let textLabel = textLabel {
            // There is a label, and it should take up 2/5
            let separation: CGFloat = 6
            let labelWidth = (contentView.frame.width - separatorInset.left - separatorInset.right) * 0.4 - separation
            let fieldWidth = (contentView.frame.width - separatorInset.left - separatorInset.right) * 0.6 - separation
            textLabel.frame = CGRect(x: separatorInset.left, y: (contentView.frame.height - textLabel.frame.height) / 2, width: labelWidth, height: textLabel.frame.height)
            
            textField.frame = CGRect(x: labelWidth + separation + separatorInset.left, y: separatorInset.top, width: fieldWidth, height: contentView.frame.height - separatorInset.top - separatorInset.bottom)
        } else {
            // There is no label. Take up the whole cell. 
            textField.frame = CGRect(x: separatorInset.right, y: (contentView.frame.height - textField.frame.height) / 2, width: contentView.frame.width - separatorInset.left - separatorInset.right, height: textField.frame.height)
        }
    }
    
}
