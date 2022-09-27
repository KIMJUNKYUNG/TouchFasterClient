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
    
    @IBOutlet weak var player1: GameProfile!
    @IBOutlet weak var player2: GameProfile!
    
    
    var gameZoneVC = GameZoneViewController(nibName: "GameZoneViewController", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        socketOn()
    }
    func socketOn(){
        SocketIOManager.shared.socket.on("roomReady") { _,_  in
            
        }
        SocketIOManager.shared.socket.on("gameReady") { dataArray, ack in
            let readyInfo = dataArray[0] as! NSDictionary
            let p1Ready = readyInfo["p1"] as! Bool
            let p2Ready = readyInfo["p2"] as! Bool
            
            
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
                self.btnStart.isEnabled = true
            }else{
                self.btnStart.isEnabled = false
            }
        }
        SocketIOManager.shared.socket.on("gameStart") { _,_ in
            self.gameZoneVC.modalTransitionStyle = .crossDissolve
            self.gameZoneVC.modalPresentationStyle = .fullScreen
            self.present(self.gameZoneVC, animated: true)
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
        self.navigationController?.popViewController(animated: true)
    }
}
 
