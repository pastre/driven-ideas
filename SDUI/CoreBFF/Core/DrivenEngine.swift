import UIKit

public protocol DrivenEngineRendering {
    var view: UITableView? { get }
    func render(data: Data) throws
}

public final class DrivenEngine: DrivenEngineRendering {

    // MARK: - Dependencies
    
    private let componentRepository: ComponentRepository
    private let actionRepository: ActionRepository
    private let useCaseRepository: UseCaseRepository
    private let notificationCenter: NotificationCenter
    
    // MARK: - Properties
    
    private var adapter: DrivenTableViewAdapting = DrivenTableViewAdapter()
    private lazy var drivenView: UITableView = {
        let view = UITableView()
        view.register(DrivenCell.self)
        view.dataSource = adapter
        return view
    }()
    
    public weak var view: UITableView? { drivenView }
    
    // MARK: - Initialization
    
    public init(
        componentRepository: ComponentRepository,
        actionRepository: ActionRepository,
        useCaseRepository: UseCaseRepository,
        notificationCenter: NotificationCenter = .default
    ) {
        self.componentRepository = componentRepository
        self.actionRepository = actionRepository
        self.useCaseRepository = useCaseRepository
        self.notificationCenter = notificationCenter
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
   
    public func render(data: Data) throws {
        let response = try JSONDecoder().decode([AnyComponent].self, from: data)
        let components: [Component] = try response.map {
            let type = try componentRepository.component(for: $0.type)
            let component = try type.init(from: $0)
            
            try component.resolveNestedComponents(
                from: $0,
                componentRepository: componentRepository,
                actionRepository: actionRepository,
                useCaseRepository: useCaseRepository
            )
            try component.resolveAction(
                using: actionRepository,
                useCaseRepository: useCaseRepository,
                anyAction: $0.action)
            return component
        }
        adapter.configure(using: components)
        drivenView.reloadData()
    }
}
