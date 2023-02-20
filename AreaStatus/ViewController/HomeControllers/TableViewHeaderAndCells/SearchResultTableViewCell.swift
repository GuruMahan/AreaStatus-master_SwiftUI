
import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setDetails(details:SearchDetails){
        stateLabel.text = details.state
        cityLabel.text = details.city
        districtLabel.text = details.district
    }
}
