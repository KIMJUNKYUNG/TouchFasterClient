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
    @IBOutlet weak var gameZone: UIView!
    var circleButtons = [UIButton]()
    
    var loadingView = UIView()
    var loadingLabel = UILabel()
    var loadingTimer : Timer?
    var loadingCount = 3
    
    @IBOutlet weak var timerLabel: TimerLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func gameStartButtonTouched(_ sender: Any) {
        gameStart()
    }
    func gameStart(){
        let gameZoneHeight = 753
        let gameZoneWidth = 390

        let circleHeight = 60
        let circleWidth = 60
        
        for number in stride(from: 10, to: 0, by: -1){
            let circleButton = UIButton()
            circleButtons.append(circleButton)

            // Game Zone : 414, 818
            // view : 390, 844
            // Real Game Zone Size : 390, 763

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
        
        loadingView.frame = CGRect(x: 0, y: 0, width: gameZoneWidth, height: gameZoneHeight)
        loadingView.backgroundColor = .lightGray
        self.gameZone.addSubview(loadingView)
        
        loadingView.addSubview(loadingLabel)
        loadingLabel.frame = CGRect(x: 100, y: 200, width: 175, height: 50)
        
        loadingLabel.font = .systemFont(ofSize: 25)
        
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        
        loadingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
    }
    
    @objc func countdownTimer()
    {
        if loadingCount == 0{
            self.loadingTimer?.invalidate()
            self.loadingLabel.removeFromSuperview()
            self.loadingView.removeFromSuperview()
            self.loadingCount = 3
            self.timerLabel.startTimer(self)
        }
        loadingLabel.text = String(loadingCount)
        loadingCount -= 1
    }

    @objc func currentButtonTouched(_ sender : UIButton){
        circleButtons.removeLast()
        sender.removeFromSuperview()
        if circleButtons.isEmpty{
            self.timerLabel.pauseTimer(self)
            return
        }
        
        circleButtons.last?.backgroundColor = .red
        circleButtons.last?.addTarget(self, action: #selector(currentButtonTouched(_:)), for: .touchDown)
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches{
//            let location = touch.location(in: self.view)
//
//            let roundX = (round(location.x * 100) / 100.0).description
//            let roundY = (round(location.y * 100) / 100.0).description
//
////            socket.emit("test", ["x" : roundX, "y" : roundY])
//        }
//    }
}
 
