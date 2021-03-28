import UIKit

class ManufacturerCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(_ manufacturer: ManufacturerViewModel) {
        titleLabel.text = manufacturer.name
        
        let backgroundColor: UIColor
        switch manufacturer.rowType {
            case .even:
                backgroundColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 236.0/255, alpha: 1)
            case .odd:
                backgroundColor = UIColor(red: 219.0/255, green: 230.0/255, blue: 236.0/255, alpha: 1)
        }
        contentView.backgroundColor = backgroundColor
    }
}
