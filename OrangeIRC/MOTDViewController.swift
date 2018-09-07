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

class MOTDViewController : UIViewController {
    
    let server: Server
    
    init(_ server: Server) {
        self.server = server
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.prompt = server.displayName
        title = localized("MOTD")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let textView = UITextView()
        
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.text = server.motd
        textView.font = UIFont.systemFont(ofSize: 17)
        
        view = textView
        
        // Scroll to the top
        textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
}
