

import UIKit
import GoogleMaps

enum MapFrom{
    case SignUp
    case Payment
    case None
}

class SelectLocationVC: BaseViewControler {

    //MARK:- variables
    //==================
    var curentlocationCircle = GMSCircle()
    var locations = [PlaceApiDtaa]()
    var searchlatitude : Double?
    var searchLongitude : Double?
    var countryCode = ""
    var country = ""
    
    var addressLine = ""
    var getCountryDelegate : GetBackCountry!
    var getBack : GetBackFromMap!
    var commingFrom = MapFrom.None
    fileprivate var address : String = ""
    
    //MARK:- IbOutlets
    //===================
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var donebutton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchLocationTableView: UITableView!
    @IBOutlet weak var locationTableViewHeight: NSLayoutConstraint!
    
//MARK:- view life cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setUpSubView()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if self.commingFrom == .SignUp{
        if self.country == ""{
            //CommonFunction.showTsMessageError(message: "Please Select a location")
          //  CommonFunction.showLoader(vc: self)
            
            if Networking.isConnectedToNetwork{
                printDebug(object: "connected")
            }else{
                 printDebug(object: "Notconnected")
            }
            //self.reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: sharedAppdelegate.latitude, longitude: sharedAppdelegate.longitude))
           // self.getCountryDelegate.getCountry(countryCode: self.countryCode, country: self.country)
           // self.dismiss(animated: true, completion: nil)

        }else{
            self.getCountryDelegate.getCountry(countryCode: self.countryCode, country: self.country)
            self.dismiss(animated: true, completion: nil)
            
        }
        }else if self.commingFrom == .Payment{
            
            //self.getCountryDelegate.getLocationBack(address: self.addressLine)
            
            self.getCountryDelegate.getLocationBack(lat: self.searchlatitude!, long: self.searchLongitude!, address: self.addressLine)
            
            self.dismiss(animated: true, completion: nil)

        }
    }
   
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if self.commingFrom == .SignUp{
       self.getBack.getBack()
        }
self.dismiss(animated: true, completion: nil)
    }
}


private extension SelectLocationVC{
    func setUpSubView(){
        self.getLatLong()
         self.mapView.delegate = self
        printDebug(object: sharedAppdelegate.latitude)
        printDebug(object: sharedAppdelegate.longitude)
       
         self.searchTextField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)
        
        if let _ = self.searchlatitude{
            let addCordinate = CLLocation(latitude: self.searchlatitude!, longitude: self.searchLongitude!)
            self.mapView.camera = self.setFirstCameraPosition(setCordinate: addCordinate, zoomLevel: 12)
            self.addMarker(coordinate: CLLocationCoordinate2D(latitude: self.searchlatitude!, longitude: self.searchLongitude!))
            CommonFunction.showLoader(vc: self)

            self.reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: self.searchlatitude!, longitude: self.searchLongitude!))
        }else{
            let addCordinate = CLLocation(latitude: sharedAppdelegate.latitude, longitude: sharedAppdelegate.longitude)
            self.mapView.camera = self.setFirstCameraPosition(setCordinate: addCordinate, zoomLevel: 12)
            self.addMarker(coordinate: CLLocationCoordinate2D(latitude: sharedAppdelegate.latitude, longitude: sharedAppdelegate.longitude))
            
            self.searchlatitude = sharedAppdelegate.latitude
            
            self.searchLongitude = sharedAppdelegate.longitude
            
            CommonFunction.showLoader(vc: self)

            self.reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: sharedAppdelegate.latitude, longitude: sharedAppdelegate.longitude))
        }
        
       
        self.searchLocationTableView.delegate = self
        self.searchLocationTableView.dataSource = self
        self.searchTextField.delegate = self
        self.locationTableViewHeight.constant = 0
       self.mapView.isMyLocationEnabled = true
        
        self.mapView.settings.myLocationButton = true
        

    }
    
    func getLatLong(){
        sharedAppdelegate.locationManager.startUpdatingLocation()
        sharedAppdelegate.locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) in
            
            printDebug(object: latitude)
            printDebug(object: longitude)

        }
        
    }
    
    func animateCameraPosition(addCordinate:CLLocation){
        CATransaction.begin()
        CATransaction.setValue(2.0, forKey: kCATransactionAnimationDuration)
    self.mapView.camera = self.setFirstCameraPosition(setCordinate: addCordinate, zoomLevel: 12)
        CATransaction.commit()
    }
    
 
    //set camera position
    func setFirstCameraPosition(setCordinate:CLLocation, zoomLevel : Float)->GMSCameraPosition{
        return  GMSCameraPosition(target: setCordinate.coordinate, zoom : zoomLevel  , bearing: 0 , viewingAngle: 0)
    }
    
    func setCameraPosition(setCordinate:CLLocation){
        let update = GMSCameraUpdate.fit(self.curentlocationCircle.bounds(), withPadding: 20.0)
        self.mapView.animate(with: update)
    }

    //MARK:= Add marker
    //========================
    func addMarker(coordinate:CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        marker.icon = UIImage(named: "marker")
        marker.map = self.mapView
    }
    
}



extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/Double.pi)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * Double.pi/180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),coordinate: locationMinMax(positive: false))
    }
}


extension SelectLocationVC : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationCell
        cell.locLbl.text = self.locations[indexPath.row].PlaceName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if self.commingFrom == .SignUp{
        self.searchLocationTableView.isHidden = true
        self.getCordinate(placeId: self.locations[indexPath.row].placeId!)
       // }else{
            
        //    self.address = self.locations[indexPath.row].PlaceName!
       // }
        
    }
    
}


extension SelectLocationVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        printDebug(object: self.searchTextField.text!)
        
        CommonFunction.delay(delay: 0.1) {
            if (textField.text?.characters.count)! > 0 {
                
                  self.getPlaces(text: (textField.text?.replacingOccurrences(of: " ", with: ""))!)
                return true
            }else{
                self.locations.removeAll()
                self.searchLocationTableView.isHidden = true
                return true

            }
            
          

        }
        
       // let searchText : String = "\(self.searchTextField.text!)\(string)".replacingOccurrences(of: " ", with: "")
        
        
        return true
    }
}

extension SelectLocationVC{
    
    func getPlaces(text:String){
        
        let params : [String : AnyObject] = ["":"" as AnyObject]
        
        UserService.fetchLocationForNap(params: params, text: text) { (success,data) in
            
    printDebug(object: data)
            self.locations.removeAll()
            guard let places = data else{
                return
            }
        self.locations = places
            
            printDebug(object: self.locations.count)
            
             self.searchLocationTableView.isHidden = false
        
            UIView.animate(withDuration: 1, animations: {
                
                let height = self.locations.count * 40

                self.locationTableViewHeight.constant = CGFloat(height
                )
           
                
                
            }, completion: { (true) in
            })

            
            self.searchLocationTableView.reloadData()
        }
        
    }
    
    
    //MARK:- Get cordinate from place id
    //=====================================
    func getCordinate(placeId:String){
        
        let params = [ "placeid" : placeId, "key" : kgoogleServerKey]
        CommonFunction.showLoader(vc: self)
        UserService.getLocationLatLong(params: params as [String : AnyObject]) { (success , data) -> Void in
            if success{
                 CommonFunction.hideLoader(vc: self)
                let status = data!["status"] as! String
                if status == "OK" {
                    if let result = data!["result"] as? [String: AnyObject]{
                        let geometry = result["geometry"] as! [String: [String: AnyObject]]
                        if let  lat = geometry["location"]!["lat"] as? CLLocationDegrees{
                           
                        self.searchlatitude = lat
                        
                        }
                        
                        if let  lng = geometry["location"]!["lng"] as? CLLocationDegrees{
                            
                            self.searchLongitude = lng
                        }
                        
                        
            self.animateCameraPosition(addCordinate: CLLocation(latitude: self.searchlatitude!, longitude: self.searchLongitude!))
                        
               self.mapView.camera = self.setFirstCameraPosition(setCordinate: CLLocation(latitude: self.searchlatitude!, longitude: self.searchLongitude!), zoomLevel: 12)
                        self.mapView.clear()
              self.addMarker(coordinate: CLLocationCoordinate2D(latitude: self.searchlatitude!, longitude: self.searchLongitude!))
                        
                self.reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: self.searchlatitude!, longitude: self.searchLongitude!))
                    }
                    
                } else {
                    
                }
            }else{
                 CommonFunction.hideLoader(vc: self)
                
            }
        }
    }
    
    
    //MARK:- get address from cordinates
    //=====================================
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
          geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            
           
            if let placeArray = placeMarks {
                printDebug(object: placeArray)
                print(placeArray[0])
                let placeAddress = placeArray[0]
               
                printDebug(object: placeAddress.addressDictionary)
                
                
               printDebug(object: placeAddress.addressDictionary?["Country"])
                printDebug(object: placeAddress.addressDictionary?["CountryCode"])
                
                if let country = placeAddress.addressDictionary?["Country"] as? String{
                    self.country = country
                }
                if let countryCode = placeAddress.addressDictionary?["CountryCode"] as? String{
                    self.countryCode = countryCode
                }

                if let address = placeAddress.addressDictionary?["FormattedAddressLines"] as? [String]{
                    self.addressLine = address.joined(separator: ",")
                    
                }
                 CommonFunction.hideLoader(vc: self)
                 printDebug(object: placeAddress.addressDictionary?["CountryCode"])
                
            }
        }
        
    }
    
}

extension SelectLocationVC : GMSMapViewDelegate{
      func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
     
        let addressView = (Bundle.main.loadNibNamed("MarkerWindow", owner: self, options: nil))![0] as! MarkerWindow
        
        addressView.addressLabel.text =  self.addressLine
        return addressView
            }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.searchLocationTableView.isHidden = true
        self.view.endEditing(true)
        
    }
}

class LocationCell : UITableViewCell{
    
    @IBOutlet weak var locLbl: UILabel!
    
}
