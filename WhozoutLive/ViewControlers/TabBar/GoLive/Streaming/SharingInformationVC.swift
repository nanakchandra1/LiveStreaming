



import UIKit

protocol GetFriendsBack {
    func getFriendsBack(followers: StringArray)
    
    func closeButtonTapped()
    
}


class SharingInformationVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var sharingInfoTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var minuteButton: UIButton!
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var bottomFooterView: UIView!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var addTokenLabel: UILabel!
    @IBOutlet weak var addTokenTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var tokenPickerView: UIPickerView!
    @IBOutlet weak var pickerCancelButton: UIButton!
    @IBOutlet weak var pickerDoneButton: UIButton!
    @IBOutlet weak var pickerBackView: UIView!
    @IBOutlet weak var pickerBackBireBottom: NSLayoutConstraint!
    @IBOutlet weak var amtLabel: UILabel!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var allowPurchasingLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    
    //MARK:- Varisables
    
    var shareType = ["Public","Friends","Groups","Private"]
    var index : Int!
    // var amtArray : [TokenAmount]!
    var sharingData = ["discription":"","sharetype":"","broadcastPrice":"","broadcastType":"","ids":""]
    var getChargeDelegate : GetChargeIdBack!
    var selectCountryVC : SelectCountryVC?
    
    var selectedAmt = ""
    var amountArray = StringArray()
    var perBroadcastArray = StringArray()
    var perMinuteArray = StringArray()
    var selectedFollowers : StringArray = []
    
    //MARK:- view lifecycle
    //========================
    
    override func viewDidLayoutSubviews() {
        self.toggleSwitch.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.pickerBackBireBottom.constant = -200
            self.view.layoutIfNeeded()
            
        }
        
    }
    
}


//IBActions
//===============
extension SharingInformationVC{
    
    //MARK:- Back button tapped
    //============================
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.pickerBackBireBottom.constant = -200
            self.view.layoutIfNeeded()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Broadcast button tapped
    //==================================
    @IBAction func broadcastButtontapped(_ sender: UIButton) {
        self.broadcastButton.setImage( UIImage(named: "selectRounded"), for: UIControlState.normal)
        self.minuteButton.setImage( UIImage(named: "roundDeselected"), for: UIControlState.normal)
        self.sharingData["broadcastType"] = "1"
        self.amountArray = self.perBroadcastArray
        self.sharingData["broadcastPrice"] = self.amountArray.first
        self.amtLabel.text = self.amountArray.first
        self.selectedAmt = self.amountArray.first ?? ""
        self.tokenPickerView.reloadAllComponents()
        
        
    }
    
    
    //MARK:- Minutes Button Tapped
    //==============================
    @IBAction func minuteButtontapped(_ sender: UIButton) {
        self.broadcastButton.setImage( UIImage(named: "roundDeselected"), for: UIControlState.normal)
        self.minuteButton.setImage( UIImage(named: "selectRounded"), for: UIControlState.normal)
        self.sharingData["broadcastType"] = "2"
        self.amountArray = self.perMinuteArray
        self.sharingData["broadcastPrice"] = self.amountArray.first
        self.amtLabel.text = self.amountArray.first
        self.selectedAmt = self.amountArray.first ?? ""
        self.tokenPickerView.reloadAllComponents()
        
    }
    
    
    
    //MARK:- Toggle switch changed
    //=================================
    @IBAction func toggleButtonChanged(_ sender: UISwitch) {
        
        if sender.isOn{
            self.addTokenLabel.isHidden = false
            self.addTokenTextField.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                
                self.bottomFooterView.frame.size.height = 154
            })
            
        }else{
            self.addTokenLabel.isHidden = true
            self.addTokenTextField.isHidden = true
            UIView.animate(withDuration: 1.0, animations: {
                self.bottomFooterView.frame.size.height = 117
            })
            
        }
        
    }
    
    //MARK:- Next button tapped
    //===========================
    @IBAction func nextButtontapped(_ sender: UIButton) {
        if self.isAllFieldsVerified(){
            
            
            UIView.animate(withDuration: 0.3) {
                self.pickerBackBireBottom.constant = -200
                self.view.layoutIfNeeded()
                
            }
            
            
            
            if ShareWith.shareWith == .Friends{
                
                let combinedFriends : StringArray =  self.selectedFollowers
                if combinedFriends.contains("all"){
                    self.sharingData["ids"] = "all"
                }else{
                    
                    self.sharingData["ids"] =
                        
                        combinedFriends.joined(separator: ",")
                }
            }else if ShareWith.shareWith == .Private{
                
                self.sharingData["ids"] = CommonWebService.sharedInstance.selectedPrivateFriend
            }
            
            self.selectCountryVC?.sharingData = self.sharingData as jsonDictionary!
            self.navigationController?.pushViewController(self.selectCountryVC!, animated: true)
        }else{
            
        }
    }
    
    
    func isAllFieldsVerified() -> Bool{
        
        if self.sharingData["discription"] == ""{
            
            CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("add description", comment: ""), vc: self)
            
            return false
        }else if self.sharingData["sharetype"] == ""{
            
            CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("share with", comment: ""), vc: self)
            
            return false
        }else if ShareWith.shareWith == .Friends && self.selectedFollowers.isEmpty{
            CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("select friends for group", comment: ""), vc: self)
            return false
        }else if ShareWith.shareWith == .Private && CommonWebService.sharedInstance.selectedPrivateFriend == ""{
            CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString( "select a friend", comment: ""), vc: self)
            return false
        }
            
        else{
            return true
        }
    }
    
    //MARK:- Dropdown tapped
    //============================
    @IBAction func tokenDropDownTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.pickerBackBireBottom.constant = 0
            
            let ind = self.amountArray.index(of: self.sharingData["broadcastPrice"]! as String)
            
            self.tokenPickerView.selectRow(ind!, inComponent: 0, animated: true)
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pickerCancelButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.pickerBackBireBottom.constant = -200
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    
    @IBAction func doneButtontapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.pickerBackBireBottom.constant = -200
            self.view.layoutIfNeeded()
            self.amtLabel.text = self.selectedAmt
            self.sharingData["broadcastPrice"] = self.selectedAmt
        }
        
    }
}

