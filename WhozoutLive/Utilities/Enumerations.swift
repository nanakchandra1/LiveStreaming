

import Foundation

struct  EnumObjects{
    

}

enum SelectCountryType{
    case Add
    case Blocak
    case None

    static var countryType = SelectCountryType.None
}

enum ShowVideoControls{
    case Show
    case Hide
    
    static var shoeControls = ShowVideoControls.Show
}

enum ConnectionsFrom{
    case TabBar
    case SharingInformation
    case None
    
    static var connectFrom = ConnectionsFrom.None
}

enum ShareWith{
    case Public
    case Friends
    case Group
    case Private
    
    static var shareWith = ShareWith.Public
}

