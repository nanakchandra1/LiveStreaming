

import UIKit

class TokenReceivedVC: UIViewController {

    @IBOutlet weak var nodataImageView: UIImageView!
    @IBOutlet weak var tokenReceivedTableView: UITableView!
    
    
    let transactions : jsonDictionary = [
        
        "1489959566162" : [["transaction":"Rahul ffdgd fg ","date" : "ddd"],["transaction":"Rahul ffdgd fg ","date" : "ddd"]] as AnyObject,
        
    "1489043338827" : [["transaction":"Rahul ffdgd fg ","date" : "ddd"],["transaction":"Rahul ffdgd fg ","date" : "ddd"],["transaction":"Rahul ffdgd fg ","date" : "ddd"]] as AnyObject
       ]
    
    var tokenReceived : [TokenReceivedData] = []
    var dateFormater = DateFormatter()
    var monthWiseDict : [Int:[TokenReceivedData]] = [:]
    var monthArray : [Int] = []
    var nextTimeStamp : Int = 0
    var nextAvail : Int = 0
    var remainingTokens : String = "0"
    var totalTokesArray : StringArray = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}

private extension TokenReceivedVC{
    
    func setUpSubView(){
        self.tokenReceivedTableView.backgroundColor = UIColor.white
        
         self.monthArray.append(CommonFunction.getTimeStampFromDate(date: Date()))
        
       self.getReceivedToken(stamp: CommonFunction.getTimeStampFromDate(date: Date()))
        
    }
    
    func convertDate(date:Date) -> String{
        
        self.dateFormater.dateFormat = "dd-MMM-yyyy"
        
        return self.dateFormater.string(from: date)
    }
    
    
}


extension TokenReceivedVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return self.monthWiseDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.monthWiseDict[self.monthArray[section]]!.count

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let key = self.monthArray[indexPath.section]

        let cmt = "\(self.monthWiseDict[key]?[indexPath.row].name ?? "") \(self.monthWiseDict[key]?[indexPath.row].content ?? "")"
        
        let height = CommonFunction.getTextHeight(text: cmt, font: AppFonts.lotoMedium.withSize(13), width: screenWidth - 107)
        
        return height + 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45))
        let lineView = UIView(frame: CGRect(x: 34, y: -20, width: 1, height: 65))

        vw.backgroundColor = UIColor.white
         vw.backgroundColor = AppColors.headerColor
        let lbl = UILabel(frame : vw.frame)
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = AppFonts.lotoMedium.withSize(14)
        lbl.textColor = AppColors.blackColor
        
        let timeStampValue = Double(self.monthArray[section])
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
       
        self.dateFormater.dateFormat = "MMMM"
        
        
         let key = self.monthArray[section]
        var totalToken = 0
        
        for item in self.monthWiseDict[key]!{
            
            totalToken = totalToken + Int(item.tokenAmount!)!
            
        }
        
        
        
        lbl.text = "\(self.dateFormater.string(from: date)) \(totalToken)"
        
       lbl.attributedText = CommonFunction.notificationAttributedString(main_string: "\(self.dateFormater.string(from: date)) \(totalToken)", stringToColor: "\(totalToken)", attributedColor: AppColors.pinkColor, mainStringColor: AppColors.blackColor, withFont: AppFonts.lotoMedium.withSize(14))
        
         lineView.backgroundColor = UIColor.lightGray
        
        if section == 0{
            lineView.isHidden = true
            
        }else{
            
            lineView.isHidden = false

        }
        
        vw.addSubview(lbl)
        vw.addSubview(lineView)
        return vw

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        printDebug(object: "followers cell for row")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tokenReceivedCell") as! TokenReceivedCell
        
        let key = self.monthArray[indexPath.section]
    
        cell.tokenReceivedLabel.text =  "\(self.monthWiseDict[key]?[indexPath.row].name ?? "") \(self.monthWiseDict[key]?[indexPath.row].content ?? "")"
        
        
        let timeStampValue = Double((self.monthWiseDict[key]?[indexPath.row].dateCreated)!)! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        
        cell.datelabel.text = self.convertDate(date: date)
        
        
        if self.monthWiseDict[key]?[indexPath.row].image! != URLName.demoUrl{
            cell.profileImageView.setImageWithStringURL(URL: (self.monthWiseDict[key]?[indexPath.row].image)!, placeholder: UIImage(named: "userPlaceholder")!)
            
        }else{
            cell.profileImageView.image = UIImage(named : "userPlaceholder")
        }

        
        return cell
    }
    
    func tableView(_ taleView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.nextAvail == 1 && indexPath.row == (self.monthWiseDict[self.monthArray[indexPath.section]]?.count)! - 1{
            
            self.getReceivedToken(stamp: self.nextTimeStamp)
        }
        
    }

    
}


extension TokenReceivedVC{

    func getReceivedToken(stamp : Int){
      
        let params : jsonDictionary = ["userId": CurentUser.userId as AnyObject,"timestamp" : "\(stamp)" as AnyObject]
        
        CommonFunction.showLoader(vc: self)
        
        UserService.tokenReceivedApi(params: params) { (success, data, timeStamp, nextAvail,remaingnToken) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let dat = data{
                    
                    self.tokenReceived = dat
                    
                    if let tok = remaingnToken{
                        
                        self.remainingTokens = "\(tok)"

                    }
                    
                    self.parent?.viewWillAppear(true)
                    
                    if self.tokenReceived.isEmpty{
                        
                        
                        self.nodataImageView.isHidden = false
                        
                        self.tokenReceivedTableView.isHidden = true
                        
                    }else{
                        
                        
                        self.nodataImageView.isHidden = true
                        
                        self.tokenReceivedTableView.isHidden = false
                        
                    }
                
                    
                    self.nextAvail = nextAvail!
                    self.nextTimeStamp = timeStamp!
                    
                    if !self.monthArray.contains(timeStamp!){
                        
                        self.monthArray.append(timeStamp!)
                        
                    }
                   // self.totalTokesArray.append("\(totalTokensForMonth!)")
                    
                    self.monthWiseDict[stamp] = dat
                    
                    printDebug(object: "time stamp array \(self.monthArray)")
                    
                    self.tokenReceivedTableView.delegate = self
                    self.tokenReceivedTableView.dataSource = self
                    self.tokenReceivedTableView.reloadData()
                  
                }
                
            }else{
                
                
                CommonFunction.hideLoader(vc: self)

                if self.monthWiseDict.isEmpty{
                self.nodataImageView.isHidden = false
                self.tokenReceivedTableView.isHidden = true
                }
            }
        }
        
    }

    
    
}

class TokenReceivedCell : UITableViewCell{
    
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var tokenReceivedLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
        
    }
    
}

