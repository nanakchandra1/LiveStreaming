

import UIKit
import SwiftyDropbox


class ShowDropBoxDataVC: UIViewController {

    var dropBoxdata : [Files.Metadata] = []
    var getDocDelegate : GetDocumentBack!
    
    @IBOutlet weak var dropBoxTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func closeButtontapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
}


//MARK:- Private functions
//============================
private extension ShowDropBoxDataVC{
    
    //MARK:- Setup your view
    //=========================
    func setupSubview(){
        
        self.dropBoxTableView.delegate = self
        self.dropBoxTableView.dataSource = self

        if self.dropBoxdata.isEmpty{
            self.dropBoxTableView.isHidden = true
            self.noDataLabel.isHidden = false
        }else{
            self.dropBoxTableView.isHidden = false
            self.noDataLabel.isHidden = true

        }
    
    }
    
}

//MARK:- Tableview datasource and delegate methods
//===================================================
extension ShowDropBoxDataVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dropBoxdata.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dropBoxdata.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropBoxTableViewCell") as! DropBoxTableViewCell
    
        cell.dropBoxFileLabel.text = self.dropBoxdata[indexPath.row].name
        
        cell.uploadButton.addTarget(self, action: #selector(ShowDropBoxDataVC.uploadButtonTapped), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func uploadButtonTapped(sender : UIButton){
        
        let ind = sender.tableViewIndexPath(tableView: self.dropBoxTableView)
        
        self.getDocDelegate.getDocBack(path: self.dropBoxdata[(ind?.row)!].pathLower!)
    }
    
}




class DropBoxTableViewCell : UITableViewCell{
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var dropBoxFileLabel: UILabel!
}
