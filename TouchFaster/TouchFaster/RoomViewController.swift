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
    
    var roomInfos : NSArray?
    var joinRoomName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Rooms"

        initBarButtons()
        initSocket()
    }
}

extension RoomViewController{   // Socket
    func initSocket(){
        
        SocketIOManager.shared.connect()
        
        SocketIOManager.shared.socket.on("roomList") { dataArray, ack in
            
            self.roomInfos = dataArray[0] as? NSArray
            self.tableView.reloadData()
        }
    }
}

extension RoomViewController{   // BarButton
    func initBarButtons(){
        let createRoomIcon : UIButton = UIButton.init(type: .custom)
        createRoomIcon.setImage(UIImage(systemName: "plus"), for: .normal)
        createRoomIcon.addTarget(self, action: #selector(createRoomDidTouched), for: .touchUpInside)
        createRoomIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let btnCreateRoom = UIBarButtonItem(customView: createRoomIcon)
        
        let loginUsersIcon : UIButton = UIButton.init(type: .custom)
        loginUsersIcon.setImage(UIImage(systemName: "person.3.fill"), for: .normal)
        loginUsersIcon.addTarget(self, action: #selector(createRoomDidTouched), for: .touchUpInside)
        loginUsersIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let btnLoginUsers = UIBarButtonItem(customView: loginUsersIcon)
        
        self.navigationItem.setRightBarButtonItems([btnCreateRoom, btnLoginUsers], animated: false)
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
          
            SocketIOManager.shared.socket.emit("createRoom", roomName)
            self.joinRoomName = roomName
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
        guard let gameVC = segue.destination as? GameViewController  else {
            return
        }
        gameVC.roomName = self.joinRoomName
        if segue.identifier == "createRoom"{
            if let gameVC = segue.destination as? GameViewController{
                gameVC.isRoomOwner = true
            }
        }
    }
}

extension RoomViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInfos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomCell
        
        cell.roomNumber.text = String(indexPath.row + 1)
        if let roomInfo = self.roomInfos?.getNSDict(indexPath.row) {
                cell.roomName.text = roomInfo["roomName"] as? String ?? ""
                
                let isEnabled = !(roomInfo["isFull"] as? Bool ?? false)
                cell.isUserInteractionEnabled = isEnabled
                cell.roomName.isEnabled = isEnabled
                cell.roomNumber.isEnabled = isEnabled
            }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SocketIOManager.shared.socket.emit("joinRoom", indexPath.row)
        if let roomInfo = self.roomInfos?.getNSDict(indexPath.row){
                self.joinRoomName = roomInfo["roomName"] as? String ?? ""
        }
        self.performSegue(withIdentifier: "joinRoom", sender: true)
    }
}