//MARK:- Private Methods
//=========================
private extension SharingInformationVC{
    func setUpSubView(){
        self.sharingInfoTableView.delegate = self
        self.sharingInfoTableView.dataSource = self
        self.nextButton.layer.cornerRadius = 3.0
        self.nextButton.clipsToBounds = true
        self.nextButton.layer.borderWidth = 1.0
        self.nextButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.dropDownButton.layer.cornerRadius = 1.0
        self.dropDownButton.clipsToBounds = true
        self.dropDownButton.layer.borderWidth = 1.0
        self.dropDownButton.layer.borderColor = AppColors.borderColor.cgColor
        self.pickerBackBireBottom.constant = -200
        self.sharingInfoTableView.isHidden = true
        // self.bottomFooterView.isHidden = true
        
        
        //  self.getTokenAmts()
        self.getNewTokenAmts()
        
        //self.sharingData["discription"] = "hello guys"
        self.sharingData["broadcastType"] = "1"
        self.index = 0
        self.sharingData["sharetype"] = "Public"
        
        self.addTokenLabel.isHidden = true
        self.cameraImageView.isHidden = true
        self.allowPurchasingLabel.isHidden = true
        self.toggleSwitch.isHidden = true
        self.addTokenTextField.isHidden = true
    }
}
//MARK:- Tableview datasource and delegate
//===========================================
extension SharingInformationVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.shareType.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.index == 0{
            return 0
            
        }else{
            return 36
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        let img = UIImageView(frame: CGRect(x: 10, y: 5, width: 25, height: 25))
        let lbl = UILabel(frame : CGRect(x: 45, y: 6 , width: 250, height: 20))
        lbl.font = AppFonts.lotoMedium.withSize(14)
        lbl.textColor = AppColors.blackColor
        vw.backgroundColor = AppColors.headerColor
        
        img.image = UIImage(named: "shareLogo")
        lbl.text = "SHARE WITH"
        
        vw.addSubview(img)
        vw.addSubview(lbl)
        
        return vw
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        let img = UIImageView(frame: CGRect(x: 10, y: 5, width: 25, height: 25))
        let lbl = UILabel(frame : CGRect(x: 45, y: 6 , width: 260, height: 20))
        lbl.font = AppFonts.lotoMedium.withSize(14)
        vw.backgroundColor = AppColors.headerColor
        lbl.textColor = AppColors.blackColor
        img.image = UIImage(named: "addTokenLabel")
        lbl.text = "ADD TOKEN PER MINUTE/BROADCAST"
        vw.addSubview(img)
        vw.addSubview(lbl)
        return vw
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareWithCell") as! ShareWithCell
        cell.shareWithImageView.image = UIImage(named: self.shareType[indexPath.row])
        cell.shareWithLabel.text =  self.shareType[indexPath.row]
        
        if let _ = self.index{
            
            if indexPath.row == self.index{
                
                //                if self.index == 2 && (self.selectedFollowers.isEmpty || !self.selectedFollowing.isEmpty){
                //                    cell.checkButton.setImage(UIImage(named: "checked"), for:UIControlState.normal)
                //
                //                }else if self.index == 3 && CommonWebService.sharedInstance.selectedPrivateFriend != ""{
                //                    cell.checkButton.setImage(UIImage(named: "checked"), for:UIControlState.normal)
                //
                //                }else{
                //                    cell.checkButton.setImage(UIImage(named: "checked"), for:UIControlState.normal)
                //
                //                }
                
                cell.checkButton.setImage(UIImage(named: "checked"), for:UIControlState.normal)
                
            }else{
                cell.checkButton.setImage(        UIImage(named: "unckecked"), for:UIControlState.normal)
            }
            
        }else{
            cell.checkButton.setImage(        UIImage(named: "unckecked"), for:UIControlState.normal)
        }
        
        
        if self.index == 0{
            self.bottomFooterView.isHidden = true
        }else{
            self.bottomFooterView.isHidden = false
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.pickerBackBireBottom.constant = -200
            self.view.layoutIfNeeded()
        }
        
        if indexPath.row == 2 || indexPath.row == 0{
            self.index = indexPath.row
            self.sharingData["sharetype"] = self.shareType[indexPath.row]
        }
        
        self.selectShareType(row: indexPath.row)
        self.sharingInfoTableView.reloadData()
    }
    
    
    func selectShareType(row:Int){
        if row == 0{
            ShareWith.shareWith = .Public
            CommonWebService.sharedInstance.selectedPrivateFriend = ""
            self.selectedFollowers.removeAll()
        }else if row == 1{
            ShareWith.shareWith = .Friends
            CommonWebService.sharedInstance.selectedPrivateFriend = ""
            self.openConnections()
        }else if row == 2{
            ShareWith.shareWith = .Group
            CommonWebService.sharedInstance.selectedPrivateFriend = ""
            self.selectedFollowers.removeAll()
        }else if row == 3{
            self.selectedFollowers.removeAll()
            ShareWith.shareWith = .Private
            self.openConnections()
        }
    }
    
    func openConnections(){
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "FollowersID") as! FollowersVC
        vc.getFriendsDelegate = self
        ConnectionsFrom.connectFrom = .SharingInformation
        
        vc.selectedFollowers = self.selectedFollowers
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}


