

import UIKit





class InternetConnectionSpeed :NSObject,URLSessionDelegate, URLSessionDataDelegate {
   
    var startTime : CFAbsoluteTime?
    var stopTime : CFAbsoluteTime?
    var bytesReceived : Int = 0
   // var ComplitionWithDictionary = (megabytesPerSecond:CGFloat,error:NSError)->()()
    var ComplitionWithDictionary: ((_ megabytesPerSecond: CGFloat?, _ error: NSError?) -> ())!

    
    override init(){
        
        super.init()
    
//
//        [self testDownloadSpeedWithTimout:5.0 completionHandler:^(CGFloat megabytesPerSecond, NSError *error) {
//            NSLog(@"%0.1f; error = %@", megabytesPerSecond, error);
//            }];
        
        self.testDownloadSpeedWithTimout(timeout: 5.0) { (perSec, error) in
            
            printDebug(object: "per sec \(perSec)")
            
        }
        
    }
  
    
    func testDownloadSpeedWithTimout(timeout:TimeInterval,complition:@escaping ((_ megabytesPerSecond: CGFloat?, _ error: NSError?) -> ())){
        let url = URL(string:"http://www.google.com")
        self.startTime = CFAbsoluteTimeGetCurrent()
        self.stopTime = self.startTime
        self.bytesReceived = 0
        self.ComplitionWithDictionary = complition
       let configuration : URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session : URLSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url!)
    }
    
  
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        self.bytesReceived += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
        
        printDebug(object: "rate is \(self.bytesReceived)")

        
    }
}


func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    
    printDebug(object: "error is \(error?.localizedDescription)")
    
//    let elapsed: CFAbsoluteTime = self.stopTime - self.startTime
//    let speed: CGFloat = elapsed != 0 ? bytesReceived / (CFAbsoluteTimeGetCurrent() - self.startTime) / 1024.0 / 1024.0 : -1
//    // treat timeout as no error (as we're testing speed, not worried about whether we got entire resource or not
//    if error == nil || ((error?.domain == NSURLErrorDomain) && error?.code == NSURLErrorTimedOut) {
//        speedTestCompletionHandler(speed, nil)
//    }
//    else {
//        speedTestCompletionHandler(speed, error)
//    }
}









