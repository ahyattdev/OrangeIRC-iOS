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

class UsersSearchResultsController : UITableViewController, UISearchResultsUpdating {
    
    let room: Channel
    
    var filteredUsers = [User]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var nav: UINavigationController
    
    init(_ room: Channel, navigationController: UINavigationController) {
        self.room = room
        nav = navigationController
        
        super.init(style: .plain)
        
        // Because we can't pass in self before we call super.init
        // But we can't call super.init without initializing searchController
        // Big problem with Swift
        searchController = UISearchController(searchResultsController: self)
        searchController.searchResultsUpdater = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            filteredUsers.removeAll()
        } else {
            filteredUsers = room.users.filter {
                $0.nick.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        // The users list
        let user = filteredUsers[indexPath.row]
        cell.textLabel!.text = user.nick
        
        cell.textLabel!.textColor = user.color(room: room)
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        let userInfo = UserInfoTableViewController(user: user, server: room.server!)
        searchController.dismiss(animated: true, completion: nil)
        searchController.searchBar.text = nil
        nav.pushViewController(userInfo, animated: true)
    }
    
}
