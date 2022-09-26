//
//  LogOnUsersViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/24.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    
    var logOnUserIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTableView()
        
        SocketIOManager.shared.socket.emit("userList")
        SocketIOManager.shared.socket.on("userList") { dataArray, ack in
            
            if let hasData = dataArray[0] as? NSArray{
                self.logOnUserIds = hasData as? [String] ?? [String]()
                self.userTableView.reloadData()
            }
        }
    }
}

extension UserViewController : UITableViewDelegate, UITableViewDataSource{
    func initTableView(){
        
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logOnUserIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        cell.userNumber.text = String(indexPath.row + 1)
        cell.userName.text = logOnUserIds[indexPath.row]
        return cell
    }
    
    
}
