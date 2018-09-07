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

class ConsoleTableViewController: UITableViewController, ConsoleDelegate {
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        
        super.init(style: .plain)
        
        server.consoleDelegate = self
    }
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        title = server.displayName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if server.console.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: server.console.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return server.console.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let entry = server.console[indexPath.row]
        let label = UILabel()
        label.numberOfLines = 0
        label.text = entry.text
        if entry.sender == .Client {
            label.textColor = UIColor.orange
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        
        let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .topMargin, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: cell.contentView, attribute: .leadingMargin, multiplier: 1.0, constant: 0)
        
        let trailing = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: cell.contentView, attribute: .trailingMargin, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottomMargin, multiplier: 1.0, constant: 0)
        
        bottom.priority = UILayoutPriority(rawValue: 500)
        
        cell.contentView.addConstraints([top, bottom, leading, trailing])
        
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        
        return cell;
    }
    
    func newConsoleEntry(server: Server, entry: ConsoleEntry) {
        let lastRow = IndexPath(row: server.console.count - 1, section: 0)
        tableView.insertRows(at: [lastRow], with: .top)
        tableView.scrollToRow(at: lastRow, at: .bottom, animated: false)
    }
    
}
