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
    let exampleView = UIImageView()
    
    let socketManager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var socket : SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.view.backgroundColor = .blue
        print("width : ", self.view.bounds.width)
        print("height : ", self.view.bounds.height)
        // Do any additional setup after loading the view.
        
        let circle = UIImage(systemName: "circle")
        
        exampleView.image = circle
        
        exampleView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let exampleUIView = UIView()
        exampleUIView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        exampleUIView.backgroundColor = .gray
        
        self.gameZone.addSubview(exampleUIView)
        
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
