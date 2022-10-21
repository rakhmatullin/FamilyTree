import UIKit

class HumanTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cellInit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellInit()
    }
    
    private func cellInit() {
        nameLabel.textColor = .label
        nameLabel.text = "Initial text"
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //nameLabel.pinEdges(to: self)
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(text: String) {
        nameLabel.text = text
    }

}
