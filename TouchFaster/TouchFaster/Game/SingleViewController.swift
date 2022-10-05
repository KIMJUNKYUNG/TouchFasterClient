//
//  SingleViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/10/05.
//

import UIKit

class SingleViewController: UIViewController {
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnHighScore: UIButton!
    @IBOutlet weak var btnQuit: UIButton!
    
    var gameDoneTime : String?
    @IBOutlet weak var gameDoneTimeLabel: UILabel!
    
    override func viewDidLoad() {
        btnStart.layer.cornerRadius = btnStart.bounds.height / 3
        btnStart.layer.borderWidth = 1
        btnStart.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnHighScore.layer.cornerRadius = btnHighScore.bounds.height / 3
        btnHighScore.layer.borderWidth = 1
        btnHighScore.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnQuit.layer.cornerRadius = btnQuit.bounds.height / 3
        btnQuit.layer.borderWidth = 1
        btnQuit.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let gameDoneTime = gameDoneTime {
            self.gameDoneTimeLabel.isHidden = false
            self.gameDoneTimeLabel.text = "Record : " + gameDoneTime
        }else{
            self.gameDoneTimeLabel.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func singleBtnTouched(_ sender: UIButton) {
        let gameZoneVC = GameZoneViewController(nibName: "GameZoneViewController", bundle: nil)
        gameZoneVC.modalTransitionStyle = .crossDissolve
        gameZoneVC.modalPresentationStyle = .fullScreen
        gameZoneVC.delegate = self
        gameZoneVC.isSingle = true
        self.present(gameZoneVC, animated: true)
    }
    @IBAction func highScoreBtnTouched(_ sender: Any) {
        if let highScoreVC = storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController") as? HighScoreViewController {
            
            self.navigationController?.pushViewController(highScoreVC, animated: true)
        }
    }
    @IBAction func quitBtnTouched(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SingleViewController : GameZoneViewControllerDelegate{
    func passWinnerInfo(name: String, time: String) {
        //only for Multi
    }
    
    func passTimeInfo(time: String) {
        gameDoneTime = time
    }
}
