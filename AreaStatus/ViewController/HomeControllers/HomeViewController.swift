
import UIKit
import CoreLocation

class HomeViewController: UITabBarController, UITabBarControllerDelegate{
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationPermission()
        delegate = self
        setItemTabbar((self.tabBar.items?[0])! as UITabBarItem, withTag: 0, image: Constant.instance.pincode_image!)
        setItemTabbar((self.tabBar.items?[1])! as UITabBarItem, withTag: 1, image: Constant.instance.post_image!)
        setItemTabbar((self.tabBar.items?[2])! as UITabBarItem, withTag: 2, image: Constant.instance.search_image!)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

    }
    
    private func setItemTabbar(_ tabItem: UITabBarItem, withTag tag: Int, image :UIImage){
        tabItem.image = image
        tabItem.selectedImage = image
        tabItem.tag = tag
    }
    func setUpLocationPermission(){
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        @unknown default:
            fatalError("Unkown State")
        }
    }
}

