
import UIKit


protocol LikeBack{
    func getLikeBack(index:Int,isLiked:String,totalLikeCount : String,totalViews:String)
}

class SavedImagesVC : UIViewController {
   
    
    //MARK:-  Variables
    //====================
    
    var allimages : [ImageData] = []
    var userId : String!
  
    
    
    //MARK:- IBOutlets
    //==================
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var savedImagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    

    @IBAction func backButtonTapped(_ sender: UIButton) {
       _ = self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Private functions
//============================
private extension SavedImagesVC{
 
    func setUpSubView(){
        self.savedImagesCollectionView.delegate = self
        self.savedImagesCollectionView.dataSource = self
        self.getAllImages()
    }
}

//MARK:- collection view datasource and delegate
//================================================
extension SavedImagesVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allimages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth / 3) - 7 , height: screenWidth / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedImagesCell", for: indexPath) as! SavedImagesCell
            cell.savedImageView.setImageWithStringURL(URL: self.allimages[indexPath.row].imageUrl!, placeholder: UIImage(named: "pramotionalPlaceholder")!)
        cell.likeCountLabel.text = self.allimages[indexPath.row].like
        cell.viewsCountLabel.text = self.allimages[indexPath.row].views
        cell.setLikeImage(isLiked: self.allimages[indexPath.row].islike!)
        cell.viewsListButton.addTarget(self, action: #selector(SavedImagesVC.viewListButtontapped), for: UIControlEvents.touchUpInside)
        cell.likeListButton.addTarget(self, action: #selector(SavedImagesVC.likeListButtontapped), for: UIControlEvents.touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ImagecommentID") as! ImagecommentVC
        vc.imgUrl = self.allimages[indexPath.row].imageUrl
        vc.ImgId = self.allimages[indexPath.row].id
        vc.index = indexPath.row
        vc.likeDelegate = self
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
        
    }
    
   
    //MARK:- Like count tapped
    //=================
    func likeListButtontapped(sender:UIButton){
        
       let indx = sender.collectionViewIndexPath(collectionView: self.savedImagesCollectionView)
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
         vc.mediaId = self.allimages[(indx?.row)!].id
        vc.type = .ImageLikeList
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
   func viewListButtontapped(sender:UIButton){
        let indx = sender.collectionViewIndexPath(collectionView: self.savedImagesCollectionView)
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
        vc.mediaId = self.allimages[(indx?.row)!].id
        vc.type = .ImageViews
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
}


extension SavedImagesVC : LikeBack{
     func getLikeBack(index: Int, isLiked: String, totalLikeCount: String, totalViews: String) {
        
        
        printDebug(object: "back total likes \(totalLikeCount)")
        
        printDebug(object: "back total views count \(totalViews)")
        
        self.allimages[index].islike = isLiked
        self.allimages[index].like = totalLikeCount
        self.allimages[index].views = totalViews
        self.savedImagesCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }

  
}


//MARK:- Webservice
//====================
extension SavedImagesVC{
    
    func getAllImages(){
        
        let params : jsonDictionary = ["userId" : self.userId as AnyObject,"limit" : "0" as AnyObject]
        
        CommonFunction.showLoader(vc: self)
        
        UserService.allImagesApi(params: params) { (success, data) in
            
            if success{
                
              CommonFunction.hideLoader(vc: self)
                
            if let data = data{
                self.allimages = data
                self.savedImagesCollectionView.reloadData()
            }
            }else{
                CommonFunction.hideLoader(vc: self)

            }
        }
        
    }
    
    
}


class SavedImagesCell : UICollectionViewCell{
    @IBOutlet weak var savedImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var viewsImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var viewsListButton: UIButton!
    @IBOutlet weak var likeListButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
       self.setShadowForView(radius:4)
    }
    
    func setShadowForView(radius:CGFloat){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.1
    }
    
    func setLikeImage(isLiked:String){
        if isLiked == "1"{
            self.likeImageView.image = UIImage(named : "liked")
            
        }else{
       
            self.likeImageView.image = UIImage(named : "like")

            
        }
    }
}
