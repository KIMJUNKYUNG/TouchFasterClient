//
//  GameViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/08/17.
//

import UIKit

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

class GameViewController: UIViewController {
    var isRoomOwner = false
    var roomName : String?
    var isReady = false
    
    @IBOutlet weak var btnReady: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnQuit: UIButton!
    
    var p1Name : String?
    var p2Name : String?
    @IBOutlet weak var player1: GameProfile!
    @IBOutlet weak var player2: GameProfile!
    
    var winnerName : String?
    var gameDoneTime : String?
    @IBOutlet weak var winnerNameLabel: UILabel!
    @IBOutlet weak var gameDoneTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGameRoomView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        socketOn()
        updateReadyCondition(p1Ready: false, p2Ready: false)
        if let winnerName = winnerName,
           let gameDoneTime = gameDoneTime{
            self.winnerNameLabel.isHidden = false
            self.gameDoneTimeLabel.isHidden = false
            self.winnerNameLabel.text = "WINNER : " + winnerName
            self.gameDoneTimeLabel.text = gameDoneTime
        }else{
            self.winnerNameLabel.isHidden = true
            self.gameDoneTimeLabel.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketOff()
    }
    
    func initGameRoomView(){
        btnStart.layer.cornerRadius = btnReady.bounds.height / 3
        btnStart.layer.borderWidth = 1
        btnStart.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnReady.layer.cornerRadius = btnReady.bounds.height / 3
        btnReady.layer.borderWidth = 1
        btnReady.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnQuit.layer.cornerRadius = btnQuit.bounds.height / 3
        btnQuit.layer.borderWidth = 1
        btnQuit.layer.borderColor = UIColor.systemGray6.cgColor
    }
    func socketOn(){
        SocketIOManager.shared.socket.on("roomCondition") { dataArray, ack in
            let roomCondition = dataArray[0] as! NSDictionary
            
            if let p1Name = roomCondition["ownerNickName"] as? String{
                self.player1.nickName.text = p1Name
                self.player1.nickName.textColor = .white
            }else{
                self.player1.nickName.text = "empty"
                self.player1.nickName.textColor = .systemGray
            }
            
            if let p2Name = roomCondition["clientNickName"] as? String{
                self.player2.nickName.text = p2Name
                self.player2.nickName.textColor = .white
            }else{
                self.player2.nickName.text = "empty"
                self.player2.nickName.textColor = .systemGray
            }
            
            let p1Ready = roomCondition["ownerReady"] as! Bool
            let p2Ready = roomCondition["clientReady"] as! Bool
            
            self.updateReadyCondition(p1Ready: p1Ready, p2Ready: p2Ready)
        }
        SocketIOManager.shared.socket.on("gameStart") { _,_ in
            let gameZoneVC = GameZoneViewController(nibName: "GameZoneViewController", bundle: nil)
            gameZoneVC.modalTransitionStyle = .crossDissolve
            gameZoneVC.modalPresentationStyle = .fullScreen
            gameZoneVC.delegate = self
            gameZoneVC.isSingle = false
            self.present(gameZoneVC, animated: true)
        }
        SocketIOManager.shared.socket.on("roomClosed") { _,_ in
            let alert = UIAlertController(
              title: "Room Closed",
              message: "Room Owner Quit the Room",
              preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }
            
            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func socketOff(){
        SocketIOManager.shared.socket.off("roomCondition")
        SocketIOManager.shared.socket.off("gameStart")
        SocketIOManager.shared.socket.off("roomClosed")
    }
    
    func updateReadyCondition(p1Ready : Bool, p2Ready : Bool){
        if p1Ready{
            self.player1.ready.textColor = .orange
        }else{
            self.player1.ready.textColor = .systemGray
        }
        if p2Ready{
            self.player2.ready.textColor = .orange
        }else{
            self.player2.ready.textColor = .systemGray
        }
        
        let gameReady = p1Ready && p2Ready
        if self.isRoomOwner && gameReady{
            self.btnStart.isHidden = false
        }else{
            self.btnStart.isHidden = true
        }
    }
    
    @IBAction func readyButtonTouched(_ sender: Any) {
        isReady = !isReady
        SocketIOManager.shared.socket.emit("ready", isRoomOwner, isReady)
    }
    @IBAction func startButtonTouched(_ sender: Any) {
        SocketIOManager.shared.socket.emit("gameStart")
    }
    @IBAction func quitButtonTouched(_ sender: Any) {
        SocketIOManager.shared.socket.emit("quitRoom", isRoomOwner, roomName ?? "")
        self.dismiss(animated: true)
    }
}
 
extension GameViewController : GameZoneViewControllerDelegate {
    func passWinnerInfo(name: String, time: String) {
        winnerName = name
        gameDoneTime = time
    }
    func passTimeInfo(time: String) {
        //only for Single
    }
}
