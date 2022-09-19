//
//  SocketIOManager.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/19.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    override init() {
        super.init()
        socket = manager.socket(forNamespace: "/")
    }

    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
}
