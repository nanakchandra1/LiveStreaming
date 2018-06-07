
import UIKit
import SwiftyDropbox


class DropBoxHelper {

    class var sharedInstance : DropBoxHelper {
        
        struct Static {
            static let instance : DropBoxHelper = DropBoxHelper()
        }
        return Static.instance
    }
    
    
     func getList(vcObj : UIViewController,complition:@escaping (_ success:Bool,_ data : [Files.Metadata]) -> ()){
        let client = DropboxClientsManager.authorizedClient!
        
        DispatchQueue.main.async {
            CommonFunction.showLoader(vc: vcObj)
        }
        
        client.files.listFolder(path: "").response(queue: DispatchQueue(label: "MyCustomSerialQueue")) { response, error in
            if let result = response {
                
                DispatchQueue.main.async {
                    CommonFunction.hideLoader(vc: vcObj)
                }
                
                print(Thread.current)
                
                print(Thread.main)
                
                // self.downloadFile()
                print(result)
                
                complition(true, result.entries)
                
//                let vc = StoryBoard.DocumentUpload.instance.instantiateViewController(withIdentifier: "ShowDropBoxDataID") as! ShowDropBoxDataVC
//                vc.dropBoxdata = result.entries
//                vc.getDocDelegate = self
//                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }

    
    
}
