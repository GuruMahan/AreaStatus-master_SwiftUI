
import UIKit
import MapKit

class ASDetailsViewController: UIViewController{
    
    lazy var stateLabel: UILabel! = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
        
    }()
    
    lazy var mapView: MKMapView! = {
        
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        return mapView
        
    }()
    
    var details: SearchDetails?
    var geocoder: CLGeocoder?
    var placeMark : CLPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        // Set view
        self.setConstraint()
        self.setLabelValue()
        
        forwardGeocoder()
      
    }
    
}

extension ASDetailsViewController{
    
    /// Description:- This function is used to add view in viewcontroller parent view
    func setConstraint(){
        
        self.view.addSubview(self.stateLabel)
        self.view.addSubview(self.mapView)
        
        NSLayoutConstraint.activate([
        
            self.stateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.stateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            
            self.mapView.topAnchor.constraint(equalTo: self.stateLabel.bottomAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

        ])

    }
    
}

extension ASDetailsViewController{
    
    func setLabelValue(){
        
        var address = "\n"
        
        defer {
            self.stateLabel.text = address
        }
        
        guard let state = details?.state else {
            return
        }
        address += state
        
        guard let city = details?.city else {
            return
        }
        address += ", "
        address += city
        
        guard let district = details?.district else {
            return
        }
        address += ", "
        address += district + "\n"

    }
    
}

extension ASDetailsViewController: MKMapViewDelegate{
    //MARK:- Method used in this class
    func forwardGeocoder(){
        geocoder?.cancelGeocode()
        geocoder = CLGeocoder()
        geocoder?.geocodeAddressString((details?.getAddress())!, in: .none) { (placeMark, error) in
            if error != nil{
                return
            }
            guard let value = placeMark?.first else{
                return
            }
            self.placeMark = value
            DispatchQueue.main.async {
                self.loadMap()
            }
        }
    }
    func loadMap(){
        let latitude = placeMarkLatitude()
        let longitude = placeMarkLongitude()
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        
    }
    
    func placeMarkLatitude() -> CLLocationDegrees{
        guard let latitude = placeMark?.location?.coordinate.latitude else {
            return .zero
        }
        return latitude
    }
    
    func placeMarkLongitude() -> CLLocationDegrees{
        guard let longitude = placeMark?.location?.coordinate.longitude else {
            return .zero
        }
        return longitude
    }
}
