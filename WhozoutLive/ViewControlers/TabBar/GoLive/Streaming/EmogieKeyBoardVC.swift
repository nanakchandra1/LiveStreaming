
import UIKit
import SAConfettiView

protocol CommentEmogie {
    
    func sendEmogie(id:String,price:Int,image:UIImage,dimension:String,catagoryType:String,smileyType:String)
    
    func tokenFinished()
    
    func removeKeyBoard()
    
    
}

class EmogieKeyBoardVC: UIViewController {
    
    //MARK:- Variables
    //============
    var selectedTab : Int = 0
    var emogieData = [WLEmogies]()
    var catagoryArray : StringArray = []
    var seperatedEmogies = [String:[WLEmogies]]()
    var rowNum : Int = 0
    var confettiView: SAConfettiView!
    var rainTimer : Timer?
    var rainTimeElapsed : Int = 0
    var emogieDelegate : CommentEmogie!
    
    //MARK:- IBOutlets
    //===============
    @IBOutlet weak var removeKeyboardButton: UIButton!
    @IBOutlet weak var tabBackView: UIView!
    @IBOutlet weak var keyBoardCollectionViewBackView: UIView!
    @IBOutlet weak var emogieCollectionView: UICollectionView!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubView()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func closeButtontapped(_ sender: UIButton) {
        
        self.emogieDelegate.removeKeyBoard()
        CommonFunction.removeChildVC(childVC: self)
        
    }
    
}


private extension EmogieKeyBoardVC{
    
    //MARK:- Set up your view
    //==========================
    func setUpSubView(){
        
        self.emogieCollectionView.delegate = self
        self.emogieCollectionView.dataSource = self
        self.emogieCollectionView.isPagingEnabled = true
        self.tabCollectionView.delegate = self
        self.tabCollectionView.dataSource = self
        
        self.getemogiesFromCoreData()
    }
    
    
    //MARK:- get emogies from core data
    //===================================
    func getemogiesFromCoreData(){
        
        let data = DataBaseControler.fetchData(modelName: "WLEmogies")
        
        
        guard let emo = data else{return}
        
        self.emogieData = emo as! [WLEmogies]
        
        guard let array = CommonWebService.sharedInstance.emogiesSequenceArray else{
            return
        }
        
        
        self.catagoryArray = array
        
      //  self.catagoryArray = ["NewYear"]

        if self.catagoryArray.isEmpty{
            self.noDataLabel.isHidden = false
        }else{
            self.noDataLabel.isHidden = true

        }
        
        
        for item in self.catagoryArray{
            

            let prStr = NSPredicate(format: "category == %@", item)
            
            let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr)
            
            
          let sortedEmogies = (emogies as? [WLEmogies])?.sorted {
                return Int($0.price!)! < Int($1.price!)!
            }
            
    
            self.seperatedEmogies[item] = sortedEmogies
            
        }
    }
    
    
    @objc func stopTain(sender : Timer){
        
        self.rainTimeElapsed += 1
        
        if self.rainTimeElapsed > 5{
            self.rainTimeElapsed = 0
            confettiView.stopConfetti()
            confettiView.removeFromSuperview()
            self.rainTimer?.invalidate()
        }
        
    }
}

