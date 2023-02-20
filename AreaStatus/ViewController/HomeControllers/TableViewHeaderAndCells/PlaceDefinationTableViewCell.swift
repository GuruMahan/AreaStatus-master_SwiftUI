

import UIKit

class PlaceDefinationTableViewCell: UITableViewCell, CommonTools {
    
    lazy var qLabel: UILabel! = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.textColor = .gray
        label.numberOfLines = 0
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //self
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.setConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceDefinationTableViewCell{
    
    func setConstraint(){
        
        self.contentView.addSubview(self.qLabel)
        
        NSLayoutConstraint.activate([
        
            self.qLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.qLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.qLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.qLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),

        ])
        
    }
    
}

extension PlaceDefinationTableViewCell{
    
    //MARK:- Method used in this cell
    func clearAll(){
        qLabel.text = empty_text
    }
    
}
