import UIKit

final class BannerView: ComponentView<BannerModel> {
    // MARK: - Properties
    
    private var task: URLSessionTask?
    
    // MARK: - UI Componnets
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    override func addSubviews() {
        addSubview(imageView)
    }
    
    override func constraintSubviews() {
        imageView.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
            $0.widthAnchor.constraint(equalToConstant: 200)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
        }
    }
    
    override func renderModel() {
        task?.cancel()
        task = URLSession.shared.dataTask(with: model.imageURL) { [imageView] data, response, error in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                // TODO display error
                return
            }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        task?.resume()
    }
}
