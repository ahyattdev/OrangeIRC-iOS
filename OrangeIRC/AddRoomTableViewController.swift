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

class AddRoomTableViewController : UITableViewController {
    
    var autoJoinSetting = false
    var selectedServer: Server?
    var selectedRoomType: RoomType = .Channel
    var roomNameField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        title = localized("ADD_ROOM")
        
        // Close this when the escape key is pressed
        addKeyCommand(UIKeyCommand(input: UIKeyInputEscape, modifierFlags: UIKeyModifierFlags(rawValue: 0), action: #selector(cancel), discoverabilityTitle: localized("CANCEL")))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        roomNameField!.becomeFirstResponder()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Server to create the room on
            return ServerManager.shared.registeredServers.count
        case 1:
            // Room type
            return 2
        case 2:
            // Room name and autojoin
            if selectedRoomType == .Channel {
                return 2
            } else {
                return 1
            }
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return localized("SERVER")
        case 1:
            return localized("ROOM_TYPE")
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return localized("ADD_ROOM_SERVER_SECTION_DESCRIPTION")
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            
            let server = ServerManager.shared.registeredServers[indexPath.row]
            
            if indexPath.row == 0 && selectedServer == nil {
                selectedServer = server
            }
            
            if server == selectedServer! {
                cell.accessoryType = .checkmark
            }
            
            cell.textLabel!.text = server.displayName
            
            return cell
        case 1:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            
            switch indexPath.row {
            case 0:
                cell.accessoryType = selectedRoomType == .Channel ? .checkmark : .none
                cell.textLabel!.text = RoomType.Channel.localizedName()
            case 1:
                cell.accessoryType = selectedRoomType == .PrivateMessage ? .checkmark : .none
                cell.textLabel!.text = RoomType.PrivateMessage.localizedName()
            default:
                break
            }
            
            return cell
            
        case 2:
            switch indexPath.row {
            case 0:
                let cell = TextFieldCell()
                if roomNameField == nil {
                    roomNameField = cell.textField
                } else {
                    cell.contentView.willRemoveSubview(cell.textField)
                    cell.textField = roomNameField!
                    cell.contentView.addSubview(roomNameField!)
                }
                roomNameField!.becomeFirstResponder()
                roomNameField!.placeholder = localized("REQUIRED")
                cell.textLabel!.text = localized("ROOM_NAME")
                roomNameField!.autocorrectionType = .no
                roomNameField!.autocapitalizationType = .none
                return cell
                
            case 1:
                let cell = SwitchCell()
                cell.textLabel!.text = localized("AUTOMATICALLY_JOIN")
                cell.switch.isOn = autoJoinSetting
                cell.switch.addTarget(self, action: #selector(autojoinSwitchFlip(sender:event:)), for: .touchUpInside)
                return cell
                
            default:
                return super.tableView(tableView, cellForRowAt: indexPath)
            }
            
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            // The server list
            selectedServer = ServerManager.shared.registeredServers[indexPath.row]
            
            tableView.reloadSections(IndexSet(0 ..< 1), with: .automatic)
            
        case 1:
            // The room type
            switch indexPath.row {
            case 0:
                selectedRoomType = .Channel
            case 1:
                selectedRoomType = .PrivateMessage
            default:
                break
            }
            tableView.reloadSections(IndexSet(1 ... 2), with: .none)
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0, 1:
            return true
        default:
            return false
        }
    }
    
    @objc func autojoinSwitchFlip(sender: UISwitch, event: UIControlEvents) {
        autoJoinSetting = sender.isOn
    }
    
    @objc func cancel() {
        resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        guard roomNameField != nil && roomNameField!.text != nil && !roomNameField!.text!.isEmpty else {
            let title = localized("INVALID_ROOM_NAME")
            let message = localized("INVALID_ROOM_NAME_MESSAGE")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: localized("OK"), style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let name = roomNameField!.text!
        let server = selectedServer!
        
        if selectedRoomType == .Channel && !Channel.channelPrefixes.characterIsMember(unichar(name.utf8.first!)) {
            let title = localized("INVALID_ROOM_NAME")
            let message = localized("MISSING_CHANNEL_PREFIX")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: localized("OK"), style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if autoJoinSetting {
            server.roomsFlaggedForAutoJoin.append(name)
        }
        
        switch selectedRoomType {
        case .Channel:
            server.join(channel: name)
        case .PrivateMessage:
            server.startPrivateMessageSession(name)
            break
        }
        
        resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}
