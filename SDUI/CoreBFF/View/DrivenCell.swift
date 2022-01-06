import UIKit

final class DrivenCell: UITableViewCell {
    
    override func prepareForReuse() {
        contentView.subviews.removeSubviews()
    }
    
    func configure(drivenView: UIView) {
        contentView.addSubview(drivenView)
        drivenView.layout {
            $0.topAnchor.constraint(equalTo: contentView.topAnchor)
            $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        }
    }
}
