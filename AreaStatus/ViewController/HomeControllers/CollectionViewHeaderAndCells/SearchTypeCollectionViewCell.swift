
import UIKit

class SearchTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dissmisButton: UIButton!
    @IBOutlet weak var searchTypeLabel: UILabel!
    
    var delegate:tableSelection?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDismissOption()
    }
    //MARK:- Method used in this cell
    func setAddOption(){
        dissmisButton.setImage(Constant.instance.add_image, for: .normal)
        dissmisButton.tintColor = .green
    }
    func setDismissOption(){
        dissmisButton.setImage(Constant.instance.cancel_image, for: .normal)
        dissmisButton.tintColor = .red
    }
    //MARK:- Button Action
    @IBAction func addAndDismissAction(_ sender: UIButton) {
        delegate?.didTapAt(.addOrDismiss, indexPath: indexPath!)
    }
}
