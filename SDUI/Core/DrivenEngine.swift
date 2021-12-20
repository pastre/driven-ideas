import UIKit

final class DrivenEngine {
    private let container = ComponentRepository()
    private let adapter: DrivenTableViewAdapting = DrivenTableViewAdapter()
    private(set) lazy var drivenView: UITableView = {
        let view = UITableView()
        view.register(DrivenCell.self)
        view.dataSource = adapter
        return view
    }()
   
    func register<ComponentType>(_ type: ComponentType.Type) where ComponentType: Component {
        container.register(type)
    }
    
    func render(data: Data) throws {
        let response = try JSONDecoder().decode([AnyComponent].self, from: data)
        let components: [Component] = try response.map {
            let type = try container.component(for: $0.type)
            return try type.init(from: $0)
        }
        adapter.configure(using: components)
        drivenView.reloadData()
    }
}
