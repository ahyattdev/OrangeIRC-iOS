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

class ChannelListTableViewController : UITableViewController {
    
    let server: Server
    
    var channelList: [ListChannel]!
    
    init(_ server: Server) {
        self.server = server
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelList = server.channelListCache
        
        title = localized("PUBLIC_CHANNELS")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: Notifications.listUpdatedForServer, object: server)
        NotificationCenter.default.addObserver(self, selector: #selector(finished), name: Notifications.listFinishedForServer, object: server)
        
        refresh()
        updatePrompt()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    @objc func updateList() {
        // We need to keep our own copy of the channel list
        channelList = server.channelListCache
        updatePrompt()
        tableView.reloadData()
    }
    
    @objc func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        navigationItem.leftBarButtonItem!.isEnabled = false
        server.fetchChannelList()
        tableView.reloadData()
    }
    
    @objc func finished() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        navigationItem.leftBarButtonItem!.isEnabled = true
        channelList = server.channelListCache
        updatePrompt()
        tableView.reloadData()
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func updatePrompt() {
        let channelsOn = channelList.count == 1 ? localized("CHANNELS_ON_SINGULAR") : localized("CHANNELS_ON_PLURAL")
        navigationItem.prompt = "\(channelList.count) \(channelsOn) \(server.displayName)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "RightDetailTextViewCell"
        var cell: RightDetailTextViewCell!
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: ID) as? RightDetailTextViewCell {
            cell = dequeuedCell
        } else {
            cell = Bundle.main.loadNibNamed(ID, owner: self, options: nil)!.first as! RightDetailTextViewCell
        }
        
        let channelData = channelList[indexPath.row]
        
        cell.title.text = channelData.name
        
        cell.accessoryType = .disclosureIndicator
        
        // Plurals
        var usersWord: String!
        if channelData.users == 1 {
            usersWord = localized("USER")
        } else {
            usersWord = localized("USERS")
        }
        cell.detail.text = "\(channelData.users) \(usersWord!)"
        
        cell.textView.text = channelData.topic
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelData = channelList[indexPath.row]
        dismiss(animated: true, completion: {
            self.server.join(channel: channelData.name)
        })
    }
    
}
