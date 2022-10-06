//
//  RoomViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/12.
//

import UIKit
import SocketIO

class RoomViewController : UIViewController{
    @IBOutlet weak var roomTableView: UITableView!
    
    var roomInfos : NSArray?
    var joinRoomName : String?
    var nickName : String?
    
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        
        initTableView()
        initBarButtons()
        initSocket()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension RoomViewController{
    @IBAction func backBtnTouched(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func logOnUsers(_ sender: UIButton){
        self.performSegue(withIdentifier: "logOnUsers", sender: true)
    }
}

extension RoomViewController{   // Socket
    @objc func emitRoomList(){
        SocketIOManager.shared.socket.emit("roomList")
    }
    func initSocket(){
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(emitRoomList), userInfo: nil, repeats: true)
        SocketIOManager.shared.socket.on("roomList") { dataArray, ack in
            
            self.roomInfos = dataArray[0] as? NSArray
            self.roomTableView.reloadData()
        }
    }
}

extension RoomViewController{   // BarButton
    func initBarButtons(){
        let createRoomIcon : UIButton = UIButton.init(type: .custom)
        createRoomIcon.setImage(UIImage(systemName: "plus"), for: .normal)
        createRoomIcon.addTarget(self, action: #selector(createRoomDidTouched), for: .touchUpInside)
        createRoomIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        createRoomIcon.tintColor = .black
        let btnCreateRoom = UIBarButtonItem(customView: createRoomIcon)
        
//        let loginUsersIcon : UIButton = UIButton.init(type: .custom)
//        loginUsersIcon.setImage(UIImage(systemName: "person.3.fill"), for: .normal)
//        loginUsersIcon.addTarget(self, action: #selector(logOnUsers), for: .touchUpInside)
//        loginUsersIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        loginUsersIcon.tintColor = .black
//        let btnLoginUsers = UIBarButtonItem(customView: loginUsersIcon)
        
        self.navigationItem.setRightBarButtonItems([btnCreateRoom], animated: false)
        
        let leftLabel : UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftLabel.text = "Rooms"
        leftLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        let btnLeft = UIBarButtonItem(customView: leftLabel)
        
        self.navigationItem.setLeftBarButton(btnLeft, animated: false)
    }
    
    @objc func createRoomDidTouched(_ sender: UIBarButtonItem) {
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
            if let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController{
                gameVC.roomName = roomName
                gameVC.isRoomOwner = true
                gameVC.p1Name = self.nickName ?? ""
                self.present(gameVC, animated: true)
            }
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
    func initTableView(){
        roomTableView.backgroundColor = .systemGray6
        roomTableView.delegate = self
        roomTableView.dataSource = self
    }
    
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
            guard
                let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController,
                let roomName = roomInfo["roomName"] as? String
            else { return }
            
            gameVC.roomName = roomName
            gameVC.isRoomOwner = false
            self.present(gameVC, animated: true)
        }
    }
}
