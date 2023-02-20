
import Foundation
import UIKit

//MARK:- Handle TableView or CollectionView Button Action
protocol tableSelection {
    func didTapAt(_ option:Option, indexPath:IndexPath)
    
}
enum Option{
    case selectHeader
    case addOrDismiss
}


protocol CommonTools {}
extension CommonTools{
    //MARK:-
    var Postalcodekeys :[String]{
        return ["Block", "BranchType", "Circle", "Country", "DeliveryStatus", "Description", "District", "Division", "Name", "Pincode", "Region", "State"]
    }
    var searchDisplayKeys:[String]{
        return ["City", "District", "State"]
    }
    var invalid_pincode:String{
        return "Please enter the correct pincode"
    }
    var enter_pincode:String{
        return "Please enter the pincode"
    }
    var some_error:String{
        return "somthing error"
    }
    var enter_postalarea:String{
        return "Please enter the pincode"
    }
    var city_field_error:String{
        return "Please enter city"
    }
    var district_field_error:String{
        return "Please enter district"
    }
    var state_field_error:String{
        return "Please enter state"
    }
    var still_loading:String{
        return "wait till loading"
    }
    var not_found:String{
        return "Result Not Found"
    }
    var Success:String{
        return "Success"
    }
    var Error:String{
        return "Error"
    }
    //MARK:-
    var operator_and:String{
        return "&"
    }
    var empty_text:String{
        return ""
    }
    var newLine:String{
        return "\n"
    }
    //MARK:- API httpMethod 
    var GET:String{
        return "GET"
    }
    var POST:String{
        return "POST"
    }
    var headers :[String:String]{
        ["x-rapidapi-host": "AirVisualraygorodskijV1.p.rapidapi.com", "x-rapidapi-key": "d62c617d08msh82bfef5a722ccd0p1d4173jsn534891dfb0a6", "content-type": "application/json"]
    }
    //MARK:- UIColors
    var mildColors:[UIColor]{
        return [.chocolate, .peru, .sandy_brown, .wheat, .tan, .burly_wood]
    }
    //MARK:- Segue identifier
    var SplashToHome:String{
        return "SplashToHome"
    }
    //MARK:- Google map Key
    var API_KEY:String{
        return "AIzaSyDPO5eDVq8Ey5HQgttA8zL2wPlLasQJ39o"
    }
    //MARK:- JSON Method
    var pincodeJson:String{
        return Bundle.main.path(forResource: "pincodes", ofType:  "json")!
    }
    //MARK:- Sqlite usage
    var where_str:String{
        return "WHERE"
    }
    var like_str:String{
        return "LIKE"
    }
    var percentage:String{
        return "%"
    }
    var single_Space:String{
        return " "
    }
    var single_quotation:String{
        return "'"
    }
    //MARK:- Common Methods
    func setLabelAsError(_ message:String, status:String, messageLabel:UILabel){
        messageLabel.text = message
        messageLabel.textColor = status == Success ? .green : .red
    }
    func setstatusLabel(_ types:String? = nil, statusLabel:UILabel){
        statusLabel.text = types ?? empty_text
        statusLabel.textColor = types == Success ? .green : .red
    }
}
