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

class ServerPasswordAlert : UIAlertController, UITextFieldDelegate {
    
    let server: Server
    
    var authenticate: UIAlertAction!, disconnect: UIAlertAction!
    var passwordField: UITextField!
    
    // No property is get-only if you try hard enough
    override var preferredStyle: UIAlertControllerStyle {
        return .alert
    }
    
    init(_ server: Server) {
        self.server = server
        super.init(nibName: nil, bundle: nil)
        
        title = localized("SERVER_PASSWORD_NEEDED")
        message = localized("SERVER_PASSWORD_NEEDED_DESCRIPTION").replacingOccurrences(of: "@SERVER@", with: server.displayName)
        
        disconnect = UIAlertAction(title: localized("DISCONNECT"), style: .destructive, handler: { a in
            self.server.disconnect()
        })
        addAction(disconnect)
        
        authenticate = UIAlertAction(title: localized("AUTHENTICATE"), style: .default, handler: { a in
            if let text = self.passwordField.text {
                self.server.password = text
                self.server.sendPassword()
            }
        })
        authenticate.isEnabled = false
        addAction(authenticate)
        
        addTextField(configurationHandler: { (textField) in
            self.passwordField = textField
            
            self.passwordField.isSecureTextEntry = true
            self.passwordField.delegate = self
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            // Let it be used as a password if it isn't empty
            authenticate.isEnabled = text.utf8.count - string.utf8.count > 0
        } else {
            authenticate.isEnabled = false
        }
        
        return true
    }
    
}
