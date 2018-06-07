
import UIKit



struct Tokens
{
    
    var tokenId : String?
    var dateCreated : String?
    var tokens: String?
    var month : String?
    
    init(){
        
    }
    
}


class TokenPurchasedVC: UIViewController {

    
    var tokenPurchased : [TokenPurchasedData] = []
    var tokenModelObj = [Tokens]()
    var dateFormater = DateFormatter()
    var monthWiseDict : [Int:[TokenPurchasedData]] = [:]
    var monthArray : [Int] = []
    var nextTimeStamp : Int = 0
    var nextAvail : Int = 0
    
    
    @IBOutlet weak var tokenPurchasedTableView: UITableView!
    @IBOutlet weak var noDataImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

private extension TokenPurchasedVC{
    
    func setUpSubView(){
        self.tokenPurchasedTableView.backgroundColor = UIColor.white
        
        self.monthArray.append(CommonFunction.getTimeStampFromDate(date: Date()))
      
            self.getPurchasedToken(stamp: CommonFunction.getTimeStampFromDate(date: Date()))
        
    }
    
    func catagorisePurchasedToken(tokensData : [TokenPurchasedData]){
    
        self.tokenModelObj = self.tokenPurchased.map({ (object) in
            var tok = Tokens()
            tok.tokenId = object.tokenId
            tok.dateCreated = object.timestamp
            tok.tokens = object.tokens

            
            let timeStampValue = Double("1111885200" )! / 1000.0
            let date =  Date.init(timeIntervalSince1970:timeStampValue)

            self.dateFormater.dateFormat = "MMMM"
         
            print("///.....\(self.dateFormater.string(from: date))")
            
            return tok
        })
    }
    
    func convertDate(date:Date) -> String{
        self.dateFormater.dateFormat = "dd-MMM-yyyy"
        return self.dateFormater.string(from: date)
    }
}


extension TokenPurchasedVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        printDebug(object: "count is ...\(self.monthArray.count)")
        return self.monthArray.count - 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.monthArray[section]
        return self.monthWiseDict[key]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 35
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45))
        let lbl = UILabel(frame : vw.frame)
        let lineView = UIView(frame: CGRect(x: 34, y: -20, width: 1, height: 65))
      let seperatorView = UIView(frame: CGRect(x: 72, y: 0, width: screenWidth - 72, height: 1))
        vw.backgroundColor = UIColor.white
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = AppFonts.lotoMedium.withSize(14)
        lbl.textColor = AppColors.blackColor
        lbl.backgroundColor = UIColor.white
        lbl.text = "November"
        let timeStampValue = Double(self.monthArray[section])

        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        
        printDebug(object: "header timestamp....\(timeStampValue).....date...\(date)")
        
        self.dateFormater.dateFormat = "MMMM"
        
        printDebug(object: "month is....\(self.dateFormater.string(from: date))")
        
        lbl.text = self.dateFormater.string(from: date)
        
        lineView.backgroundColor = UIColor.lightGray

        seperatorView.backgroundColor = AppColors.lightSeperatorColor
        
        if section == 0{
            seperatorView.isHidden = true
            lineView.isHidden = true
            
        }else{
            seperatorView.isHidden = false
            lineView.isHidden = false
            
        }
        
        lbl.addSubview(lineView)
         lbl.addSubview(seperatorView)
        vw.addSubview(lbl)
        return vw
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tokenPurchasedCell") as! TokenPurchasedCell
        
        let key = self.monthArray[indexPath.section]
        
        cell.amtLabel.text = self.monthWiseDict[key]?[indexPath.row].tokens
        
        let timeStampValue = Double(self.monthWiseDict[key]?[indexPath.row].timestamp ?? "0.0")! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        
         printDebug(object: "\(key).....\(self.convertDate(date: date))")
        
        cell.datelabel.text = self.convertDate(date: date)

        cell.hideShowLine(row: indexPath.row, section: indexPath.section)
        
        return cell
    }
    
    
    func tableView(_ taleView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if self.nextAvail == 1 && indexPath.row == (self.monthWiseDict[self.monthArray[indexPath.section]]?.count)! - 1{
            
            self.getPurchasedToken(stamp: self.nextTimeStamp)
        }
        
    }
    
}


extension TokenPurchasedVC : UIScrollViewDelegate{
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    
    }
    
}


//MARK:- Webservices
///====================
extension TokenPurchasedVC{
    
    func getPurchasedToken(stamp : Int){
     
        let params : jsonDictionary = ["userId": CurentUser.userId as AnyObject,"timestamp" : "\(stamp)" as AnyObject]
        
        CommonFunction.showLoader(vc: self)
       
        UserService.tokenPurchasedApi(params: params) { (success, data, timeStamp, nextAvail) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let dat = data{
                    
                    self.tokenPurchased = dat
                    
                    printDebug(object: "new timestamp\(String(describing: timeStamp))")
                    
                    if self.tokenPurchased.isEmpty{
                        
                        
                        self.noDataImageView.isHidden = false
                        
                        self.tokenPurchasedTableView.isHidden = true
                    
                    }else{
                        
                        self.noDataImageView.isHidden = true
                        
                        self.tokenPurchasedTableView.isHidden = false
                        
                    }
                    
                    
                    self.nextAvail = nextAvail!
                    self.nextTimeStamp = timeStamp!
                    
                    if !self.monthArray.contains(timeStamp!){
                    
                    self.monthArray.append(timeStamp!)
                    
                    }
                    
                    self.monthWiseDict[stamp] = dat
                    
                    printDebug(object: "time stamp array \(self.monthArray)")
                    
                    self.tokenPurchasedTableView.delegate = self
                    self.tokenPurchasedTableView.dataSource = self
                    self.tokenPurchasedTableView.reloadData()

                    //self.nextTimeStamp = timeStamp!
                    
                   // self.nextAvail = nextAvail!
                    
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)

                if self.monthWiseDict.isEmpty{
                self.noDataImageView.isHidden = false
                self.tokenPurchasedTableView.isHidden = true
                }
            }
        }
    }
}

class TokenPurchasedCell : UITableViewCell{
    
    @IBOutlet weak var amtLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var dotBottomLine: UIView!
    @IBOutlet weak var dotTopLine: UIView!
    
    override func awakeFromNib() {
        
        self.dotView.layer.cornerRadius = self.dotView.frame.height / 2
        self.dotView.clipsToBounds = true
    }
    
    
    func hideShowLine(row:Int,section:Int){
        
        if row == 0 && section == 0{
            self.dotTopLine.isHidden = true
            
        }else{
            
            self.dotTopLine.isHidden = false

        }
        
    }
}


