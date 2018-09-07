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

class ActionDisabler: NSObject, UITextFieldDelegate {
    
    let action: UIAlertAction
    
    var deallocationPreventer: ActionDisabler?
    
    init(action: UIAlertAction, textField: UITextField) {
        self.action = action
        
        super.init()
        
        self.deallocationPreventer = self
        textField.delegate = self
        
        // Initialize it as enabled or disabled
        if let text = textField.text {
            action.isEnabled = !text.isEmpty
        } else {
            action.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ugly Foundation code
        var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        
        // UITextFields silently get rid of \n
        newString = newString.replacingOccurrences(of: "\n", with: "")
        
        action.isEnabled = !newString.isEmpty
        
        return true
    }
}
