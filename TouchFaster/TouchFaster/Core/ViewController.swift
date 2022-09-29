//
//  ViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/12.
//

import UIKit

class ViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var btnLocal: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHomePageView()
    }
    let limitLength = 5
    
    func initHomePageView(){
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "hand.tap.fill")
        imageAttachment.bounds.size = CGSize(width: 25, height: 25)

        imageAttachment.image = UIImage(systemName: "hand.tap.fill")?.withTintColor(.systemGray6)

        let fullString = NSMutableAttributedString(string: "TOUCH FASTER ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        mainTitle.attributedText = fullString
        
        btnLocal.layer.cornerRadius = btnLocal.bounds.height / 3
        btnLocal.layer.borderWidth = 1
        btnLocal.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnOnline.layer.cornerRadius = btnLocal.bounds.height / 3
        btnOnline.layer.borderWidth = 1
        btnOnline.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnExit.layer.cornerRadius = btnLocal.bounds.height / 3
        btnExit.layer.borderWidth = 1
        btnExit.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
               let newLength = text.count + string.count - range.length
               return newLength <= limitLength
    }
    
    @IBAction func onlineButtonTouched(_ sender: UIButton) {
        if let roomsVC = storyboard?.instantiateViewController(withIdentifier: "Rooms") as? RoomViewController {
            let alert = UIAlertController(
              title: "Create Nickname",
              message: "limit Length : \(limitLength) ",
              preferredStyle: .alert
            )

            let joinAction = UIAlertAction(title: "Join", style: .default) { _ in
              guard
                let textField = alert.textFields?.first,
                let nickName = textField.text
              else { return }
                roomsVC.nickName = nickName
                self.navigationController?.pushViewController(roomsVC, animated: true)
            }

            let cancelAction = UIAlertAction(
              title: "Cancel",
              style: .default)

            alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "nickname"
                textField.delegate = self
            })
            alert.addAction(cancelAction)
            alert.addAction(joinAction)
            alert.preferredAction = joinAction
            
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func exitButtonTouched(_ sender: UIButton) {
        exit(0)
    }
}
