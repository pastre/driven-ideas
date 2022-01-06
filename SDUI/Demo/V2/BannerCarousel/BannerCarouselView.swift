import UIKit

final class BannerCarouselView: ComponentView<BannerCarouselModel> {
    // MARK: - UI Components
    
    private lazy var carousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(BannerCell.self)
        return view
    }()
    
    // MARK: - View lifecycle
    
    override func addSubviews() {
        addSubview(carousel)
    }
    
    override func constraintSubviews() {
        carousel.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
            $0.heightAnchor.constraint(equalToConstant: 100)
        }
    }
    
    override func configureAdditionalSettings() {
        carousel.delegate = self
        carousel.dataSource = self
    }
    
    // MARK: - Component lifecycle
    
    override func renderModel() {
        carousel.reloadData()
    }
}

extension BannerCarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(BannerCell.self, at: indexPath)
        let banner = model.banners[indexPath.item]
        cell.configure(using: banner as? BannerModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = model.banners[indexPath.item]
        banner.action?.perform(using: banner)
    }
}

final class BannerCell: CodedCollectionViewCell {
    func configure(using bannerModel: BannerModel?) {
        guard let view = bannerModel?.view else { return }
        contentView.subviews.removeSubviews()
        contentView.addSubview(view)
        view.layout {
            $0.topAnchor.constraint(equalTo: contentView.topAnchor)
            $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        }
    }
    
    override func addSubviews() {
        
    }
    
    override func constraintSubviews() {
        
    }
}

