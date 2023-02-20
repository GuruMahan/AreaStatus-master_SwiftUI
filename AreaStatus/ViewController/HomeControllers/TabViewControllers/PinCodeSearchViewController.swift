
import UIKit

class PinCodeSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, tableSelection, CommonTools, HADropDownDelegate{
 
    @IBOutlet weak var pinCodeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var dropDown: HADropDown!
    
    var details: AreaDetails?
    var selectIndexpath: IndexPath?
    let objectPincode = ASPincode()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        dropDown.delegate = self
        tableView.register(PlaceDefinationTableViewCell.self, forCellReuseIdentifier: String(describing: PlaceDefinationTableViewCell.self))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        indicatorView.isHidden = UserDefaults.isPincodeInstalled
        if !UserDefaults.isPincodeInstalled{
            Constant.instance.getLocalJson()
            UserDefaults.setPincodeInstalled()
            indicatorView.isHidden = true
        }
        dropDown.items = objectPincode.searchFilter(selectBy: .PinCode)
    }
    //MARK:- UITableView Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return details?.postOffice?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let headerView = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderTableViewCell.self)) as! HeaderTableViewCell
        headerView.frame = CGRect(x: 0, y: -1, width: tableView.frame.width, height: 60)
        headerView.titleLabel.text = details?.postOffice?[section].name
        headerView.delegate = self
        headerView.indexPath = IndexPath(row: 0, section: section)
        view.addSubview(headerView)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectIndexpath?.section != section{
            return 0
        }
        return 1 //Postalcodekeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceDefinationTableViewCell.self), for: indexPath) as! PlaceDefinationTableViewCell
        if let value = details?.postOffice?[indexPath.section]{
            cell.qLabel.text = Postalcodekeys.compactMap{"\($0) : \(value.getValue(forKey: PostOffice.CodingKeys(rawValue: $0)) ?? "") \n\n"}.joined()
        }else{
            cell.clearAll()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ASDetailsViewController()
        let value = details?.postOffice?[indexPath.section]
        vc.details = .init(city: value?.name, district: value?.district, state: "\(value?.state ?? "") - \(value?.pincode ?? "")")
        print("\n\n \(String(describing: value)) \n\n -------------------->")
        self.navigationController?.present(vc, animated: true)
    }
    
    //MARK:- UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDown.didTap(gesture: "")
    }
    //MARK:- Other Delegate
    func didTapAt(_ option: Option, indexPath: IndexPath) {
        selectIndexpath = selectIndexpath == indexPath ? nil : indexPath
        tableView.reloadData()
    }
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        pinCodeTextField.text = dropDown.items[index]
        searchAction(UIButton())
    }
    func didHide(dropDown: HADropDown) {
//        pinCodeTextField.resignFirstResponder()
    }
    func didShow(dropDown: HADropDown) {
        
    }
    //MARK:- Button Action
    @IBAction func pinCodeTextField(_ sender: UITextField) {
        dropDown.items = objectPincode.searchFilter(.some(.like(param: .PinCode, text: sender.text!)), selectBy: .PinCode)
        dropDown.reloadData()
    }
    @IBAction func searchAction(_ sender: UIButton) {
        if pinCodeTextField.text!.isEmpty{
            setLabelAsError(enter_pincode, status: Error, messageLabel: messageLabel)
        }else if pinCodeTextField.text?.count != 6{
            setLabelAsError(invalid_pincode, status: Error, messageLabel: messageLabel)
        }else{
            self.view.endEditing(true)
            indicatorView.isHidden = false
            Constant.instance.callAPiPostal(.pincode(pinCodeTextField.text!)) { (result) in
                DispatchQueue.main.async {
                    self.indicatorView.isHidden = true
                    if case .postalSucess(let value) = result, value.postOffice != nil{
                        self.details = value
                        self.tableView.reloadData()
                        self.setLabelAsError(value.message ?? self.empty_text, status: self.Success, messageLabel: self.messageLabel)
                        self.setstatusLabel(value.status, statusLabel: self.statusLabel)
                        return
                    }else{
                        self.setLabelAsError(self.some_error, status: self.Error, messageLabel: self.messageLabel)
                    }
                }
            }
        }
    }
}
