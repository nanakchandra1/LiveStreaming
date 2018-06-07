

import UIKit

class BlockedUsersVC: UIViewController {

    //MARK:- Variables
    //===================
    
    var blockedUsers : [BlockedUsersData] = []
    
    //MARK:- iBOutlets
    //=================
    @IBOutlet weak var blockedContactsTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var noBlockUsersLabel: UILabel!
    
    @IBOutlet weak var blockSearchField: UITextField!
    
    
    
    //MARK:- View life cycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubview()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    //MARK:- Close buttontapped
    //===========================
    @IBAction func closeButtontapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Private functions
//============================
private extension BlockedUsersVC{
    
    //MARK:- Setup your view
    //=========================
    func setupSubview(){
        let cellNib = UINib(nibName: "FollowingFollowersCell", bundle: nil)
        self.blockedContactsTableView.register(cellNib, forCellReuseIdentifier: "followingFollowersCell")
        
        self.blockedContactsTableView.delegate = self
        self.blockedContactsTableView.dataSource = self
        self.blockSearchField.delegate = self
        
        self.blockedContactsTableView.isHidden = true
        self.noBlockUsersLabel.isHidden = true
        
        self.blockSearchField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)

        
        self.blockUserService()
    
    }
    
}





//MARK:- Tableview datasource and delegate methods
//===================================================
extension BlockedUsersVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "followingFollowersCell") as! FollowingFollowersCell
        
        cell.liveStreamButton.isHidden = true
        cell.tickImageView.isHidden = true
        
        cell.followUnfollowBitton.setImage(UIImage(named : "blockedUserIcon"), for: UIControlState.normal)
        
        cell.followerNamelabel.text = self.blockedUsers[indexPath.row].name
        cell.profileImageView.setImageWithStringURL(URL: self.blockedUsers[indexPath.row].imageUrl!, placeholder: UIImage(named: "userPlaceholder")!)
        cell.followUnfollowBitton.addTarget(self, action: #selector(BlockedUsersVC.unblockbuttontapped), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func unblockbuttontapped(sender : UIButton){
     
        let ind = sender.tableViewIndexPath(tableView: self.blockedContactsTableView)
        
        self.unBlockuser(id: self.blockedUsers[(ind?.row)!].id!,index: (ind?.row)!)
    }
    
}




extension BlockedUsersVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        CommonFunction.delayy(delay: 0.1) {
            
            if Networking.isConnectedToNetwork{
                if (textField.text?.isEmpty)!{
                    self.blockUserService()                }else{
                    self.searchBlockService(txt: textField.text!)
                }
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
                
            }
        }
        
        return true
    }
    
}


//MARk:- webservices
//====================
extension BlockedUsersVC{
    
    //MARK:- block users list
    //===========================
    func blockUserService(){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "limit" : "0" as AnyObject]
        
        printDebug(object: params)
        CommonFunction.showLoader(vc: self)
        UserService.blockUserApi(params: params) { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                self.blockSearchField.text = ""
                if let data = data{
                    
                    if data.count > 0{
                        self.noBlockUsersLabel.isHidden = true
                        self.blockedContactsTableView.isHidden = false
                    }else{
                        self.noBlockUsersLabel.isHidden = false
                        self.blockedContactsTableView.isHidden = true
                    }
                    
                    self.blockedUsers = data
                    self.blockedContactsTableView.reloadData()
                }
                
            }else{
                self.noBlockUsersLabel.isHidden = false
                self.blockedContactsTableView.isHidden = true
                CommonFunction.hideLoader(vc: self)
            }
        }
        
    }
    
    
    func searchBlockService(txt : String){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"search" : txt as AnyObject,"limit" : "0" as AnyObject]

        UserService.searchBlockUserApi(params: params) { (success, data) in
            
            if success{
                
                if let data = data{
                    
                    if data.count > 0{
                        self.noBlockUsersLabel.isHidden = true
                        self.blockedContactsTableView.isHidden = false
                    }else{
                        self.noBlockUsersLabel.isHidden = false
                        self.blockedContactsTableView.isHidden = true
                    }
                    
                    self.blockedUsers = data
                    self.blockedContactsTableView.reloadData()
                }
                
            }else{
                self.noBlockUsersLabel.isHidden = false
                self.blockedContactsTableView.isHidden = true
            }

        }
        
    }
    
    
    //MARK:- unblock user service
    //============================
    func unBlockuser(id : String,index : Int){
        let params : jsonDictionary = ["blockId" : id as AnyObject]
    
        UserService.unBlockUser(params: params) { (success) in
         
            CommonFunction.showLoader(vc: self)
            if success{
                CommonFunction.hideLoader(vc: self)
               self.blockedUsers.remove(at: index)
                
                
                
                if  self.blockedUsers.count > 0{
                    self.noBlockUsersLabel.isHidden = true
                    self.blockedContactsTableView.isHidden = false
                }else{
                    self.noBlockUsersLabel.isHidden = false
                    self.blockedContactsTableView.isHidden = true
                }
                
                self.blockedContactsTableView.reloadData()
               // self.blockedUsers.remo
            }else{
                CommonFunction.hideLoader(vc: self)
            }
            
        }
        
        
    }
    
    
}

