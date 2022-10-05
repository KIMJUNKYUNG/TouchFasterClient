//
//  GameZoneViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/27.
//

import UIKit

protocol GameZoneViewControllerDelegate : AnyObject {
    func passWinnerInfo(name : String, time : String)
    func passTimeInfo(time : String)
}

class GameZoneViewController: UIViewController {
    weak var delegate : GameZoneViewControllerDelegate?
    
    @IBOutlet weak var timerLabel: TimerLabel!
    var circleButtons = [UIButton]()
    
    let circleHeight = 60
    let circleWidth = 60
    var gameZoneHeight : Int?
    var gameZoneWidth : Int?
    
    var loadingView = UIView()
    var loadingLabel = UILabel()
    var loadingTimer : Timer?
    var loadingCount = 3
    
    var isSingle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timerLabel.text = ""
        self.view.backgroundColor = .systemGray6
        
        socketOn()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.gameStart()
    }
    override func viewDidLayoutSubviews() {
        gameZoneHeight = Int(self.view.bounds.height)
        gameZoneWidth = Int(self.view.bounds.width)
    }
    
    func socketOn(){
        SocketIOManager.shared.socket.on("multiGameDone"){ dataArray, ack in
            let winnerName = dataArray[0] as! String
            let gameDoneTime = dataArray[1] as! String
            
            self.timerLabel.pauseTimer(self)
            self.timerLabel.text = gameDoneTime
            
            self.delegate?.passWinnerInfo(name: winnerName, time: gameDoneTime)
            self.dismiss(animated: true)
        }
    }
    
    func gameStart(){
        guard
            let hasGameZoneHeight = gameZoneHeight,
            let hasGameZoneWidth = gameZoneWidth
        else {
            return
        }
        
        for number in stride(from: 10, to: 0, by: -1){
            let circleButton = UIButton()
            circleButtons.append(circleButton)
            
            let randomY = Int.random(in: 0...(hasGameZoneHeight - circleHeight))
            let randomX = Int.random(in: 0...(hasGameZoneWidth - circleWidth))
            
            circleButton.frame = CGRect(x: randomX, y: randomY, width: circleWidth, height: circleHeight)
            circleButton.backgroundColor = .gray
            circleButton.layer.cornerRadius = circleButton.bounds.height / 2

            circleButton.setTitle("\(number)", for: .normal)
            circleButton.titleLabel?.font = .systemFont(ofSize: 25)

            if number == 1 {
                circleButton.backgroundColor = .red
                circleButton.addTarget(self, action: #selector(currentButtonTouched(_:)), for: .touchDown)
            }
            
            self.view.addSubview(circleButton)
        }
        
        loadingView.frame = CGRect(x: 0, y: 0, width: hasGameZoneWidth, height: hasGameZoneHeight)
        loadingView.backgroundColor = .black
        self.view.addSubview(loadingView)
        
        loadingView.addSubview(loadingLabel)
        loadingLabel.frame = CGRect(x: 100, y: 200, width: 175, height: 50)
        
        loadingLabel.font = UIFont(name: "Noteworthy-Bold", size: 55)
        loadingLabel.textColor = .white
        
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
            SocketIOManager.shared.socket.emit("gameDone", self.timerLabel.currentTime(), isSingle)
            if isSingle{
                self.delegate?.passTimeInfo(time: self.timerLabel.currentTime())
                self.dismiss(animated: true)
            }
            return
        }
        
        circleButtons.last?.backgroundColor = .red
        circleButtons.last?.addTarget(self, action: #selector(currentButtonTouched(_:)), for: .touchDown)
    }

}
