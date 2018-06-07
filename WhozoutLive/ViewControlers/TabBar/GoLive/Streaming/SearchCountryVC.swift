

import UIKit



class SearchCountryVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
   // @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchCountryTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBackBackView: UIView!
    
    @IBOutlet weak var tickButton: UIButton!
    
    
    //MARK:- Variables:
    
    var countryList : [CountryData] = []
    var selectedCountryList = StringArray()
    var blockedCountryList = StringArray()
    var countryDelegate : GetCountryBack!
    var filteredArray = [CountryData]()
    var shouldShowSearchResults = false
    
    
    //MARK:- view life cycle
    //==========================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.countryDelegate.getCountryBack(countryArray: self.selectedCountryList)
        self.dismiss(animated: true, completion: nil)
    }
}


private extension SearchCountryVC{
    func setUpSubView(){
        self.searchCountryTableView.delegate = self
        self.searchCountryTableView.dataSource = self
        self.searchBar.delegate = self
        self.backView.backgroundColor = UIColor.clear
        
     // let img =  UtilClass.changeImageColor(UIImage(named: "doneTick"))
        //self.tickButton.setImage(img, for: UIControlState.normal)
       // self.tickButton.imageView?.tintColor = UIColor.gray
        
        //self.view.backgroundColor = UIColor.lightGray
        
//        self.searchBackBackView.layer.borderWidth = 1.0
//        self.searchBackBackView.layer.cornerRadius = 20
//        self.searchBackBackView.clipsToBounds = true
//     
//        self.searchBar.layer.cornerRadius = 40
//        self.searchBar.clipsToBounds = true
//        
        
        // self.searchTextField.delegate = self
    }
}

