
import UIKit

class PostOfficebranchNameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, tableSelection, CommonTools, HADropDownDelegate{
    
    //Outlet for object
    @IBOutlet weak var postalAreaTextField: UITextField!
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
        dropDown.items = objectPincode.searchFilter(selectBy: .Location)
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
        return 1
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
    //MARK:- UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pinCodeTextField(textField)
    }
    //MARK:- Other Delegate
    func didTapAt(_ option: Option, indexPath: IndexPath) {
        selectIndexpath = selectIndexpath == indexPath ? nil : indexPath
        tableView.reloadData()
    }
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        postalAreaTextField.text = dropDown.items[index]
        searchAction(UIButton())
    }
    func didHide(dropDown: HADropDown) {
//        postalAreaTextField.resignFirstResponder()
    }
    func didShow(dropDown: HADropDown) {
        
    }
    //MARK:- Button Action
    @IBAction func pinCodeTextField(_ sender: UITextField) {
        dropDown.items = objectPincode.searchFilter(.some(.like(param: .Location, text: sender.text!)), selectBy: .Location)
        dropDown.reloadData()
    }
    @IBAction func searchAction(_ sender: UIButton) {
        if postalAreaTextField.text!.isEmpty{
            setLabelAsError(enter_postalarea, status: Error, messageLabel: messageLabel)
        }else{
            self.view.endEditing(true)
            indicatorView.isHidden = false
            Constant.instance.callAPiPostal(.postalArea(postalAreaTextField.text!)) { (result) in
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
