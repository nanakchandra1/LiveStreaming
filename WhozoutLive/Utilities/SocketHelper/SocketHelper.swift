
import UIKit
import Starscream


enum SocketName : String{
    
    case BroadcastComment = "broadcastComment"
    
    
}

class SocketHelper: NSObject {
    
    var socket = WebSocket(url: URL(string: URLName.kSocketUrl)!, protocols: ["chat"])

    
    class var sharedInstance : SocketHelper {
        
        struct Static {
            static let instance : SocketHelper = SocketHelper()
        }
        return Static.instance
    }

    
    override init() {
        
    }
    
    func connectSocket(){
    
        self.socket.headers["userId"] = CurentUser.userId
        self.socket.headers["accesstoken"] = CurentUser.accessToken
        
        self.socket.connect()
        
        printDebug(object: "write here")
        
        CommonFunction.delayy(delay: 0.1) {
          //  self.socket.write(string: "hi gurpreet is writing")

        }
        
        printDebug(object: "not connected")
        
    }
    
    
    func writeToSocket(text:String){
        
        printDebug(object: "jsonString-----\(text)")
        
//         SocketHelper.sharedInstance.socket.write(string: text) {
//          }
        
        self.socket.write(string: text)
        
    }
    
    
    func convertTextToJson(text:String) -> jsonDictionary{
        var dictionary : jsonDictionary!
        if let  dat = text.data(using: .utf8){
        printDebug(object: "1-------")
            printDebug(object: dat)

            if let jsonData = try? JSONSerialization.jsonObject(with: dat){
                printDebug(object: "2-------")

                printDebug(object: jsonData)

                if let jsonDict = jsonData as? [String: AnyObject]{
                    printDebug(object: "3-------")

                    printDebug(object: jsonDict)

                    dictionary = jsonDict
                }
            }
            
        }
        
        return dictionary
        
//        guard let data = text.data(using: .utf8),
//            let jsonData = try? JSONSerialization.jsonObject(with: data),
//            let jsonDict = jsonData as? [String: Any]
//             else {
//                return
//        }
//        
//        printDebug(object: "convert text to json")
//        
//        printDebug(object: jsonDict)
//        
//        return ""
    }
    
    
    
     func convertDictionaryToString(dict : jsonDictionary) -> String{
        
        var strDict = ""
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            printDebug(object: "jsonData..\(jsonData)")
            
            guard let str  = String(data: jsonData, encoding: .utf8) else{
                return ""
            }
            
            strDict = str
            
        } catch {
            print(error.localizedDescription)
        }
        
        return strDict
    }
    
    
    
    //
//    var username = ""
//
//    
//    var isConnected:(_ isConnected:Bool)->()
//
//     var nessageReceived:(_ data:[String: AnyObject])->()
//
//    
//
//
//    override init() {
//        
//    }
    
}



//
//// MARK: - WebSocketDelegate
//extension SocketHelper : WebSocketDelegate {
//    
//    
//    func writeMessage(myMessage:String){
//        socket.write(string: myMessage)
//
//    }
//    
//    public func websocketDidConnect(_ socket: Starscream.WebSocket) {
//        
//        self.isConnected(true)
//        socket.write(string: username)
//    }
//    
//    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
//        
//        
//        self.isConnected(false)
//        
//    }
//    
//    /* Message format:
//     * {"type":"message","data":{"time":1472513071731,"text":"😍","author":"iPhone Simulator","color":"orange"}}
//     */
//    
//    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
//        guard let data = text.data(using: .utf16),
//            let jsonData = try? JSONSerialization.jsonObject(with: data),
//            let jsonDict = jsonData as? [String: AnyObject],
//            let messageType = jsonDict["type"] as? String else {
//                return
//        }
//        
//        
//        self.nessageReceived(jsonDict)
//        
//        print(jsonDict["data"])
//        
//        if messageType == "message",
//            let messageData = jsonDict["data"] as? [String: Any],
//            let messageAuthor = messageData["author"] as? String,
//            let messageText = messageData["message"] as? String {
//            print("/////////")
//            print(messageData)
//            messageReceived(messageText, senderName: messageAuthor)
//        }
//    }
//    
//    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
//        // Noop - Must implement since it's not optional in the protocol
//    }
//}


