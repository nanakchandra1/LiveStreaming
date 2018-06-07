
import UIKit
import StoreKit



class PurchaseVC: UIViewController {

    
    var products = [SKProduct]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reload()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func reload() {
        products = []
        
        //tableView.reloadData()
        
        RageProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                
               // self.tableView.reloadData()
                
                print("description.....")
              
               
                
            }else{
                print("failure")
            }
            

        }
    }

    
    
  }



