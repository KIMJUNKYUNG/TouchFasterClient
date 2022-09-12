//
//  ViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/08/17.
//

import UIKit
import SocketIO


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var gameZone: UIView!
    var circleButtons = [UIButton]()
    let exampleView = UIImageView()
    
    let socketManager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var socket : SocketIOClient!

    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for number in stride(from: 10, to: 0, by: -1){
            let circleButton = UIButton()
            circleButtons.append(circleButton)

            // Game Zone : 414, 818
            // view : 390, 844
            // Real Game Zone Size : 390, 763

            let gameZoneHeight = 763
            let gameZoneWidth = 390

            let circleHeight = 60
            let circleWidth = 60

            let randomY = Int.random(in: 0...(gameZoneHeight - circleHeight))
            let randomX = Int.random(in: 0...(gameZoneWidth - circleWidth))

            circleButton.frame = CGRect(x: randomX, y: randomY, width: circleWidth, height: circleHeight)
            circleButton.backgroundColor = .gray
            circleButton.layer.cornerRadius = circleButton.bounds.height / 2

            circleButton.setTitle("\(number)", for: .normal)
            circleButton.titleLabel?.font = .systemFont(ofSize: 25)

            if number == 1 {
                circleButton.backgroundColor = .red
                circleButton.addTarget(self, action: #selector(currentButtonTouched(_:)), for: .touchDown)
            }
            
            self.gameZone.addSubview(circleButton)
        }
        
//        socket = self.socketManager.socket(forNamespace: "/test")
//        socket.on("test"){ dataArray, ack in
//            let data = dataArray[0] as! NSDictionary
//
//            let x = NumberFormatter().number(from : (data["x"] as! String))
//            let y = NumberFormatter().number(from : (data["y"] as! String))
//
//            if let hasX = x, let hasY = y{
//            self.exampleView.frame = CGRect(x: CGFloat(truncating: hasX) - (100 / 2), y: CGFloat(truncating: hasY) - (100 / 2), width: 100, height: 100)
//            }
//        }
    }

    @objc func currentButtonTouched(_ sender : UIButton){
        circleButtons.removeLast()
        sender.removeFromSuperview()
        
        circleButtons.last?.backgroundColor = .red
        circleButtons.last?.addTarget(self, action: #selector(currentButtonTouched(_:)), for: .touchDown)
    }

    @IBAction func touchedInQueue(_ sender: UIButton) {
        socket.connect()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self.view)

            let roundX = (round(location.x * 100) / 100.0).description
            let roundY = (round(location.y * 100) / 100.0).description
            
//            socket.emit("test", ["x" : roundX, "y" : roundY])
        }
    }
}
 
