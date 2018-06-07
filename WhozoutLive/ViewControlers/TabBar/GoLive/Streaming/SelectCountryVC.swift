

import UIKit

protocol GetCountryBack{
    
    func getCountryBack(countryArray:[String])
    
}

enum ConfigureCell{
    case Select
    case Block
    case None
}

class SelectCountryVC: UIViewController {
    
    //MARK:- IBOutlets
    //===================
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var countryTableView : UITableView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var selectedCountryCollectionview: UICollectionView!
    @IBOutlet weak var blockCountryCollectionview: UICollectionView!
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var blockCountryButton: UIButton!
    @IBOutlet weak var addCountryBackView: UIView!
    @IBOutlet weak var blockCountryBackView: UIView!
    //@IBOutlet weak var selectCountryCollectionViewHeight: NSLayoutConstraint!
   // @IBOutlet weak var blockCountriesCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var blocaCollectionViewBackView: UIView!
    @IBOutlet weak var selectCollectionViewBackView: UIView!
    @IBOutlet weak var countryScrollView: UIScrollView!
    
    
    //MARK:- Variables
    //=====================
    var countryList = [CountryData]()
    var addSpecificLocations = [String]()
    var blockSpecificLocations = [String]()
    var sharingData = jsonDictionary()
    var getChargeIdBackDelegate : GetChargeIdBack!
    // var collectionViewArray = [String]()
    var sizingCell: TagCell?
    var cellFor = ConfigureCell.None
    
    //MARK:- View life cycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setUpSubView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func backButtontapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func publishButtonTapped(_ sender: UIButton) {
        if !self.addSpecificLocations.isEmpty{
            
            if  Networking.isConnectedToNetwork{
                
                self.startStreaming()
                
            }else{
                CommonFunction.showTsMessageErrorInViewControler(message:     NSLocalizedString("internet connection", comment: "") , vc: self)
            }
        }else{
            CommonFunction.showTsMessageErrorInViewControler(message: "Please select countries in which you want to broadcast your stream.", vc: self)
        }
    }
    
    @IBAction func selectCountryButtonTapped(_ sender: UIButton) {
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SearchCountryID") as! SearchCountryVC
        SelectCountryType.countryType = .Add
        vc.countryList = self.countryList
        vc.filteredArray = self.countryList
        
        if self.addSpecificLocations.contains("All"){
            
            for item in self.countryList{
                vc.selectedCountryList.append(item.countryName!)
            }
            
        }else{
            vc.selectedCountryList = self.addSpecificLocations
        }
        
        vc.countryDelegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func blockCountryButtontapped(_ sender: UIButton) {
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SearchCountryID") as! SearchCountryVC
        SelectCountryType.countryType = .Blocak
        var list = self.countryList
        list.removeFirst()
        vc.countryList = self.countryList
        vc.filteredArray = self.countryList
        vc.selectedCountryList = self.blockSpecificLocations
        vc.countryDelegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}


private extension SelectCountryVC{
    func setUpSubView(){
        //  self.countryTableView.delegate = self
        // self.countryTableView.dataSource = self
        self.publishButton.layer.cornerRadius = 3.0
        self.publishButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.publishButton.layer.borderWidth = 1.0
        self.publishButton.clipsToBounds = true
        self.countryTableView.estimatedRowHeight = 50
        self.countryTableView.rowHeight = UITableViewAutomaticDimension
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.selectedCountryCollectionview.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.selectedCountryCollectionview.backgroundColor = UIColor.clear
        
        self.blockCountryCollectionview.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.blockCountryCollectionview.backgroundColor = UIColor.clear
        
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        
        self.selectedCountryCollectionview.delegate = self
        self.selectedCountryCollectionview.dataSource = self
        
        self.blockCountryCollectionview.delegate = self
        self.blockCountryCollectionview.dataSource = self
        
        self.blockCountryBackView.isHidden = true
        self.blocaCollectionViewBackView.isHidden = true
        
        self.selectCollectionViewBackView.layer.cornerRadius = 3.0
        self.selectCollectionViewBackView.layer.borderWidth = 1.0
        self.selectCollectionViewBackView.layer.borderColor = AppColors.borderColor.cgColor
        self.selectCollectionViewBackView.clipsToBounds = true
   
        self.blocaCollectionViewBackView.layer.cornerRadius = 3.0
        self.blocaCollectionViewBackView.clipsToBounds = true
        self.blocaCollectionViewBackView.layer.borderWidth = 1.0
        self.blocaCollectionViewBackView.layer.borderColor = AppColors.borderColor.cgColor
        self.getCountries()
    }
}



//MARK:- collection view datasource and delegate
//==================================================
extension SelectCountryVC: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView === self.selectedCountryCollectionview{
            
            return self.addSpecificLocations.count
            
        }else{
            return self.blockSpecificLocations.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
        //print(customCell.frame)
        
        if collectionView === self.selectedCountryCollectionview{
            
            customCell.tagName.text = "  " + self.addSpecificLocations[indexPath.item] + "  "
            
            customCell.isUserInteractionEnabled = true
            
            
            customCell.removeButton.addTarget(self, action: #selector(SelectCountryVC.removeSelectedCountries(sender:)), for: UIControlEvents.touchDown)
            customCell.bringSubview(toFront: customCell.removeButton)
        }else{
            customCell.tagName.text = "  "  + self.blockSpecificLocations[indexPath.item] + "  "
            
            customCell.isUserInteractionEnabled = true
            
            customCell.removeButton.addTarget(self, action: #selector(SelectCountryVC.removeblockedCountries(sender:)), for: UIControlEvents.touchDown)
            customCell.bringSubview(toFront: customCell.removeButton)
        }
        
        return customCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView === self.selectedCountryCollectionview{
            
            self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath as NSIndexPath, from: ConfigureCell.Select)
            
            return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            
            
        }else{
            self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath as NSIndexPath, from: ConfigureCell.Block)
            
            return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            
        }
        
        
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath,from:ConfigureCell) {
        
        if from == ConfigureCell.Select{
            let tag = self.addSpecificLocations[indexPath.item]
            cell.tagName.text = "  " + tag + "  "
            // print("cell max --->>\(cell.bounds.maxX)")
            
        }else{
            let tag = self.blockSpecificLocations[indexPath.item]
            cell.tagName.text = "  " + tag + "  "          //  print("cell max --->>\(cell.bounds.maxX)")
        }
    }
    
    //MARK:- remove selected country
    //==================================
    func removeSelectedCountries(sender:UIButton){
        
        
        
        
    if self.addSpecificLocations.contains("All") && self.blockSpecificLocations.count > 0{
     CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("can not remove all", comment: ""), vc: self)
       
        }else{
        if self.addSpecificLocations.contains("All"){
            self.blockCountryBackView.isHidden = true
            self.blocaCollectionViewBackView.isHidden = true

        }
        let index = sender.collectionViewIndexPath(collectionView: self.selectedCountryCollectionview)
        self.addSpecificLocations.remove(at: (index?.row)!)
        self.selectedCountryCollectionview.reloadData()
        
        }
    }
    
    //MARK:- remove blocked country
    //====================================
    func removeblockedCountries(sender:UIButton){
        let index = sender.collectionViewIndexPath(collectionView: self.blockCountryCollectionview)
        self.blockSpecificLocations.remove(at: (index?.row)!)
        self.blockCountryCollectionview.reloadData()
    }
}