//MARK :- collection view datasource and delegate
//================================================
extension EmogieKeyBoardVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.emogieCollectionView{
            return self.catagoryArray.count
        }else{
            return self.catagoryArray.count
            
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.emogieCollectionView{
            
            return CGSize(width: screenWidth, height: self.keyBoardCollectionViewBackView.frame.height)
            
        }else{
            
           let cellWidth = CommonFunction.getTextWidth(text: self.catagoryArray[indexPath.item], font: AppFonts.lotoRegular.withSize(15), height: 40)
            
            return CGSize(width: cellWidth + 20, height: self.tabCollectionView.frame.size.height)
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.emogieCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emogieCollectionViewCell", for: indexPath) as! EmogieCollectionViewCell
            self.rowNum = indexPath.item
            
            let key = self.catagoryArray[indexPath.item]
            
            cell.emogiArray = self.seperatedEmogies[key]!
            
            cell.emogieDeleg = self
            
            
            cell.emogieImageCollectionView.reloadData()
            
        
            self.tabCollectionView.scrollRectToVisible((self.tabCollectionView.layoutAttributesForItem(at: indexPath)?.frame)!, animated: true)
            
            //self.tabCollectionView.scrollToItem(at: IndexPath(row: indexPath.item, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            
            //cell.emogieImageCollectionView.delegate = self
            //cell.emogieImageCollectionView.dataSource = self
           // self.emogieCollectionView.reloadItems(at:             [IndexPath(item: self.rowNum, section: 0)])
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emogieTabCollectionViewCell", for: indexPath) as! EmogieTabCollectionViewCell
            cell.tabNameLabel.text = self.catagoryArray[indexPath.item]
            if self.selectedTab == indexPath.item{
                
                cell.highLightView.isHidden = false
                cell.tabNameLabel.textColor = AppColors.pinkColor
                
            }else{
                cell.highLightView.isHidden = true
                cell.tabNameLabel.textColor = AppColors.placeHolderColor
                
            }
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == self.emogieCollectionView{
            self.selectedTab = indexPath.row
            
            self.tabCollectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.emogieCollectionView{
            
            
        }else if collectionView == self.tabCollectionView{
            self.selectedTab = indexPath.item
            self.tabCollectionView.reloadData()
            
            self.emogieCollectionView.scrollToItem(at:          IndexPath(item: indexPath.item, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            
        }else{
            
            let key = self.catagoryArray[self.selectedTab]
            
            if let tok = CurentUser.tokenCount{
                
                if Int(tok)! > Int((self.seperatedEmogies[key]?[indexPath.item].price)!)!{
                    
                    guard (collectionView.cellForItem(at: indexPath) as? EmogieImageCollectionViewCell) != nil else{
                        return
                    }
                    
                }else{
                    
                    // self.emogieDelegate.tokenFinished()
                    
                    CommonWebService.sharedInstance.tokenLess(from:PurchaseFrom.EmogieKeyBoard)
                }
                
            }else{
                
                
            }
            
            
        }
        
    }
}


extension EmogieKeyBoardVC : CommentEmogie{
    
    func removeKeyBoard() {
        
        
    }

    
    func tokenFinished() {
        
        
    }

    
    func sendEmogie(id:String,price:Int,image:UIImage,dimension:String,catagoryType:String,smileyType:String){
        
        self.emogieDelegate.sendEmogie(id: id, price:  price,image: image,dimension:dimension,catagoryType:catagoryType,smileyType:smileyType)
        
    }
}

class EmogieCollectionViewCell : UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var emogieImageCollectionView: UICollectionView!
    
    var emogieDeleg : CommentEmogie?
    var emogiArray : [WLEmogies] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.emogieImageCollectionView.delegate = self
        self.emogieImageCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.emogiArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
        return 0.0
   
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
   
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: screenWidth / 6, height: screenWidth / 6)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emogieImageCollectionViewCell", for: indexPath) as! EmogieImageCollectionViewCell
        
      let pathName =  "\(self.emogiArray[indexPath.item].category!)-\(self.emogiArray[indexPath.item].emogiId!)"
        
        
        cell.emogieImageView.image = CommonFunction.getImage(pathName: pathName)

        cell.emogieLabel.text = self.emogiArray[indexPath.item].price
        
        return cell
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = self.emogieImageCollectionView.cellForItem(at: indexPath) as? EmogieImageCollectionViewCell else{
            //printDebug(object: "cell not found")
            return
        }
        
        let id = self.emogiArray[indexPath.item].emogiId ?? ""
        let price = self.emogiArray[indexPath.item].price ?? "10"
        let image = cell.emogieImageView.image ?? UIImage(named: "emogie")
        let dimension = self.emogiArray[indexPath.item].dimension ?? "small"
        let catagory = self.emogiArray[indexPath.item].category ?? "general"
        let smileyType = self.emogiArray[indexPath.item].smileyType ?? "general"
      
        self.emogieDeleg?.sendEmogie(id: id, price: Int(price)!, image: image!, dimension: dimension, catagoryType: catagory,smileyType:smileyType)
        
    }
    
}

class EmogieImageCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var emogieLabel: UILabel!
    @IBOutlet weak var emogieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // self.layer.borderWidth = 1.0
        //self.layer.borderColor = AppColors.placeHolderColor.cgColor
        
    }
    
}


class EmogieTabCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var tabNameLabel: UILabel!
    @IBOutlet weak var highLightView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
    }
    
    
    
}



