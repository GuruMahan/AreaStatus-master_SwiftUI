
import UIKit
import CoreLocation

class SearchingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, tableSelection, CommonTools {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //View for designs adjustment
    @IBOutlet weak var stateSearchView: UIView!
    @IBOutlet weak var districtSearchView: UIView!
    @IBOutlet weak var citySearchView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var pinCodeView: UIView!
    
    //View for designs adjustment
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var pinCodeTextField: UITextField!
    
    enum searchOption:String, CaseIterable{
        case City
        case District
        case State
        case Pincode
    }
    
    var option:[searchOption:Bool] = [.City:true, .District:true, .State:true, .Pincode:true]
    let optionValue = searchOption.allCases
    var resultDetails : [SearchDetails]?
    var geocoding = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        infoLabel.text = empty_text
    }
    //MARK:- UITableView Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultTableViewCell.self), for: indexPath) as! SearchResultTableViewCell
        cell.setDetails(details: (resultDetails?[indexPath.row])!)
        cell.selectionStyle = .none
        cell.backgroundColor = mildColors[indexPath.row % mildColors.count]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ASDetailsViewController()
        viewController.details = resultDetails?[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    //MARK:- UICollectionView Delegate and Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchTypeCollectionViewCell.self), for: indexPath) as! SearchTypeCollectionViewCell
        cell.searchTypeLabel.text = optionValue[indexPath.row].rawValue
        cell.delegate = self
        cell.indexPath = indexPath
        cell.setAddOption()
        if option[optionValue[indexPath.row]]!{
            cell.setDismissOption()
        }
        return cell
    }
    //MARK:- Other Delegate
    func didTapAt(_ option: Option, indexPath: IndexPath) {
        self.option[optionValue[indexPath.row]] = !(self.option[optionValue[indexPath.row]]!)
        citySearchView.isHidden = !(self.option[.City]!)
        districtSearchView.isHidden = !(self.option[.District]!)
        stateSearchView.isHidden = !(self.option[.State]!)
        pinCodeView.isHidden = !(self.option[.Pincode]!)
        searchView.isHidden = !(self.option.values.contains(true))
        setDefaultField()
        resultDetails = []
        collectionView.reloadData()
        tableView.reloadData()
    }
    //MARK:- Button Action
    @IBAction func searchAction(_ sender: UIButton) {
        if cityTextField.text!.isEmpty && option[.City]!{
            cityTextField.becomeFirstResponder()
            infoMessage(message: city_field_error, color: .red)
        }else if districtTextField.text!.isEmpty && option[.District]! {
            districtTextField.becomeFirstResponder()
            infoMessage(message: district_field_error, color: .red)
        }else if stateTextField.text!.isEmpty && option[.State]!{
            stateTextField.becomeFirstResponder()
            infoMessage(message: state_field_error, color: .red)
        }else if pinCodeTextField.text!.isEmpty && option[.Pincode]!{
            pinCodeTextField.becomeFirstResponder()
            infoMessage(message: enter_pincode, color: .red)
        }else{
            self.view.endEditing(true)
            districtSearchView.isHidden = districtTextField.text!.isEmpty
            stateSearchView.isHidden = stateTextField.text!.isEmpty
            citySearchView.isHidden = cityTextField.text!.isEmpty
            activityIndicator.isHidden = false
            self.infoMessage(message:still_loading, color:.blue)
            Constant.instance.callAPiSearch(getSearchDetails().cityLike) { (result) in
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    if case .searchResponse(let details) = result, !details.isEmpty, details.first?.city != nil{
                        self.infoMessage(message:self.Success, color:.green)
                        self.resultDetails = details
                        self.tableView.reloadData()
                        return
                    }
                    self.forwardGeoCoding()
                }
            }
        }
    }
    //MARK:- Methods used in this class
    func forwardGeoCoding(){
        geocoding.cancelGeocode()
        geocoding.geocodeAddressString(getSearchDetails().address) { (placeMark, error) in
            if let error = error{
                self.infoMessage(message:self.not_found + error.localizedDescription, color:.red)
                return
            }
            if case .some(let placeMarks) = placeMark{
                self.infoMessage(message:self.Success, color:.green)
                self.resultDetails = placeMarks.compactMap{ SearchDetails(city: $0.locality, district: $0.subAdministrativeArea, state: $0.administrativeArea)}
                self.tableView.reloadData()
                return
            }
        }
    }
    func infoMessage(message:String, color:UIColor){
        infoLabel.text = newLine + message + newLine
        infoLabel.textColor = color
    }
    func setDefaultField() {
        stateTextField.text = empty_text
        districtTextField.text = empty_text
        cityTextField.text = empty_text
        infoLabel.text = empty_text
    }
    func getSearchDetails() -> (cityLike:[searchLikeType], address:String){
        var params:[searchLikeType] = []
        var addresses = [String]()
        for value in optionValue where option[value]!{
            switch value {
            case .City:
                params.append(.City_like(cityTextField.text!))
                addresses.append(cityTextField.text!)
            case .District:
                params.append(.District_like(districtTextField.text!))
                addresses.append(districtTextField.text!)
            case .State:
                params.append(.State_like(stateTextField.text!))
                addresses.append(stateTextField.text!)
            case .Pincode:
                break
            }
        }
        var address = addresses.joined(separator: ", ")
        address.append(".")
        return (params,address)
    }
}
