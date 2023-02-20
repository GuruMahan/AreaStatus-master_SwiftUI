
import Foundation

class MSAreaDetails: SqliteExecution {
    
    init() {
        let createQuery = "CREATE TABLE IF NOT EXISTS ASAreaStatus(ID INTEGER PRIMARY KEY AUTOINCREMENT, CircleName TEXT, DeliveryStatus TEXT, DistrictName TEXT, DivisionName TEXT, Latitude FLOAT, Longitude FLOAT, OfficeName TEXT, OfficeType TEXT, PinCode INTEGER, RegionName TEXT, RelatedHeadoffice TEXT, RelatedSuboffice TEXT, StateName TEXT, Taluk TEXT, Telephone TEXT)"
        executeChange(createQuery)
    }
}
