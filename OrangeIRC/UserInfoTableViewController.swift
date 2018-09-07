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

class UserInfoTableViewController : UITableViewController {
    
    let rowNames = [
        [
            localized("CLASS"),
            localized("AWAY_INFO")
        ], [
            localized("IP_ADDRESS"),
            localized("HOSTNAME"),
            localized("USERNAME"),
            localized("REAL_NAME")
        ], [
            localized("SERVER"),
            localized("ROOMS")
        ], [
            localized("CONNECTED"),
            localized("IDLE")
        ], [
            localized("PING"),
            localized("LOCAL_TIME"),
            localized("CLIENT_INFO")
        ]
    ]
    
    var rowData = [[String?]]()
    
    var user: User
    var server: Server
    
    init(user: User, server: Server) {
        // Populate rowData
        for i in 0 ..< rowNames.count {
            rowData.append([String?]())
            for _ in 0 ..< rowNames[i].count {
                rowData[i].append(nil)
            }
        }
        
        self.user = user
        self.server = server
        
        super.init(style: .grouped)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handle(_:)), name: Notifications.userInfoDidChange, object: user)
        server.fetchInfo(user)
    }
    
    func updateData() {
        // Class
        if let `class` = user.class {
            switch `class` {
                
            case .Operator:
                rowData[0][0] = localized("OPERATOR")
                
            case .Normal:
                rowData[0][0] = localized("NORMAL")
                
            }
        }
        
        // Away info
        if let away = user.away {
            if away, let awayMessage = user.awayMessage {
                rowData[0][1] = awayMessage
            } else {
                rowData[0][1] = localized("NOT_AWAY")
            }
        }
        
        // IP
        rowData[1][0] = user.ip
        
        // Host
        rowData[1][1] = user.host
        
        // Username
        rowData[1][2] = user.username
        
        // Realname
        rowData[1][3] = user.realname
        
        // Servername
        rowData[2][0] = user.servername
        
        // Rooms
        if let rooms = user.channelList {
            var roomStr = ""
            for room in rooms {
                roomStr.append("\(room) ")
            }
            if !roomStr.isEmpty {
                roomStr = String(roomStr[roomStr.startIndex ..< roomStr.index(before: roomStr.endIndex)])
            }
            rowData[2][1] = roomStr
        }
        
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        
        // Connected
        if let online = user.onlineTime {
            rowData[3][0] = formatter.string(from: online, to: now)
        }
        
        // Idle
        if let idle = user.idleTime {
            rowData[3][1] = formatter.string(from: idle, to: now)
        }
    }
    
    @objc func handle(_ notification: NSNotification) {
        if notification.name == Notifications.userInfoDidChange {
            updateData()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.nick
        navigationItem.prompt = server.displayName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rowNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNames[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let data = rowData[indexPath.section][indexPath.row] {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = rowNames[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = data
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            return cell
        } else {
            let cell = ActivityIndicatorCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = rowNames[indexPath.section][indexPath.row]
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return rowData[indexPath.section][indexPath.row] != nil
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)), let data = rowData[indexPath.section][indexPath.row] {
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = data
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
