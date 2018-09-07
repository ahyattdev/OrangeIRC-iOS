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

struct JoinChannelAlertFactory {
    
    static func make(server: Server) -> UIAlertController {
        let alert = UIAlertController(title: localized("JOIN_CHANNEL"), message: localized("JOIN_CHANNEL_DESCRIPTION"), preferredStyle: .alert)
        
        var channelField: UITextField!
        
        var actionDisabler: ActionDisabler?
        
        let cancel = UIAlertAction(title: localized("CANCEL"), style: .cancel, handler: { action in
            actionDisabler = nil
        })
        alert.addAction(cancel)
        
        let join = UIAlertAction(title: localized("JOIN"), style: .default, handler: { action in
            if let text = channelField.text {
                server.join(channel: text)
            }
            actionDisabler = nil
        })
        alert.addAction(join)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = localized("CHANNEL_NAME")
            
            // Just so the warning goes away. Yes, it is for a good reason
            if actionDisabler == nil {
                actionDisabler = ActionDisabler(action: join, textField: textField)
            }
            
            textField.returnKeyType = .next
            
            channelField = textField
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = localized("CHANNEL_KEY")
            textField.returnKeyType = .join
        })
        
        return alert
    }
}
