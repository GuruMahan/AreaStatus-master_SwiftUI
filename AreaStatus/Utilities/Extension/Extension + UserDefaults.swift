
import Foundation

extension UserDefaults{
     
    //MARK:- String used UserDefaults Keys
    static private let pincodeInstalled = "All_india_postal_area_details_saved_in_database"
    
    //MARK:- Methods and varibles used in class
    static func setPincodeInstalled(){
        standard.set(true, forKey: pincodeInstalled)
    }
    static var isPincodeInstalled:Bool{
        return standard.bool(forKey: pincodeInstalled)
    }
}
