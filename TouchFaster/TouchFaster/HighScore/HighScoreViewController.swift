//
//  HighScoreViewController.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/10/05.
//

import UIKit

class HighScoreViewController: UIViewController {

    @IBOutlet weak var highScoreTableView: UITableView!
    
    var highScoreInfos : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "High Score"
        self.initTableView()
        
        SocketIOManager.shared.socket.emit("highScore")
        SocketIOManager.shared.socket.on("highScore") { dataArray, ack in
            if let hasData = dataArray[0] as? NSArray{
                self.highScoreInfos = hasData
                self.highScoreTableView.reloadData()
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.socket.off("highScore")
    }
}

extension HighScoreViewController : UITableViewDelegate, UITableViewDataSource{
    func initTableView(){
        
        highScoreTableView.delegate = self
        highScoreTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoreInfos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath) as! HighScoreCell
        
        cell.order.text = String(indexPath.row + 1)
        if let currentDict = self.highScoreInfos?.getNSDict(indexPath.row){
            cell.userName.text = currentDict["nickName"] as? String
            cell.time.text = currentDict["gameDoneTime"] as? String
        }
        
        return cell
    }
    
    
}
