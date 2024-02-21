//
//  WebSocketHelper.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 10/08/1445 AH.
//

import Foundation
class WebSocketHelper {
    var webSocketTask: URLSessionWebSocketTask!
    var url = URL(string: "wss://echo.websocket.org")
    var sendMessage = false
    init() {
        connect()
    }

    func connect() {
        let session = URLSession(configuration: .default)
        guard let url = url else {return}
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage()
    }

    func sendMessage(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
        sendMessage = true
    }

    func receiveMessage() {
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                    if self.sendMessage {
                        NotificationCenter.default.post(name: Notification.Name("receiveMessage"), object: nil, userInfo: ["Message": text])
                        self.sendMessage = false
                    }
                   
                case .data(let data):
                    print("Received data message: \(data)")
                @unknown default:
                    print("Unknown message type received")
                }
                self.receiveMessage() // Continue listening for messages
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        }
    }

    func disconnect() {
        webSocketTask.cancel()
        print("disconnect: ")
    }
}