extension SharingInformationVC:GetFriendsBack{
    func getFriendsBack(followers: StringArray) {
        
        printDebug(object: "followers-----\(self.selectedFollowers)")
        printDebug(object: CommonWebService.sharedInstance.selectedPrivateFriend )
        self.selectedFollowers = followers
        
        
        if CommonWebService.sharedInstance.selectedPrivateFriend != ""{
            self.index = 3
            self.selectedFollowers.removeAll()
            self.sharingData["sharetype"] = self.shareType[self.index]
        }else{
            self.index = 1
            CommonWebService.sharedInstance.selectedPrivateFriend = ""
            self.sharingData["sharetype"] = self.shareType[self.index]
        }
        
        
        self.sharingInfoTableView.reloadData()
    }
    
    
    func closeButtonTapped(){
        
        self.index = 0
        self.selectShareType(row: self.index)
        self.sharingInfoTableView.reloadData()
        
    }
    
}


extension SharingInformationVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.amountArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string:
            (self.amountArray[row])  , attributes: [NSForegroundColorAttributeName : AppColors.pinkColor])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        printDebug(object:self.amountArray[row])
        self.selectedAmt = self.amountArray[row]
        
    }
}

//MARK:- Webservices
//======================
extension SharingInformationVC{
    
    func getTokenAmts(){
        let params : jsonDictionary = ["":"" as AnyObject]
        CommonFunction.showLoader(vc: self)
        UserService.tokenAmtListApi(params: params) { (success, data) in
            if success{
                CommonFunction.hideLoader(vc: self)
                guard let data = data else{
                    return
                }
                self.sharingInfoTableView.isHidden = false
                //self.amtArray = data
                
                self.amountArray = data
                self.perBroadcastArray = data
                
                self.sharingData["broadcastPrice"] = self.amountArray.first
                self.amtLabel.text = self.amountArray.first
                self.selectedAmt = self.amountArray.first!
                
                self.tokenPickerView.delegate = self
                self.tokenPickerView.dataSource = self
                
                self.tokenPickerView.reloadAllComponents()
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
    
    func getNewTokenAmts(){
        let params : jsonDictionary = ["":"" as AnyObject]
        CommonFunction.showLoader(vc: self)
        
        
        UserService.newTokenAmtListApi(params: params) { (success, oneTime, perMinute) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                guard let oneTime = oneTime else{
                    return
                }
                guard let perMinute = perMinute else{
                    return
                }
                
                self.sharingInfoTableView.isHidden = false
                
                self.amountArray = oneTime
                self.perBroadcastArray = oneTime
                self.perMinuteArray = perMinute
                
                self.sharingData["broadcastPrice"] = self.amountArray.first
                self.amtLabel.text = self.amountArray.first
                self.selectedAmt = self.amountArray.first!
                
                self.tokenPickerView.delegate = self
                self.tokenPickerView.dataSource = self
                
                self.tokenPickerView.reloadAllComponents()
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
    
    
    
}

class ShareWithCell : UITableViewCell{
    @IBOutlet weak var shareWithImageView: UIImageView!
    @IBOutlet weak var shareWithLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
}


