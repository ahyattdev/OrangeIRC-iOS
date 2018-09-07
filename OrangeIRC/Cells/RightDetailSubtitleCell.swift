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

class RightDetailSubtitleCell : UITableViewCell {
    
    var title = UILabel(), subtitle = UILabel(), detail = UILabel()
    
    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        subtitle.font = UIFont.systemFont(ofSize: 12)
        detail.textAlignment = .right
        
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(detail)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleWidth = title.intrinsicContentSize.width
        let subtitleWidth = subtitle.intrinsicContentSize.width
        let detailWidth = detail.intrinsicContentSize.width
        
        let minSeperation: CGFloat = 6
        
        let maxWidth = contentView.frame.width - separatorInset.left - separatorInset.right - minSeperation
        
        var titleDestWidth = titleWidth, subtitleDestWidth = subtitleWidth, detailDestWidth = detailWidth
        
        if titleWidth + detailWidth > maxWidth || subtitleWidth + detailWidth > maxWidth {
            if titleWidth > maxWidth * (2 / 3) || subtitleWidth > maxWidth * (2 / 3) {
                titleDestWidth = titleWidth > maxWidth * (2 / 3) ? maxWidth * (2 / 3) : titleWidth
                subtitleDestWidth = subtitleWidth > maxWidth * (2 / 3) ? maxWidth * (2 / 3) : subtitleWidth
                detailDestWidth = detailWidth > maxWidth * ( 1 / 3) ? maxWidth * ( 1 / 3) : detailWidth
            } else {
                let largest = titleWidth > subtitleWidth ? titleWidth : subtitleWidth
                detailDestWidth = maxWidth - largest
            }
        }
        
        title.frame = CGRect(x: separatorInset.left, y: 5, width: titleDestWidth, height: 20.5)
        subtitle.frame = CGRect(x: separatorInset.left, y: 25.5, width: subtitleDestWidth, height: 14.5)
        detail.frame = CGRect(x: contentView.frame.width - detailDestWidth - separatorInset.right, y: 12, width: detailDestWidth, height: 20.5)
    }
    
}