//MARK:- WebServices
//=======================
extension SelectCountryVC{
    
    func getCountries(){
        
        let params : [String:AnyObject] = ["" : "" as AnyObject]
        CommonFunction.showLoader(vc: self)
        UserService.countryListApi(params: params) { (success, data) in
            
            printDebug(object: data)
            
            if success{
                CommonFunction.hideLoader(vc: self)
                guard let data = data else{
                    return
                }
                
                self.countryList = data
                
                let all = CountryData(countryData: ["_id":"0" as AnyObject,"countryCode":"all" as AnyObject,"country":"All" as AnyObject])
                self.countryList.insert(all, at: 0)
                self.selectedCountryCollectionview.reloadData()
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
}

//MARK:- Get country back delegate
//====================================
extension SelectCountryVC : GetCountryBack{
    func getCountryBack(countryArray: [String]) {
        printDebug(object: countryArray)
        
     
        
        if SelectCountryType.countryType == .Add{
            self.addSpecificLocations.removeAll()
            
            if countryArray.contains("All"){
                self.addSpecificLocations = ["All"]
                self.blockCountryBackView.isHidden = false
                self.blocaCollectionViewBackView.isHidden = false
                self.blockSpecificLocations.removeAll()
                self.blockCountryCollectionview.reloadData()
            }else{
                self.addSpecificLocations = countryArray
                self.blockCountryBackView.isHidden = true
                self.blocaCollectionViewBackView.isHidden = true
            }
            self.selectedCountryCollectionview.reloadData()
            
        }else if SelectCountryType.countryType == .Blocak{
            self.blockSpecificLocations.removeAll()
            self.blockSpecificLocations = countryArray
            self.blockCountryCollectionview.reloadData()
        }
        
        
        self.countryScrollView.contentSize.height = self.selectedCountryCollectionview.frame.size.height + self.blockCountryCollectionview.frame.size.height + 140
        
    }
    
    
    func setSelectedCountryCollectionViewHeight(){
        if self.selectedCountryCollectionview.collectionViewLayout.collectionViewContentSize.height < 120{
        }else  if self.selectedCountryCollectionview.collectionViewLayout.collectionViewContentSize.height > screenHeight{
            
        }else{
        }
        
    }
    
    func setBlockedCountryCollectionViewHeight(){
        if self.blockCountryCollectionview.collectionViewLayout.collectionViewContentSize.height < 120{
        }else  if self.blockCountryCollectionview.collectionViewLayout.collectionViewContentSize.height > screenHeight{
            
            
            
        }else{

        }
    }
    
}

//MARK:- Webservices
//=======================
extension SelectCountryVC{
    
    func startStreaming(){
        
        // allowCounrty:IN,AM,AU
        // blockCounrty:IN,AM,AU
        
        CommonFunction.showLoader(vc: self)
        
        var params : jsonDictionary = ["discription":self.sharingData["discription"] ?? "" as AnyObject,
        "userid" : CurentUser.userId as AnyObject,
        "sharetype" : self.sharingData["sharetype"] ?? "" as AnyObject,
        "broadcastType" : self.sharingData["broadcastType"] ?? "" as AnyObject,
        "broadcastPrice"  : self.sharingData["broadcastPrice"] ?? "0" as AnyObject,
        
        ]
        
        params["latitude"] = sharedAppdelegate.latitude as AnyObject
        params["longitude"] = sharedAppdelegate.longitude as AnyObject
        params["userName"] = CurentUser.userName as AnyObject?

        
        if ShareWith.shareWith == .Friends || ShareWith.shareWith == .Private{
            params["ids"] = self.sharingData["ids"] ?? "" as AnyObject
        }
        
        if self.addSpecificLocations.contains("All"){
            
            var blockArray = [String]()
            
            params["allowCounrty"] = "all" as AnyObject?
            
            for item in self.countryList{
                
                if self.blockSpecificLocations.contains(item.countryName!){
                    blockArray.append(item.countryCode!)
                }
            }
            params["blockCounrty"] = blockArray.joined(separator: ",") as AnyObject?
            
            printDebug(object: params["blockCounrty"])
            
        }else{
            var addArray = [String]()
            for item in self.countryList{
                
                if self.addSpecificLocations.contains(item.countryName!){
                    addArray.append(item.countryCode!)
                }
            }
            
            params["allowCounrty"] = addArray.joined(separator: ",") as AnyObject?
            
            printDebug(object: params["allowCounrty"])
            
        }
        
        printDebug(object: params)
        
        UserService.startStreamingApi(params: params) { (success, data) in
            CommonFunction.hideLoader(vc: self)
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let data = data{
                    printDebug(object: data)
        
//                  let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "PublishOrShareID") as! PublishOrShareVC
//                    vc.publishDelegate = self
//                    vc.streamingdata = data
//                    CommonFunction.addChildVC(childVC: vc ,parentVC : self)

                    
                    self.getChargeIdBackDelegate.getchargeId(id: data["chargeId"] as? String ?? "",shareUrl: data["shareUrl"] as? String ?? "" )
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
}

extension SelectCountryVC : PublishStreamWithData{
    
    func publish(data: jsonDictionary) {
        CommonFunction.showLoader(vc: self)
        CommonFunction.delayy(delay: 0.001) {
             self.getChargeIdBackDelegate.getchargeId(id: data["chargeId"] as? String ?? "",shareUrl: data["shareUrl"] as? String ?? "" )
            CommonFunction.hideLoader(vc: self)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

class FlowLayout : UICollectionViewFlowLayout {
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        
        var leftMargin: CGFloat = 0.0;
        
        for attributes1 in attributesForElementsInRect! {
            let attributes = attributes1.copy() as! UICollectionViewLayoutAttributes
            
            if (attributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left + 10
            } else {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
                if leftMargin + attributes.frame.size.width > screenWidth - 10 {
                    // print("cell max --->>\(attributes.frame.maxX)  section left -->\(self.sectionInset.left)--->right ")
                    //leftMargin = 0.0
                    var newLeftAlignedFrame = attributes.frame
                    newLeftAlignedFrame.origin.x = 0.0
                    attributes.frame = newLeftAlignedFrame
                    
                }
                
            }
            leftMargin += attributes.frame.size.width + 8.0
            
            newAttributesForElementsInRect.append(attributes)
        }
        
        return newAttributesForElementsInRect
    }
}
