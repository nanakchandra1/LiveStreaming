

import Foundation
import UIKit


//["Lato-Semibold", "Lato-Black", "Lato-Medium", "Lato-MediumItalic", "Lato-Bold", "Lato-Italic", "Lato-Heavy", "Lato-Regular", "Lato-HeavyItalic", "Lato-LightItalic", "Lato-Light"]
//

enum AppFonts : String {
    case latoSemiBold = "Lato-Semibold"
    case lotoRegular = "Lato-Regular"
    case lotoMedium = "Lato-Medium"
}

extension AppFonts {

    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }

}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()


