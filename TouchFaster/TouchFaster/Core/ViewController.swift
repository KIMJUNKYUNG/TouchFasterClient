//
//  ViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/12.
//

import UIKit

class ViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var mainTitle: UILabel!
    
    var joinAction = UIAlertAction()
    
    @IBOutlet weak var btnSingle: UIButton!
    @IBOutlet weak var btnMulti: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    
    var nickName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOManager.shared.connect()
        SocketIOManager.shared.socket.on("connection"){ _,_ in
            self.alertInsertNickName()
        }

        initHomePageView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    let limitLength = 5
    
    func alertInsertNickName(){
        let alert = UIAlertController(
          title: "Create Nickname",
          message: "limit Length : \(limitLength) ",
          preferredStyle: .alert
        )

        joinAction = UIAlertAction(title: "Join", style: .default) { _ in
          guard
            let textField = alert.textFields?.first,
            let nickName = textField.text
          else { return }
            self.nickName = nickName
            SocketIOManager.shared.socket.emit("nickName", self.nickName ?? "")
            self.btnSingle.isEnabled = true
            self.btnMulti.isEnabled = true
        }
        joinAction.isEnabled = false

        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "nickname"
            textField.delegate = self
        })
        alert.addAction(joinAction)
        alert.preferredAction = joinAction
        
        present(alert, animated: true, completion: nil)
    }
    
    func initHomePageView(){
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "hand.tap.fill")
        imageAttachment.bounds.size = CGSize(width: 25, height: 25)

        imageAttachment.image = UIImage(systemName: "hand.tap.fill")?.withTintColor(.systemGray6)

        let fullString = NSMutableAttributedString(string: "TOUCH FASTER ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        mainTitle.attributedText = fullString
        
        btnSingle.layer.cornerRadius = btnSingle.bounds.height / 3
        btnSingle.layer.borderWidth = 1
        btnSingle.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnMulti.layer.cornerRadius = btnMulti.bounds.height / 3
        btnMulti.layer.borderWidth = 1
        btnMulti.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnExit.layer.cornerRadius = btnExit.bounds.height / 3
        btnExit.layer.borderWidth = 1
        btnExit.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string) as NSString
        if  newString != ""{
            joinAction.isEnabled = true
        } else {
            joinAction.isEnabled = false
        }
        
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    @IBAction func singleButtonTouched(_ sender: Any) {
        guard let singleVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleViewController") as? SingleViewController
        else { return }
        
        self.navigationController?.pushViewController(singleVC, animated: true)
    }
    @IBAction func multiButtonTouched(_ sender: UIButton) {
        if let roomsVC = storyboard?.instantiateViewController(withIdentifier: "Rooms") as? RoomViewController {
            
            roomsVC.nickName = nickName
            self.navigationController?.pushViewController(roomsVC, animated: true)
        }
    }
    @IBAction func exitButtonTouched(_ sender: UIButton) {
        exit(0)
    }
}
