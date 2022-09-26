//
//  ViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/12.
//

import UIKit

class ViewController : UIViewController, UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    let limitLength = 5
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
               let newLength = text.count + string.count - range.length
               return newLength <= limitLength
    }
    
    @IBAction func multiPlayButtonTouched(_ sender: UIButton) {
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
