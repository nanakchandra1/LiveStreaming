

import UIKit
import Starscream
import StoreKit



enum PurchaseFrom{
    case Feed
    case EmogieKeyBoard
    case WatchingVideo
    case TokenLessButton
    case None
}



class PurchaseTokensVC: UIViewController {
    
    //MARK:- Varibles
    //==================
    
    var products = [SKProduct]()
    // var delegate : OpenPlayerAfterPurchase?
    var purchaseFrom = PurchaseFrom.None
    // var buyButtonHandler: ((_ product: SKProduct) -> ())?
    var selectedPrice : String = ""
    
    //MARK:- IBOutlets
    //=================
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var greyBackView: UIView!
    @IBOutlet weak var tokenBalanceBackView: UIView!
    @IBOutlet weak var myTokenLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var totalTokenLabels: UILabel!
    @IBOutlet weak var collectionViewBackView: UIView!
    @IBOutlet weak var plansCollectionView: UICollectionView!
    
    
    //MARK:- Vire life cycle
    //==============================
    override func viewDidLoad() {
        super.viewDidLoad()
        printDebug(object: "purchase from \(self.purchaseFrom)")
        self.setUpSubView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let tokens = CurentUser.tokenCount{
            
            self.totalTokenLabels.text = "\(tokens)"
            
        }
        
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: .myPurchaseCompleted, object: nil)
        
    }
    
    
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        if self.purchaseFrom == .Feed{
            
            CommonFunction.removeChildVC(childVC: self)
            
        }else if self.purchaseFrom == .WatchingVideo{
            CommonWebService.sharedInstance.cutTokenWhileWatching?.cutWhileWatching()
            _ = self.navigationController?.popViewController(animated: true)
        }else if self.purchaseFrom == .WatchingVideo{
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}


private extension PurchaseTokensVC{
    
    
    func setUpSubView(){
        
        self.greyBackView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        self.tokenBalanceBackView.layer.cornerRadius = 3.0
        self.tokenBalanceBackView.clipsToBounds = true
        self.tokenBalanceBackView.layer.borderWidth = 1.0
        self.tokenBalanceBackView.layer.borderColor = AppColors.borderColor.cgColor
        self.collectionViewBackView.layer.cornerRadius = 3.0
        self.collectionViewBackView.clipsToBounds = true
        self.collectionViewBackView.layer.borderWidth = 1.0
        self.collectionViewBackView.layer.borderColor = AppColors.borderColor.cgColor
        self.plansCollectionView.delegate = self
        self.plansCollectionView.dataSource = self
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
        
        // SocketHelper.sharedInstance.socket.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseTokensVC.handlePurchaseNotification(_:)),name:NSNotification.Name(rawValue:IAPHelper.IAPHelperPurchaseNotification),object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseTokensVC.purchaseComplition), name: .myPurchaseCompleted, object: nil)
        
        if CurentUser.userImage == URLName.demoUrl{
            
            self.profileImageView.setImageWithStringURL(URL: CurentUser.userImage!, placeholder: UIImage(named: "userPlaceholder")!)
        }else{
            self.profileImageView.image = UIImage(named : "userPlaceholder")
        }
        
        
        self.profileImageView.setImageWithStringURL(URL: CurentUser.userImage!, placeholder: UIImage(named: "userPlaceholder")!)
        
        //
        
        //            self.buyButtonHandler = { product in
        //
        //                printDebug(object: "buy called.......")
        //
        //                RageProducts.store.buyProduct(product)
        //        }
        
        
        self.getPlans()
        
    }
    
    func getPlans() {
        products = []
        
        //tableView.reloadData()
        CommonFunction.showLoader(vc: self)
        RageProducts.store.requestProducts{success, products in
            if success {
                CommonFunction.hideLoader(vc: self)
                self.products = products!
                
                // self.tableView.reloadData()
                self.products.sort {
                    return $0.price < $1.price
                }
                
                print("description.....")
                print(products ?? "")
                
                self.plansCollectionView.reloadData()
            }else{
                CommonFunction.hideLoader(vc: self)
                print("failure")
            }
            
        }
    }
    
    func restoreTapped(_ sender: AnyObject) {
        RageProducts.store.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        
        
    }
    
    @objc func purchaseComplition(sender:NSNotification){
        
        printDebug(object: "purchase complition....")
        
        if self.selectedPrice != ""{
            
            self.addTokenService(tokens: self.selectedPrice.replacingOccurrences(of: ",", with: ""))
        }
        
    }
    
}


//MARK:- Collection view datasource and delegate methods
//========================================================
extension PurchaseTokensVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize(width: (self.plansCollectionView.frame.width / 2) - 4, height: (self.plansCollectionView.frame.height / 4) - 5)
  
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "purchaseTokenCell", for: indexPath) as! PurchaseTokenCell
        
        printDebug(object: "price....\( self.products[indexPath.row].price)")
        
        printDebug(object: "title....\( self.products[indexPath.row].localizedTitle)")
        
        printDebug(object: "descri....\( self.products[indexPath.row].localizedDescription)")
        
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        
        printDebug(object: "currencyCode......\(String(describing: currencySymbol))")
        
        cell.planTitleLabel.text = "\(self.products[indexPath.row].localizedTitle) for"
        
        cell.priceLabel.text = "\(String(describing: currencySymbol!))\(self.products[indexPath.row].price)"
        
        
        let numberFormatter = NumberFormatter()
       // numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        let pri = numberFormatter.string(from: self.products[indexPath.row].price)
        printDebug(object: "pri...\(String(describing: pri))")
        
        
        printDebug(object: self.products[indexPath.item].priceLocale)
        
        printDebug(object: locale)
        

        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = self.products[indexPath.row].localizedTitle
        printDebug(object: "title is \(title)")
        guard let price = title.components(separatedBy: " ").first else{
            return
        }
        
        printDebug(object: "price is \(title)")
        
        self.selectedPrice = price
        
        // self.addTokenService(tokens:  self.selectedPrice.replacingOccurrences(of: ",", with: ""))
        
        //self.addTokenService(tokens:"1043")
        
        
        RageProducts.store.buyProduct(self.products[indexPath.row])
        
    }
}





//MARK:- Webservices
//=====================

extension PurchaseTokensVC{
    
    func addTokenService(tokens:String){
        
        let params = ["userId" : CurentUser.userId as AnyObject,"token" : tokens as AnyObject]
        
        printDebug(object: "params is ....\(params)")
        
        CommonFunction.showLoader(vc: self)
        UserService.addtokenInAppApi(params: params) { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let tokens = CurentUser.tokenCount{
                    
                    self.totalTokenLabels.text = "\(tokens)"
                    
                }
                
                
                if self.purchaseFrom == .Feed{
                    
                    CommonFunction.removeChildVC(childVC: self)
                    CommonWebService.sharedInstance.navigatToVideoVC()
                    
                }else if self.purchaseFrom == .WatchingVideo{
                    printDebug(object: "purchase by WatchingVideoz")
                    CommonWebService.sharedInstance.cutTokenWhileWatching?.cutWhileWatching()
                    _ = self.navigationController?.popViewController(animated: true)
                }else if self.purchaseFrom == .TokenLessButton{
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            }else{
                
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
}


class PurchaseTokenCell : UICollectionViewCell{
    
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }
}


//public extension SKProduct {
//    
//    public var localizedPrice: String? {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.locale = self.priceLocale
//        numberFormatter.numberStyle = .currency
//        return numberFormatter.string(from: self.price)
//    }
//}

