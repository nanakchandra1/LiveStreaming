
import UIKit
import CoreData
import KVNProgress


class DataBaseControler: NSObject {

//    class func insertEmogies(emogieArray : [EmogiesData],version:String){
//        
//        sharedAppdelegate.persistentContainer.performBackgroundTask { (context) in
//            
//            
//            for item in emogieArray{
//                
//                if let exist = self.checkIfEmogieAlreadyExist(emogieId: item.emogiId!){
//                    
//                  if item.isDeleted == "1"{
//                 
//                    sharedAppdelegate.persistentContainer.viewContext.delete(exist)
//
//                    }else{
//                        exist.price = item.price
//                    }
//                    
//                }else{
//                    
//                    printDebug(object: "emogie inserted...\(item)")
//                    printDebug(object: "id inserted...\(item.emogiId)")
//                    printDebug(object: "url inserted...\(item.url)")
//
//                  self.insertEmogie(emogie: item)
//                    
//                if CommonFunction.isImageExistInDirectory(pathName:  "\(item.category ?? "")-\(item.emogiId ?? "")"){
//                   
//                    printDebug(object: "image download to path...\("\(item.category ?? "")-\(item.emogiId ?? "")")")
//
//                    CommonFunction.saveImageDocumentDirectory(pathName: "\(item.category ?? "")-\(item.emogiId ?? "")", imageUrl: item.url!)
//                   
//                    }
//                }
//            }
//            
//            AppUserDefaults.save(value: "\(version)", forKey: AppUserDefaults.Key.EmogiesVersion)
//
//            
//            self.saveContext()
//
//        }
//        
//    }
    
    
    
    class func insertEmogies(emogieArray : [EmogiesData],version:String,vcObj:UIViewController){
        
        printDebug(object: "insert emogie called")
        
            sharedAppdelegate.persistentContainer.performBackgroundTask { (context) in
            
                DispatchQueue.main.async {
                    KVNProgress.show(withStatus: "Syncing in progress...", on: sharedAppdelegate.window)

                }
                

                
            for item in emogieArray{
                
                printDebug(object: "emogie inserted...\(item)")
                printDebug(object: "id inserted...\(String(describing: item.emogiId))")
                printDebug(object: "url inserted...\(String(describing: item.url))")
                
                self.insertEmogie(emogie: item)
                
                if !CommonFunction.isImageExistInDirectory(pathName:  "\(item.category ?? "")-\(item.emogiId ?? "")"){
                    
                    printDebug(object: "image download to path...\("\(item.category ?? "")-\(item.emogiId ?? "")")")
                    
            CommonFunction.saveImageDocumentDirectory(pathName: "\(item.category ?? "")-\(item.emogiId ?? "")", imageUrl: item.url!)
                    
                }else{

                }

            }
                
                DispatchQueue.main.async {
                    KVNProgress.dismiss()

                }
                
            AppUserDefaults.save(value: "\(version)", forKey: AppUserDefaults.Key.EmogiesVersion)
            
            self.saveContext()
            
        }
        
    }

    
    class func checkIfEmogieAlreadyExist(emogieId:String) -> WLEmogies?{
        
        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
            
            if !emogies.isEmpty{
                return emogies[0]
            }else{
                return nil
            }
            
        }else{
            return nil
        }
    }

    
