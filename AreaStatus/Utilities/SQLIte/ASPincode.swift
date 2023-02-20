
import Foundation

class ASPincode: SqliteExecution {
    
    //enum
    enum param:String {
        case ID = " ID "
        case Location = " Location "
        case PinCode = "PinCode "
        case State = " State "
    }
    enum condition:CommonTools {

        case like(param:ASPincode.param, text:String)
        
        //MARK:- methods
        var string: String{
            switch self {
            case .like(let param, let text):
                return " \(where_str) \(param) \(like_str) '\(text)%' "
            }
        }
    }
    
    init() {
        let createQuery = "CREATE TABLE IF NOT EXISTS ASPincode(\(param.ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(param.Location) TEXT, \(param.PinCode) INTEGER, \(param.State) TEXT)"
        executeChange(createQuery)
    }
    //MARK:- Select Query
    func searchFilter(_ condition: condition? = nil, selectBy: param) -> [String]{
        let selectQuery = "SELECT CAST(\(selectBy) AS TEXT) \(selectBy) FROM ASPincode \(condition?.string ?? "") GROUP BY \(selectBy)"
        let result = executeQuery(selectQuery)
        return result.compactMap{String($0[(selectBy.rawValue).trimmingCharacters(in: .whitespaces)]?.asString() ?? "")}
    }
}
