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

class SwitchCell : UITableViewCell {
    
    let `switch` = UISwitch()
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        
        contentView.addSubview(self.switch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.switch.frame.origin = CGPoint(x: contentView.frame.width - self.switch.frame.width - separatorInset.left - separatorInset.right, y: (contentView.frame.height - self.switch.frame.height) / 2)
        
        
        if let textLabel = textLabel {
            let otherWidth = separatorInset.left + separatorInset.right + self.switch.frame.width + 6
            if textLabel.intrinsicContentSize.width > otherWidth {
                textLabel.frame.size.width = contentView.frame.width - otherWidth
            }
        }
    }
    
}
