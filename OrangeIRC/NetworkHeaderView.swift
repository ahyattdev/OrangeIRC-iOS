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

class NetworkHeaderView: UIView {
    
    var server: Server! = nil

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    static func loadFromNib(server: Server) -> NetworkHeaderView {
        let networkHeaderView = Bundle.main.loadNibNamed(String(describing: NetworkHeaderView.self), owner: self, options: nil)!.first as! NetworkHeaderView
        networkHeaderView.server = server
        
        networkHeaderView.label.text = server.displayName
        
        return networkHeaderView
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let actionSheet = ServerOptionsActionSheet(server: server, sourceView: sender)
        AppDelegate.splitView.present(actionSheet, animated: true, completion: nil)
    }
    
}
