
import Foundation

struct AreaDetails : Decodable {
    
    let message : String?
    let postOffice : [PostOffice]?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case postOffice = "PostOffice"
        case status = "Status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        message = try? values?.decodeIfPresent(String.self, forKey: .message)
        postOffice = try? values?.decodeIfPresent([PostOffice].self, forKey: .postOffice)
        status = try? values?.decodeIfPresent(String.self, forKey: .status)
    }
    
}

struct SearchDetails : Decodable {
    
    let city : String?
    let district : String?
    let state : String?
    
    enum CodingKeys: String, CodingKey {
        case city = "City"
        case district = "District"
        case state = "State"
    }
    init(city:String?, district:String?, state:String?) {
        self.city = city
        self.district = district
        self.state = state
    }
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        city = try? values?.decodeIfPresent(String.self, forKey: .city)
        district = try? values?.decodeIfPresent(String.self, forKey: .district)
        state = try? values?.decodeIfPresent(String.self, forKey: .state)
    }
    func getAddress() -> String {
        return city! + ", " + district! + ", " + state! + "."
    }
}

struct PincodeSearch : Decodable, SqliteExecution {
    
    let location : String?
    let pinCode : Int?
    let state : String?
    
    enum CodingKeys: String, CodingKey {
        case location = "Location"
        case pinCode = "PinCode"
        case state = "State"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        location = try? values?.decodeIfPresent(String.self, forKey: .location)
        pinCode = try? values?.decodeIfPresent(Int.self, forKey: .pinCode)
        state = try? values?.decodeIfPresent(String.self, forKey: .state)
        saveValue()
    }
    
    //MARK:- func to save pincode values
    func saveValue(){
        let insertquery = "INSERT INTO ASPincode(Location, PinCode, State)  VALUES ('\(location?.replacingOccurrences(of: "'", with: "''") ?? "")', '\(pinCode ?? 0)', '\(state ?? "")')"
        executeChange(insertquery)
    }
}

struct SearchPost : Encodable {
    
    let searchBy : String?
    let stateId : Int? = nil
    let value : String?
    enum CodingKeys: String, CodingKey {
        case searchBy = "searchBy"
        case stateId = "state_id"
        case value = "value"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(searchBy, forKey: .searchBy)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encodeIfPresent(stateId, forKey: .stateId)
    }
}