//    
//    class func deleteSelectedData(emogieId:String)
//    {
//        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
//
//        
//        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "WLEmogies")
//        
//        fReq.predicate = prStr
//        
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fReq)
//        
//        sharedAppdelegate.persistentContainer.viewContext.delete(deleteRequest)
//        
//        
//        
//        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
//
//            
//            
//        }
//            if (predicate != nil)
//        {
//            fetchRequest.predicate = NSPredicate(format:predicate!)
//        }
//        if #available(iOS 9.0, *) {
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            do {
//                try myPersistentStoreCoordinator.executeRequest(deleteRequest, withContext: managedContext)
//                print_debug("Data deleted")
//            } catch let error as NSError {
//                print_debug("Detele all data in \(entity) error : \(error) \(error.userInfo)")
//                // TODO: handle the error
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }

    
    
    //MARK: Insert
    class func insertEmogie(emogie: EmogiesData){
        if #available(iOS 10.0, *) {
            let context = sharedAppdelegate.persistentContainer.viewContext
            let obj = NSEntityDescription.insertNewObject(forEntityName: "WLEmogies", into: context) as? WLEmogies
            obj?.emogiId = emogie.emogiId
            obj?.price = emogie.price
            obj?.category = emogie.category
            obj?.url = emogie.url
            obj?.version = emogie.version
            obj?.dimension = emogie.dimension
            obj?.smileyType = emogie.smileyType
            if emogie.smileyIds == ""{
                 obj?.smileyIds = ""
            }else{
                obj?.smileyIds = emogie.smileyIds
        }
            
        
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    //MARK:Delete
    class func deleteAllData(modelName:String) -> Bool
    {
        let context = sharedAppdelegate.persistentContainer.viewContext
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    
        do {
            
            let result = try sharedAppdelegate.persistentContainer.viewContext.fetch(fReq)
          
            for resultItem in result
            {
                let countryItem: AnyObject = resultItem as AnyObject
                context.delete(countryItem as! NSManagedObject)
            }
        
        }
        catch {
            
        }
        
        self.saveContext()
        
        return true
    }
    
    
    //MARK: commit/save in coredata
    class func saveContext(){
        
        if #available(iOS 10.0, *) {
            let cdhObj = sharedAppdelegate.persistentContainer.viewContext
            do {
                
                try cdhObj.save()
                // printlnDebug("------Saved in coredata------")
            }
                
            catch _ as NSError {
                //  printlnDebug(error.lo)
                
                //abort()
            }
        } else {
            // Fallback on earlier versions
        }
        
      
    }
    
    class func fetchData(modelName:String) -> [AnyObject]?{
     
      let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        do {
            
            let resul = try sharedAppdelegate.persistentContainer.viewContext.fetch(fReq)
            return resul as [AnyObject]?
        }
        catch {
            
        }
        return nil
    }
    
    class func fetchData(modelName:String, predicate:NSPredicate?) -> [AnyObject]?
    {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
      

//        let sort = NSSortDescriptor(key: "price", ascending: true)
//        
//        fReq.sortDescriptors = [sort]
//        
        if (predicate != nil)
        {
            //fReq.predicate = NSPredicate(format:predicate!)
            fReq.predicate = predicate
            
        }
        
      
        
        do {
            let resul = try sharedAppdelegate.persistentContainer.viewContext.fetch(fReq)
            return resul as [AnyObject]?
        }
            
        catch {
            
        }
        return ["" as AnyObject]
    }
    
    
    
   class func getImagePath(emogieId:String) -> (String,String,String){
        ////..........
        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
    
    printDebug(object: "prStr is \(prStr)")
    
        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
            printDebug(object: emogies)
            
            if emogies.isEmpty{
                printDebug(object: "got empty emogi")
                return ("","","")

            }
            
            guard let catagory = emogies[0].category, !emogies.isEmpty else{
                return ("","","")
            }
            
            guard let emoId = emogies[0].emogiId else{
               return ("","","")
            }
            
           // printDebug(object: "id is \(emoId)")
            guard let dimension = emogies[0].dimension else{
                return ("","","")
            }
           // printDebug(object: "designation is \(dimension)")

            guard let smileyType = emogies[0].smileyType else{
                return ("","","")
            }
            
            return ("\(catagory)-\(emoId)",dimension,smileyType)
            
        }
        
        return ("","","")
    }

    
    
    class func getSmiliIds(emogieId:String) -> String{
        
        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
        
        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
            printDebug(object: emogies)
            
            if !emogies.isEmpty{
                guard let smiliIds = emogies[0].smileyIds  else{
                    return ""
                }
                return smiliIds

            }else{
                return ""

            }
           
        }
        
        return ""
    }
    
    
    class func getCatagory(emogieId:String) -> String{
        
        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
        
        printDebug(object: "prStr is \(prStr)")
        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
            printDebug(object: emogies)
            
            if emogies.isEmpty{
                return ""
            }
            
            guard let catagory = emogies[0].category else{
                return ""
            }
            
            return catagory
            
        }
        
        return ""
    }
    
    
    class func getSmileyType(emogieId:String) -> String{
        
        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
        
        printDebug(object: "prStr is \(prStr)")
        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
            printDebug(object: emogies)
            
            if emogies.isEmpty{
                return ""
            }
            
            guard let smileyType = emogies[0].smileyType else{
                return ""
            }
            
            return smileyType
            
        }
        
        return ""
    }

    
    
