
import Foundation


extension UIView {
    
    func tableViewCell() -> UITableViewCell? {
        
        var tableViewcell : UIView? = self
        
        while(tableViewcell != nil)
        {
            
            if tableViewcell! is UITableViewCell {
                break
            }
            
            tableViewcell = tableViewcell!.superview
        }
        
        return tableViewcell as? UITableViewCell
        
    }
    
    func tableViewIndexPath(tableView: UITableView) -> IndexPath? {
        
        if let cell = self.tableViewCell() {
            
            return tableView.indexPath(for: cell) as IndexPath?
            
        }
        else {
            
            return nil
            
        }
        
    }
    
    func collectionviewCell() -> UICollectionViewCell? {
        
        var collectionviewCell : UIView? = self
        
        while(collectionviewCell != nil)
        {
            
            if collectionviewCell! is UICollectionViewCell {
                break
            }
            
            collectionviewCell = collectionviewCell!.superview
        }
        
        return collectionviewCell as? UICollectionViewCell
        
    }
    
    func collectionViewIndexPath(collectionView: UICollectionView) -> NSIndexPath? {
        if let cell = self.collectionviewCell() {
            return collectionView.indexPath(for: cell) as NSIndexPath?
        } else {
            return nil
        }
    }
}


extension Date {
    
    func yearsFrom(date:Date) -> Int{
        
       printDebug(object: date)
         printDebug(object: self)
        
         return Calendar.current.dateComponents( [.year], from: date, to: self).year!
    }
    
 
    func monthsFrom(date:Date) -> Int{
          return Calendar.current.dateComponents( [.month], from: date as Date, to: self).month!
    }
    
    func weeksFrom(date:Date) -> Int{
        return Calendar.current.dateComponents( [.weekday], from: date as Date, to: self).weekday!
    }
    
    func daysFrom(date:Date) -> Int{
        return Calendar.current.dateComponents( [.day], from: date as Date, to: self).day!
    }
    
    func hoursFrom(date:Date) -> Int{
        return Calendar.current.dateComponents( [.hour], from: date as Date, to: self).hour!
    }
    
    
    func minutesFrom(date:Date) -> Int{
        return Calendar.current.dateComponents( [.minute], from: date as Date, to: self).minute!
    }
    
    func secondsFrom(date:Date) -> Int{
        return Calendar.current.dateComponents( [.second], from: date as Date, to: self).second!
    }
    
    
    func offsetFrom(date:Date) -> String {
        if yearsFrom(date: date as Date)   > 0 { return "\(yearsFrom(date: date as Date)) y"   }
        if monthsFrom(date: date)  > 0 { return "\(monthsFrom(date: date)) mo"  }
        if weeksFrom(date: date)   > 0 { return "\(weeksFrom(date: date)) w"   }
        if daysFrom(date: date)    > 0 { return "\(daysFrom(date: date)) d"    }
        if hoursFrom(date: date)   > 0 { return "\(hoursFrom(date: date)) h"   }
        if minutesFrom(date: date) >= 1  { return "\(minutesFrom(date: date)) m" }
         if minutesFrom(date: date) > 0  { return "\(minutesFrom(date: date)) just now" }
        if secondsFrom(date: date) > 0 { return "\(secondsFrom(date: date)) s" }
        return ""
    }
    
    
    func timeFrom(date:Date) -> String {
        if yearsFrom(date: date as Date)   > 0 { return "\(yearsFrom(date: date as Date)) y"   }
        if monthsFrom(date: date)  > 0 { return "\(monthsFrom(date: date)) mo"  }
        if weeksFrom(date: date)   > 0 { return "\(weeksFrom(date: date)) w"   }
        if daysFrom(date: date)    > 0 { return "\(daysFrom(date: date)) d"    }
        if hoursFrom(date: date)   > 0 { return "\(hoursFrom(date: date)) h"   }
        if minutesFrom(date: date) >= 1  { return "\(minutesFrom(date: date)) m" }
        if minutesFrom(date: date) > 0  { return "\(minutesFrom(date: date)) just now" }
        if secondsFrom(date: date) > 0 { return "\(secondsFrom(date: date)) s" }
        return "just now"
    }

    func xDays(_ x: Int) -> Date {
        
        return Calendar.current.date(byAdding: .day, value: x, to: self)!
    }
    
    func xWeeks(_ x: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: x, to: self)!
    }
    
    func xMonths(_ x: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: x, to: self)!
    }
    
    func xYears(_ x: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: x, to: self)!
    }
    
    
    var weeksHoursFromToday: DateComponents {
        return Calendar.current.dateComponents( [.weekOfYear, .hour], from: self, to: Date())
    }
    
    
//    func offsetFrom(date:Date) -> String {
//        if self.yearsFrom(date: date)   > 0{
//            return "\(yearsFrom(date: date))y"
//        }
//    
//        return ""
//    }
 
    
    var relativeDateString: String {
        var result = ""
        if let weeks = weeksHoursFromToday.weekOfYear,
            let hours = weeksHoursFromToday.hour,
            weeks > 0 {
            result +=  "\(weeks) week"
            if weeks > 1 { result += "s" }
            if hours > 0 { result += " and " }
        }
        if let hours = weeksHoursFromToday.hour, hours > 0 {
            result +=  "\(hours) hour"
            if hours > 1 { result += "s" }
        }
        return result
    }
}


extension UIImageView {
    
    func setImageWithStringURL(URL : String) {
        
        let URL = NSURL(string: URL)!
        
        //        self.af_setImageWithURL(URL)
        
        self.setImageWith(URL as URL)
        

        
    }
    
    func setImageWithStringURL(URL : String, placeholder : UIImage, imageTransition : Bool = true) {
        
        if imageTransition {
            
            self.setImageWithStringURLWithAnimation(URL: URL, placeholder: placeholder)
            
        } else {
            
            let URL = NSURL(string: URL)!
            
            self.setImageWith(URL as URL, placeholderImage: placeholder)
        }
    }
    
    private func setImageWithStringURLWithAnimation(URL : String, placeholder : UIImage) {
        
       
        
        let URL = NSURL(string: URL)!
        self.setImageWith(URL as URL, placeholderImage: placeholder)
        
        // self.af_setImageWithURL( URL, placeholderImage: placeholder, filter: nil, imageTransition: .CrossDissolve(0.1))
    }
}




public extension Sequence {
    func groupBy<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
    
    
    
}


public extension Sequence {
    func groupping<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

public extension Sequence {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    public func categorise<U : Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var dict: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = keyFunc(element)
            if case nil = dict[key]?.append(element) { dict[key] = [element] }
        }
        return dict
    }
}

//MARK:=> Extension for UIDevice
public extension UIDevice {
    
    var modelName : String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    

}





