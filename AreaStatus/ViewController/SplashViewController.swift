
import UIKit

class SplashViewController: UIViewController, CommonTools {

    override func viewDidLoad() {
        super.viewDidLoad()
        let main = UIStoryboard(name: "Main", bundle: .main)
        let viewController = main.instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as! HomeViewController
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}
