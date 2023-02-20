


import Foundation

struct PostOffice : Decodable {
    
    let block : String?
    let branchType : String?
    let circle : String?
    let country : String?
    let deliveryStatus : String?
    let descriptionField : String?
    let district : String?
    let division : String?
    let name : String?
    let pincode : String?
    let region : String?
    let state : String?
    
    enum CodingKeys: String, CodingKey {
            case block = "Block"
            case branchType = "BranchType"
            case circle = "Circle"
            case country = "Country"
            case deliveryStatus = "DeliveryStatus"
            case descriptionField = "Description"
            case district = "District"
            case division = "Division"
            case name = "Name"
            case pincode = "Pincode"
            case region = "Region"
            case state = "State"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        block = try? values?.decodeIfPresent(String.self, forKey: .block)
        branchType = try? values?.decodeIfPresent(String.self, forKey: .branchType)
        circle = try? values?.decodeIfPresent(String.self, forKey: .circle)
        country = try? values?.decodeIfPresent(String.self, forKey: .country)
        deliveryStatus = try? values?.decodeIfPresent(String.self, forKey: .deliveryStatus)
        descriptionField = try? values?.decodeIfPresent(String.self, forKey: .descriptionField)
        district = try? values?.decodeIfPresent(String.self, forKey: .district)
        division = try? values?.decodeIfPresent(String.self, forKey: .division)
        name = try? values?.decodeIfPresent(String.self, forKey: .name)
        pincode = try? values?.decodeIfPresent(String.self, forKey: .pincode)
        region = try? values?.decodeIfPresent(String.self, forKey: .region)
        state = try? values?.decodeIfPresent(String.self, forKey: .state)
    }
    func getValue(forKey key:CodingKeys?) -> String?{
        switch key {
        case .block:
            return block
        case .branchType:
            return block
        case .circle:
            return circle
        case .country:
            return country
        case .deliveryStatus:
            return deliveryStatus
        case .descriptionField:
            return descriptionField
        case .district:
            return district
        case .division:
            return division
        case .name:
            return name
        case .pincode:
            return pincode
        case .region:
            return region
        case .state:
            return state
        case .none:
            return nil
        }
    }
}
