
import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    var indexPath:IndexPath?
    var delegate:tableSelection?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- Button Action
    @IBAction func didselect(_ sender: UIButton) {
        delegate?.didTapAt(.selectHeader, indexPath:indexPath!)
    }
}