//    class func insertBulkDataInEmogies(array : [[String:AnyObject]],completionBlock:@escaping ([WLEmogies]) -> Void)
//    {
//        var dataArr = [WLEmogies]()
//        var dataArrTemp = [WLEmogies]()
//        // set up a managed object context just for the insert. This is in addition to the managed object context you may have in your App Delegate.
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//        if #available(iOS 10.0, *) {
//            managedObjectContext.parent = sharedAppdelegate.persistentContainer.viewContext
//        } else {
//            // Fallback on earlier versions
//        }
//        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType);
//        
//        managedObjectContext.perform {
//            
//            while(true) {
//                
//                autoreleasepool {
//                    
//                    for param in array {
//                        
//                        let dataTemp =                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      (param)
//                        
//                        dataArr.append(dataTemp)
//                        
//                    
//                    }
//                }
//                
//                if managedObjectContext.hasChanges{
//                    do {
//                        try managedObjectContext.save()
//                    } catch {
//                        print(error)
//                    }
//                }
//                //managedObjectContext.reset()
//                if #available(iOS 10.0, *) {
//                    sharedAppdelegate.persistentContainer.viewContext.perform({
//                        
//                        if sharedAppdelegate.persistentContainer.viewContext.hasChanges{
//                            do {
//                                try sharedAppdelegate.persistentContainer.viewContext.save()
//                            } catch {
//                                print(error)
//                            }
//                        }
//                        for dataTemp in dataArr{
//                            let data = sharedAppdelegate.persistentContainer.viewContext.object(with: dataTemp.objectID) as! WLEmogies
//                            dataArrTemp.append(data)
//                        }
//                        completionBlock(dataArrTemp)
//                    })
//                } else {
//                    // Fallback on earlier versions
//                }
//                return
//            }
//        }
//    }
    
    
    
//    //MARK: check whether value exist or not
//    class func checkIfUserAlreadyExist(params: [String : AnyObject]) -> Chat?
//    {
//        if let fetchResult = DataBaseControler.fetchData("User") {
//            if (!fetchResult.isEmpty) {
//                return fetchResult[0] as? Chat
//            }
//            else {
//                return nil
//            }
//        }
//        else {
//            return nil
//        }
//    }
//    
//    
//    
//
//    class func deleteDB(){
//        
//        getMainQueue({
//            
//            let entityNames = SharedAppDelegate.managedObjectModel.entities
//            for entityName in entityNames{
//                deleteAllData(entityName.name!)
//            }
//            if SharedAppDelegate.managedObjectContext.hasChanges{
//                self.saveContext()
//            }
//        })
//    }
//    
//    //MARK: commit/save in coredata
//    class func saveContext(){
//        
//        let cdhObj = sharedAppdelegate.managedObjectContext
//        
//        do {
//            
//            try cdhObj.save()
//            // printlnDebug("------Saved in coredata------")
//        }
//            
//        catch let error as NSError {
//            //  printlnDebug(error.debugDescription)
//            
//            abort()
//        }
//    }
    
}