extension SearchCountryVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return self.countryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if   SelectCountryType.countryType == .Blocak && indexPath.row == 0{
            return 0
        }else{
            
            return 30
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCountryCell") as! SearchCountryCell
        
        if shouldShowSearchResults{
            cell.countryNameLabel.text = self.filteredArray[indexPath.row].countryName
            
            if self.selectedCountryList.contains("All"){
                cell.tickButton.setImage(UIImage(named: "checked"), for: UIControlState.normal)
            }else if self.selectedCountryList.contains(self.filteredArray[indexPath.row].countryName!){
                cell.tickButton.setImage(UIImage(named: "checked"), for: UIControlState.normal)
            }else{
                cell.tickButton.setImage(UIImage(named: "unckecked"), for: UIControlState.normal)
            }
        }else {
            cell.countryNameLabel.text = self.countryList[indexPath.row].countryName
            if self.selectedCountryList.contains(self.countryList[indexPath.row].countryName!){
                cell.tickButton.setImage(UIImage(named: "checked"), for: UIControlState.normal)
            }else{
                cell.tickButton.setImage(UIImage(named: "unckecked"), for: UIControlState.normal)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if shouldShowSearchResults{
            if self.selectedCountryList.contains(self.filteredArray[indexPath.row].countryName!){
                
                let ind = self.selectedCountryList.index(of:self.filteredArray[indexPath.row].countryName!)
                self.selectedCountryList.remove(at: ind!)
                if self.selectedCountryList.contains("All"){
                    let allIndex = self.selectedCountryList.index(of: "All")
                    self.selectedCountryList.remove(at: allIndex!)
                }
            }else{
                self.selectedCountryList.append(self.filteredArray[indexPath.row].countryName!)
                
                
                if self.selectedCountryList.count == self.countryList.count - 1 {
                    
                    self.selectedCountryList.append("uuAll")
                    
                }
            }
            
        }else{
            if indexPath.row == 0{
                
                if self.selectedCountryList.contains("All"){
                    self.selectedCountryList.removeAll()
                }else{
                    
                    for item in self.countryList{
                        self.selectedCountryList.append(item.countryName!)
                    }
                    
                }
                self.searchCountryTableView.reloadData()
            }else{
            
             if self.selectedCountryList.contains(self.countryList[indexPath.row].countryName!)  {
                
                let ind = self.selectedCountryList.index(of:self.countryList[indexPath.row].countryName!)
                self.selectedCountryList.remove(at: ind!)
                if self.selectedCountryList.contains("All"){
                    let allIndex = self.selectedCountryList.index(of: "All")
                    self.selectedCountryList.remove(at: allIndex!)
                }
                
            }else{
                
                self.selectedCountryList.append(self.countryList[indexPath.row].countryName!)
                
                if self.selectedCountryList.count == self.countryList.count - 1 {
                    
                    self.selectedCountryList.append("All")
                    
                }
                
            }
        }
        }
        
        
        
        //        if indexPath.row == 0{
        //
        //            if self.selectedCountryList.contains("All"){
        //                self.selectedCountryList.removeAll()
        //            }else{
        //
        //                for item in self.countryList{
        //                    self.selectedCountryList.append(item.countryName!)
        //                }
        //            }
        //            self.searchCountryTableView.reloadData()
        //
        //        }else{
        //            if self.selectedCountryList.contains(self.countryList[indexPath.row].countryName!)  {
        //
        //                let ind = self.selectedCountryList.index(of: self.countryList[indexPath.row].countryName!)
        //                self.selectedCountryList.remove(at: ind!)
        //                if self.selectedCountryList.contains("All"){
        //                    let allIndex = self.selectedCountryList.index(of: "All")
        //                    self.selectedCountryList.remove(at: allIndex!)
        //                }
        //
        //            }else if self.shouldShowSearchResults && self.selectedCountryList.contains(self.filteredArray[indexPath.row].countryName!){
        //
        //                let ind = self.selectedCountryList.index(of: self.filteredArray[indexPath.row].countryName!)
        //                self.selectedCountryList.remove(at: ind!)
        //
        //                if self.selectedCountryList.contains("All"){
        //                    let allIndex = self.selectedCountryList.index(of: "All")
        //                    self.selectedCountryList.remove(at: allIndex!)
        //                }
        //            }else{
        //                if self.shouldShowSearchResults{
        //                    self.selectedCountryList.append(self.filteredArray[indexPath.row].countryName!)
        //                }else{
        //                    self.selectedCountryList.append(self.countryList[indexPath.row].countryName!)
        //                }
        //            }
            self.searchCountryTableView.reloadRows(at: [NSIndexPath(row:indexPath.row, section: 0) as IndexPath,NSIndexPath(row:0, section: 0) as IndexPath], with: UITableViewRowAnimation.none)
        //        }
        //
        
        
    }
}

extension SearchCountryVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        CommonFunction.delayy(delay: 0.1) {
            
        let searchString = textField.text!
        
       // if searchString != "All" && searchString != "all" && searchString != "A" && searchString != "a"{
            
            if (textField.text?.isEmpty)!{
                //let all = CountryData(countryData: ["_id":"0" as AnyObject,"countryCode":"all" as AnyObject,"country":"All" as AnyObject])
                //self.countryList.insert(all, at: 0)
                self.shouldShowSearchResults = false
            }else{
               // self.countryList.removeFirst()
                self.shouldShowSearchResults = true
            }
            
           
            // Filter the data array and get only those countries that match the search text.
            
            self.filteredArray = self.countryList.filter({ (country) -> Bool in
                let countryText: NSString = NSString(string:country.countryName!)
                return countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location != NSNotFound
            })
            
            self.searchCountryTableView.reloadData()
        }
   // }
        return true
   }
}


extension SearchCountryVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchBar.text!
        
        // if searchString != "All" && searchString != "all" && searchString != "A" && searchString != "a"{
    
        if (searchBar.text?.isEmpty)!{
            //let all = CountryData(countryData: ["_id":"0" as AnyObject,"countryCode":"all" as AnyObject,"country":"All" as AnyObject])
            //self.countryList.insert(all, at: 0)
            self.shouldShowSearchResults = false
        }else{
            // self.countryList.removeFirst()
            self.shouldShowSearchResults = true
        }
        
        
        // Filter the data array and get only those countries that match the search text.
        
        self.filteredArray = self.countryList.filter({ (country) -> Bool in
            let countryText: NSString = NSString(string:country.countryName!)
            return countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location != NSNotFound
        })
        
        self.searchCountryTableView.reloadData()
    }
    
}

class SearchCountryCell : UITableViewCell{
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
}


extension Array{

    func indexOfObject(object : AnyObject) -> NSInteger {
        return (self as NSArray).index(of: object)
    }
//
//    mutating func removeObject(object : AnyObject) {
//        for var index = self.indexOfObject(object: object); index != NSNotFound; index = self.indexOfObject(object: object) {
//            self.remove(at: index)
//        }
//        
//        
//        
//    }
}
