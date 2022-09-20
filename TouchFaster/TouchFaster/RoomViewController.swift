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
    
    var roomInfos = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Room List"
        initSocket()
    }
    
    func initSocket(){
        
        SocketIOManager.shared.connect()
        
        SocketIOManager.shared.socket.on("roomList") { dataArray, ack in
            
            let rooms = (dataArray[0] as! NSDictionary)["rooms"] as! NSArray
            
            var newRoomInfos = [[String : String]]()
            for room in rooms {
                let roomInfo = room as! NSDictionary
                let strRoomNumber = roomInfo["roomNumber"] as! String
                let strRoomName = roomInfo["roomName"] as! String
                newRoomInfos.append([strRoomNumber : strRoomName])
            }
            self.roomInfos = newRoomInfos
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
            let roomName = textField.text
          else { return }
          
            SocketIOManager.shared.socket.emit("makeRoom", roomName)
            self.performSegue(withIdentifier: "createRoom", sender: true)
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

extension RoomViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createRoom"{
            if let gameVC = segue.destination as? GameViewController{
                gameVC.isRoomOwner = true
            }
        }
    }
}

extension RoomViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        
        cell.roomNumber.text = self.roomInfos[indexPath.row].keys.first 
        cell.roomName.text = self.roomInfos[indexPath.row].values.first

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SocketIOManager.shared.socket.emit("joinRoom", indexPath.row)
        self.performSegue(withIdentifier: "createRoom", sender: true)
    }
}
