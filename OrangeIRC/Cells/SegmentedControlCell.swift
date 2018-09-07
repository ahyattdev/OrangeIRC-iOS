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

class SegmentedControlCell : UITableViewCell {
    
    let segmentedControl = UISegmentedControl()
    
    init(segments: [String], target: AnyObject?, action: Selector?) {
        for i in 0 ..< segments.count {
            segmentedControl.insertSegment(withTitle: segments[i], at: i, animated: false)
        }
        
        if action != nil {
            segmentedControl.addTarget(target, action: action!, for: .valueChanged)
        }
        
        super.init(style: .default, reuseIdentifier: "")
        
        contentView.addSubview(segmentedControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        segmentedControl.frame = CGRect(x: separatorInset.left, y: separatorInset.top, width: contentView.frame.width - separatorInset.left - separatorInset.right, height: contentView.frame.height - separatorInset.top - separatorInset.bottom)
    }
    
}
