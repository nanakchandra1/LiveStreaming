

import UIKit

enum FromOrTo{
    
    case From
    case To
    case None
    
}

class GetHistoryVC: UIViewController {
   
    fileprivate var dateFormater : DateFormatter = DateFormatter()
    fileprivate let datePickerView:UIDatePicker = UIDatePicker()
    fileprivate var selectedHistoryPatern = ""
    fileprivate var fromOrTo = FromOrTo.None
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func weaklyButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectedHistoryPatern = "week"
        self.selectHistoryPatternButton()

    }
    
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectedHistoryPatern = "month"
        self.selectHistoryPatternButton()
    }
    
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectedHistoryPatern = "year"
        self.selectHistoryPatternButton()
    }
    
    @IBAction func fromTextFieldTapped(_ sender: UITextField) {
        printDebug(object: "from action called")
        self.fromOrTo = .From
        printDebug(object: sender.text)
    }
    
    
    @IBAction func toTextFieldTapped(_ sender: UITextField) {
        
        printDebug(object: "to action called")
        
       // self.fromOrTo = .To

       
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
    
        self.gethistory()
        
    }
    
}

private extension GetHistoryVC{
    
    func setUpSubView(){
        
        self.fromTextField.tintColor = UIColor.clear
        self.toTextField.tintColor = UIColor.clear

        self.selectedHistoryPatern = "week"
        
        self.fromTextField.delegate = self
        self.toTextField.delegate = self
        //self.dateFormater.dateFormat = "yyyy-MM-dd"
        
        self.dateFormater.dateFormat = "dd MMM yyyy"
        self.fromTextField.inputView = datePickerView
        self.toTextField.inputView = datePickerView
        self.datePickerView.datePickerMode = UIDatePickerMode.date
        
        self.datePickerView.maximumDate = Date()
        
        self.selectHistoryPatternButton()
       
        self.datePickerView.addTarget(self, action: #selector(GetHistoryVC.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker){
    
        printDebug(object: sender.date)
        
        if self.fromOrTo == .From{
            self.fromTextField.text = self.dateFormater.string(from: sender.date)
        }else{
            self.toTextField.text = self.dateFormater.string(from: sender.date)
        }
    }
    
    func selectHistoryPatternButton(){
        //selectRounded
        
        //roundDeselected
        if self.selectedHistoryPatern == "week"{
        self.weeklyButton.setImage(UIImage(named:"selectRounded"), for: UIControlState.normal)
        self.monthlyButton.setImage(UIImage(named:"roundDeselected"), for: UIControlState.normal)
        self.yearlyButton.setImage(UIImage(named:"roundDeselected"), for: UIControlState.normal)

            self.toTextField.text = self.dateFormater.string(from: Date())
            self.fromTextField.text = self.dateFormater.string(from: Date().xWeeks(-1))
            
            
            printDebug(object: "curent date\(Date())")
            
            printDebug(object: "previous week\(Date().xWeeks(-1))")
            
        }else if self.selectedHistoryPatern == "month"{
            self.weeklyButton.setImage(UIImage(named:"roundDeselected"), for: UIControlState.normal)
            self.monthlyButton.setImage(UIImage(named:"selectRounded"), for: UIControlState.normal)
            self.yearlyButton.setImage(UIImage(named:"roundDeselected"), for: UIControlState.normal)
            
            self.toTextField.text = self.dateFormater.string(from: Date())
            self.fromTextField.text = self.dateFormater.string(from: Date().xMonths(-1))
            
        }else{
            self.weeklyButton.setImage(UIImage(named:"roundDeselected"), for: UIControlState.normal)
            self.monthlyButton.setImage(UIImage(named:"roundDeselected"), for: UIControlState.normal)
            self.yearlyButton.setImage(UIImage(named:"selectRounded"), for: UIControlState.normal)
            
            self.toTextField.text = self.dateFormater.string(from: Date())
            self.fromTextField.text = self.dateFormater.string(from: Date().xYears(-1))
        }
        
    }
    
}

//MARK:- Text field delegate and data source
//============================================
extension GetHistoryVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === self.fromTextField{
            self.fromOrTo = .From
            
          self.datePickerView.date = self.dateFormater.date(from: self.fromTextField.text!)!

            
            self.datePickerView.minimumDate = Date().xYears(-200)
            
            if self.selectedHistoryPatern == "week"{
                self.datePickerView.maximumDate = self.dateFormater.date(from: self.toTextField.text!)?.xWeeks(-1)
            }else if self.selectedHistoryPatern == "month"{
                    self.datePickerView.maximumDate = self.dateFormater.date(from: self.toTextField.text!)?.xMonths(-1)
            }else{
                
                self.datePickerView.maximumDate = self.dateFormater.date(from: self.toTextField.text!)?.xYears(-1)
            }
            
            
        }else{
            self.fromOrTo = .To

            self.datePickerView.date = self.dateFormater.date(from: self.toTextField.text!)!

            self.datePickerView.maximumDate = Date()
            
            if self.selectedHistoryPatern == "week"{
                
                self.datePickerView.minimumDate = self.dateFormater.date(from: self.fromTextField.text!)?.xWeeks(1)
                
            }else if self.selectedHistoryPatern == "month"{
                self.datePickerView.minimumDate = self.dateFormater.date(from: self.fromTextField.text!)?.xMonths(1)

            }else{
                
                self.datePickerView.minimumDate = self.dateFormater.date(from: self.fromTextField.text!)?.xYears(1)

            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
}

//MARK:- webservices
//===================
extension GetHistoryVC{
    
    func gethistory(){
        
        let params = ["userId" : CurentUser.userId as AnyObject,"startDate" : self.fromTextField.text as AnyObject,"endDate" :self.toTextField.text as AnyObject,"weekMonthYear" : self.selectedHistoryPatern as AnyObject]
        CommonFunction.showLoader(vc: self)
        
        
        UserService.getHistoryApi(params: params) { (success, message) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
               _ = self.navigationController?.popViewController(animated: true)
                CommonFunction.showTsMessageSuccess(message: message!)
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
    
}
