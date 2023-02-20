

import UIKit
import Foundation

public class Constant: NSObject, CommonTools {
    
    static let instance = Constant()
    
    //image
    let pincode_image = UIImage(named: "pin_code_image")?.withRenderingMode(.alwaysTemplate)
    let post_image = UIImage(named: "post_office_image")?.withRenderingMode(.alwaysTemplate)
    let search_image = UIImage(named: "search_image")?.withRenderingMode(.alwaysTemplate)
    let cancel_image = UIImage(named: "Cancel_Image")?.withRenderingMode(.alwaysTemplate)
    let add_image = UIImage(named: "add_image")?.withRenderingMode(.alwaysTemplate)

    //Link
    let postalSearchURl = "https://api.postalpincode.in/"
    let likeSearchURl = "https://indian-cities-api-nocbegfhqg.now.sh/cities?"
    let rapidapi = "https://pincode.p.rapidapi.com/"
    
    //API calling
    func callAPiPostal(_ type:postalSearchType, completion completionHandler:@escaping((APIResult) -> Void)){
        let urlsession = URLSession.init(configuration: .default)
        let url = URL(string: type.description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.httpMethod = GET
        urlsession.dataTask(with: request) { (data, response, error) in
            if case .some(let httpresponse) = response as? HTTPURLResponse, httpresponse.statusCode == 200, let data = data, let values = try? JSONDecoder().decode([AreaDetails].self, from: data), let details = values.first{
                completionHandler(.postalSucess(details))
                return
            }
            completionHandler(.error)
        }.resume()
    }
    func callAPirapidapi(_ param:SearchPost, completion completionHandler:@escaping ((APIResult) -> Void)){
        let urlsession = URLSession.init(configuration: .default)
        let url = URL(string: Constant.instance.rapidapi)
        var urlRequest = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        urlRequest.httpMethod = POST
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = try? JSONEncoder().encode(param)
        urlsession.dataTask(with: urlRequest) { (data, response, error) in
            if case .some(let httpresponse) = response as? HTTPURLResponse, httpresponse.statusCode == 200, let data = data, let values = try? JSONDecoder().decode([SearchDetails].self, from: data){
                completionHandler(.searchResponse(values))
                return
            }
            completionHandler(.error)
        }.resume()
    }
    func callAPiSearch(_ param:[searchLikeType], completion completionHandler:@escaping ((APIResult) -> Void)){
        let params = param.compactMap{$0.description}.joined(separator: operator_and)
        let urlsession = URLSession.init(configuration: .default)
        let stringUrl = (Constant.instance.likeSearchURl + params).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: stringUrl)
        var urlRequest = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        urlRequest.httpMethod = GET
        urlsession.dataTask(with: urlRequest) { (data, response, error) in
            if case .some(let httpresponse) = response as? HTTPURLResponse, httpresponse.statusCode == 200, let data = data, let values = try? JSONDecoder().decode([SearchDetails].self, from: data){
                completionHandler(.searchResponse(values))
                return
            }
            completionHandler(.error)
        }.resume()
    }
    func getLocalJson(){
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: pincodeJson), options: .mappedIfSafe)
            _ = try JSONDecoder().decode([PincodeSearch].self, from: data)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //API result handle
    enum APIResult{
        case postalSucess(AreaDetails)
        case error
        case searchResponse([SearchDetails])
    }
}

enum postalSearchType:CustomStringConvertible {
    var description: String{
        switch self {
        case .pincode(let pincode):
            return Constant.instance.postalSearchURl + "pincode/\(pincode)"
        case .postalArea(let postalArea):
            return Constant.instance.postalSearchURl + "postoffice/\(postalArea)"
        }
    }
    case pincode(String), postalArea(String)
}

enum searchLikeType:CustomStringConvertible{
    private enum Keys:String{
        case City_like
        case District_like
        case State_like
        case City
        case District
        case State
    }
    var description: String{
        switch self {
        case .City_like(let value):
            return Keys.City_like.rawValue + "=\(value)"
        case .District_like(let value):
            return Keys.District_like.rawValue + "=\(value)"
        case .State_like(let value):
            return Keys.State_like.rawValue + "=\(value)"
        case .City(let value):
            return Keys.City.rawValue + "=\(value)"
        case .District(let value):
            return Keys.District.rawValue + "=\(value)"
        case .State(let value):
            return Keys.State.rawValue + "=\(value)"
        }
    }
    case City_like(String)
    case District_like(String)
    case State_like(String)
    case City(String)
    case District(String)
    case State(String)
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}
