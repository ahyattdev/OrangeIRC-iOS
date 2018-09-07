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

class ServerOptionsActionSheet : UIAlertController {
    
    let server: Server
    
    // No property is get-only if you try hard enough
    override var preferredStyle: UIAlertControllerStyle {
        return .actionSheet
    }
    
    init(server: Server, sourceView: UIView) {
        self.server = server
        super.init(nibName: nil, bundle: nil)
        
        popoverPresentationController?.sourceView = sourceView
        
        // Edits a server's settings
        let settings = UIAlertAction(title: localized("SETTINGS"), style: .default, handler: { a in
            let editor = ServerSettingsTableViewController(style: .grouped, edit: server)
            let nav = UINavigationController(rootViewController: editor)
            nav.modalPresentationStyle = .formSheet
            AppDelegate.splitView.present(nav, animated: true, completion: nil)
            
        })
        addAction(settings)
        
        if server.isConnectingOrRegistering || server.isRegistered {
            // Add a disconnect button
            let disconnect = localized("DISCONNECT")
            let disconnectAction = UIAlertAction(title: disconnect, style: .default, handler: { (action) in
                server.disconnect()
            })
            addAction(disconnectAction)
        } else {
            // Add a connect button
            let connect = localized("CONNECT")
            let connectAction = UIAlertAction(title: connect, style: .default, handler: { (action) in
                server.connect()
            })
            addAction(connectAction)
        }
        
        if server.motd != nil {
            // Add a show MOTD button
            let motd = localized("MOTD")
            let motdAction = UIAlertAction(title: motd, style: .default, handler: { (action) in
                let motdViewer = MOTDViewController(server)
                let nav = UINavigationController(rootViewController: motdViewer)
                nav.modalPresentationStyle = .pageSheet
                AppDelegate.splitView.present(nav, animated: true, completion: nil)
            })
            addAction(motdAction)
        }
        
        if server.isConnected {
            let joinAction = UIAlertAction(title: localized("JOIN_CHANNEL"), style: .default, handler: { a in
                AppDelegate.showAlertGlobally(JoinChannelAlertFactory.make(server: server))
            })
            addAction(joinAction)
            
            let chanlistAction = UIAlertAction(title: localized("CHANNEL_LIST"), style: .default, handler: { (action) in
                let chanlistTVC = ChannelListTableViewController(server)
                AppDelegate.showModalGlobally(chanlistTVC, style: .formSheet)
            })
            addAction(chanlistAction)
        }
        
        let deleteAction = UIAlertAction(title: localized("DELETE"), style: .destructive, handler: { a in
            ServerManager.shared.delete(server: server)
        })
        addAction(deleteAction)
        
        let cancel = localized("CANCEL")
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        addAction(cancelAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
