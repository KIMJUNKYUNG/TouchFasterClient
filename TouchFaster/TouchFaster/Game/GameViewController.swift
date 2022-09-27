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
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    @IBOutlet weak var btnReady: UIButton!
    var isReady = false
    
    @IBOutlet weak var btnStart: UIButton!
    
    var gameZoneVC = GameZoneViewController(nibName: "GameZoneViewController", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        socketOn()
    }
    func socketOn(){
        SocketIOManager.shared.socket.on("roomReady") { _,_  in
            
        }
        SocketIOManager.shared.socket.on("gameReady") { dataArray, ack in
            let gameReady = dataArray[0] as! Bool
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
        if !isReady{
            isReady = true
            self.btnReady.backgroundColor = .yellow
        }else{
            isReady = false
            self.btnReady.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
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
 
