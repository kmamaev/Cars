import UIKit

class SpinnerCell: UITableViewCell {
    let activityIndicator: UIActivityIndicatorView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let spinnerView = SpinnerView()
        activityIndicator = spinnerView.activityIndicator
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(spinnerView)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        spinnerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        spinnerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        spinnerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        spinnerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpinnerView: UIView {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
}
