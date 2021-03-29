import UIKit

class ModelCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!

    func configureWith(_ model: ModelViewModel) {
        titleLabel.text = model.name
        
        let backgroundColor: UIColor
        switch model.rowType {
            case .even:
                backgroundColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 236.0/255, alpha: 1)
            case .odd:
                backgroundColor = UIColor(red: 219.0/255, green: 230.0/255, blue: 236.0/255, alpha: 1)
        }
        contentView.backgroundColor = backgroundColor
    }
}
