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
import OrangeIRCCore

class LogEventCell : UITableViewCell {
    
    let logEvent: LogEvent
    
    let dateLabel = UILabel()
    
    let content = UITextView()
    
    init(logEvent: LogEvent, reuseIdentifier: String?) {
        self.logEvent = logEvent
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(content)
        
        content.isEditable = false
        content.isScrollEnabled = false
        content.isSelectable = false
        content.dataDetectorTypes = .all
        
        let font = UIFont(name: "Menlo-Regular", size: 16)
        dateLabel.font = font
        content.font = font
        
        let df = DateFormatter()
        
        df.dateStyle = .none
        df.timeStyle = .short
        
        dateLabel.text = df.string(from: logEvent.date)
        
        content.attributedText = logEvent.attributedDescription
        
        let dlTop = NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .topMargin, multiplier: 1.0, constant: 0)
        let dlWidth = NSLayoutConstraint(item: dateLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70)
        let dlLeading = NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1.0, constant: 0)
        contentView.addConstraints([dlTop, dlWidth, dlLeading])
        
        let contentFirstBaseline = NSLayoutConstraint(item: content, attribute: .firstBaseline, relatedBy: .equal, toItem: dateLabel, attribute: .firstBaseline, multiplier: 1.0, constant: 0)
        let contentLeading = NSLayoutConstraint(item: content, attribute: .leading, relatedBy: .equal, toItem: dateLabel, attribute: .trailing, multiplier: 1.0, constant: 8)
        let contentTrailing = NSLayoutConstraint(item: content, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1.0, constant: 0)
        let contentBottom = NSLayoutConstraint(item: content, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottomMargin, multiplier: 1.0, constant: 0)
        contentView.addConstraints([contentFirstBaseline, contentLeading, contentTrailing, contentBottom])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
