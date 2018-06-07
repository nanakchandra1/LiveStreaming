

import UIKit

class ReportAbuseVC: UIViewController {

    var abuses = ["In appropriate","Offensive","Obscese","Pornography","Copyright","Abusive"]
    
    var index : Int!
    var reportDelegate : ReportAbuse!
    
    @IBOutlet weak var reportAbusetableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    //View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setUpSubView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    }
    

    @IBAction func backButtontapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
 
    }
    
    
    @IBAction func doneButtontapped(_ sender: UIButton) {
        
        self.reportDelegate.report(reason: self.abuses[self.index])
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    

}


extension ReportAbuseVC{
    
    func setUpSubView(){
        
self.reportAbusetableView.delegate = self
        self.reportAbusetableView.dataSource = self
        
        
    }
    
}

extension ReportAbuseVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.abuses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportabuseCell") as! ReportabuseCell
        
        cell.reportAbuselabel.text = self.abuses[indexPath.row]
        
        if let _ = self.index{
            if self.index == indexPath.row{
                cell.tickImage.image = UIImage(named: "checked")
            }else{
                cell.tickImage.image = UIImage(named: "unckecked")
            }
        }else{
            cell.tickImage.image = UIImage(named: "unckecked")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.reportAbusetableView.reloadData()
    }
    
}




class ReportabuseCell : UITableViewCell{
    
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var reportAbuselabel: UILabel!
    
    
}

