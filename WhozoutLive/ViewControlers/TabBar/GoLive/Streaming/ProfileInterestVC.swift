//
//  ProfileInterestVC.swift
//  glibber
//
//  Created by Ambrish on 25/04/16.
//  Copyright © 2016 Glubbr. All rights reserved.
//

import UIKit


class ProfileInterestVC: UIViewController,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var _hubName : String = ""
    var _hubId : String = ""
    
    var isFromSidePanel  = false
    var isFromFollowHub  = false

    var closure_success : (([String]) -> (Void))!
    var closure_pop : ((Bool) -> (Void))!

    
    
    var sizingCell: TagCell?
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var collectionViewArray = [String]()
    //@IBOutlet weak var tagListView_sugg: TagListView!
    
    //@IBOutlet weak var tagListView_ForSearching: TagListView!
    
    //@IBOutlet weak var scrollView_ForSearching: UIScrollView!
    
    var tagArray = [String]()
    var suggestionArray = [String]()
    var mainArray = [String]() //cilent will provide it
    
    
  //@IBOutlet weak  var scrollView: UIScrollView!
    
    @IBOutlet weak var textField: UITextField!
    
    
    func getSuggestionString(success : @escaping ([String]) -> (Void))  {
        self.closure_success = success;
    }
    
    func getPopResult(success : @escaping (Bool) -> (Void))  {
        self.closure_pop = success;
    }
    @IBAction func doneButtonTapped(sender: AnyObject) {
        //if tagArray.count > 0 {
            self.closure_success(tagArray)

        //}
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       
    }
    func onTapRightGoButton() {
        
    }
   
    
    
    func crossBtnTapped() -> Void {
        if isFromFollowHub == true {
            self.dismiss(animated: true, completion: { 
                self.closure_pop(true)
            })
            return
        }
        
        
        self.closure_success(tagArray)
        
        //}
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.mainCollectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        //self.mainCollectionView.backgroundColor = UIColor.clear
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        
        for i in 0...10 {
            self.collectionViewArray.append("testTag" + "\(i)")
        }
       
        self.mainCollectionView.reloadData()
        
       
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   // MARK: textfield delegate
 
    

}
extension ProfileInterestVC: UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewArray.count;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
        //print(customCell.frame)
        customCell.tagName.text = collectionViewArray[indexPath.item]
        
        return customCell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath as NSIndexPath)
        return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = collectionViewArray[indexPath.item]
        cell.tagName.text = tag
        print("cell max --->>\(cell.bounds.maxX)")
        
    }
}

