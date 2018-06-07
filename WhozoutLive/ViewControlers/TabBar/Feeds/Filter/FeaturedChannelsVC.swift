
import UIKit

class FeaturedChannelsVC: UIViewController {

    //MARK:- Variables
    //=====================
    var tagData : [TagData] = []
    var selectedTags : StringArray = []
    var limit : Int? = 0
    var nex : Int? = 0
    
    //MARK:- IBOutlets
    //======================
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    //MARK:- View life cycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension FeaturedChannelsVC{
    
    func setUpSubView(){
        self.tagTableView.delegate = self
        self.tagTableView.dataSource = self
        self.searchTextField.delegate = self
        self.searchTextField.autocorrectionType = .no
        self.selectedTags = VKCTabBarControllar.sharedInstance.filterTags
        self.getTags(text: "",searchEnabled: false)
        self.searchTextField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)

    }
}

extension FeaturedChannelsVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return self.tagData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "featuredChannelCell") as! FeaturedChannelCell
        
        cell.tagLabel.text = self.tagData[indexPath.row].tagName
        
    if self.selectedTags.contains(self.tagData[indexPath.row].tagId!){
        
            cell.tickImageView.image = UIImage(named: "checked")
        }else{
        
        cell.tickImageView.image = UIImage(named: "unckecked")

        }
        
     return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.selectedTags.contains(self.tagData[indexPath.row].tagId!){
        
            let ind = self.selectedTags.index(of:self.tagData[indexPath.row].tagId!)
            self.selectedTags.remove(at: ind!)
        }else{
            self.selectedTags.append(self.tagData[indexPath.row].tagId!)
        }
        
        self.tagTableView.reloadRows(at: [ NSIndexPath(row: indexPath.row, section: 0) as IndexPath], with: UITableViewRowAnimation.none)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.tagData.count >= 9 {
            if indexPath.row == self.tagData.count - 1 && self.nex == 1{
                
                 self.getTags(text: "",searchEnabled: false)
            }
        }
    }

    
    
}


extension FeaturedChannelsVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        CommonFunction.delayy(delay: 0.1) {
            self.tagData.removeAll()
            self.limit = 0
            if (textField.text?.characters.count)! > 0{
                
                self.getTags(text: textField.text!, searchEnabled: true)
            }else{
                self.getTags(text: textField.text!, searchEnabled: false)
            }
            
        }
        return true
        
    }
    
}

//MARK:- Webservices
//========================
extension FeaturedChannelsVC{

    func getTags(text:String,searchEnabled:Bool){
        
        let params : jsonDictionary = ["limit" : self.limit as AnyObject,"tag" : text as AnyObject]
       
        printDebug(object: params)
        
        if !searchEnabled{
            CommonFunction.showLoader(vc: self)
        }
        
        
    UserService.getTagsApi(params: params, searchEnabled: searchEnabled) { (success, data,limit,next) in

            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let data = data{
                    
                    self.limit = limit
                    self.nex = next
                    
                    if self.limit == 0 || searchEnabled{
                        self.tagData.removeAll()
                    }
                    
                    self.tagData.append(contentsOf: data)
                    
                    //self.tagData = data
                    
                    self.tagTableView.reloadData()
                }
                
            }else{
                self.tagData.removeAll()
                self.tagTableView.reloadData()
                CommonFunction.hideLoader(vc: self)
            }
            
        }
    }
    
}


class FeaturedChannelCell : UITableViewCell{
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var tickImageView: UIImageView!
    
}
