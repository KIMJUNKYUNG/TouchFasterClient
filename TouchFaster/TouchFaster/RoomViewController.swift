//
//  RoomViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/12.
//

import UIKit
import SocketIO

class RoomViewController : UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    let socketManager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    var roomNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Room List"
//
//        socket = self.socketManager.socket(forNamespace: "/test")
//        socket.on("test"){ dataArray, ack in
//        }
//        socketManager.connect()
        initSocket()
    }
    
    func initSocket(){
        self.socket = self.socketManager.socket(forNamespace: "/")
        self.socket.connect()
        
        self.socket.on("roomList") { dataArray, ack in
            let roomNames = dataArray[0] as! NSArray
            var strRoomNames = [String]()
            for roomName in roomNames {
                let strRoomName = roomName as! String
                strRoomNames.append(strRoomName)
            }
            self.roomNames = strRoomNames
            self.tableView.reloadData()
        }
    }
    
    @IBAction func createRoomDidTouched(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
          title: "Create Room",
          message: "input Room Name",
          preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Create", style: .default) { _ in
          guard
            let textField = alert.textFields?.first,
            let text = textField.text
          else { return }
          
          self.socket.emit("makeRoom", text)
          self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(
          title: "Cancel",
          style: .cancel)

        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

extension RoomViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        
        cell.roomName.text = "Room \(indexPath.row) : " + self.roomNames[indexPath.row]

        return cell
    }
}
