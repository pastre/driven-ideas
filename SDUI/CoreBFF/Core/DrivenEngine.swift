import UIKit

public protocol DrivenEngineRendering {
    var view: UITableView? { get }
    func render(data: Data) throws
}

public final class DrivenEngine: DrivenEngineRendering {

    // MARK: - Dependencies
    
    private let componentRepository: ComponentRepository
    private let drivenDecoder: DrivenDecoder
    private let notificationCenter: NotificationCenter
    private let eventBus: EventBus
    
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
        eventRepository: EventRepository,
        notificationCenter: NotificationCenter = .default
    ) {
        self.componentRepository = componentRepository
        self.drivenDecoder = DefaultDrivenDecoder(
            actionContainer: actionRepository,
            componentContainer: componentRepository,
            useCaseContainer: useCaseRepository,
            eventContainer: eventRepository)
        self.notificationCenter = notificationCenter
        self.eventBus = .init(eventRepository: eventRepository, drivenDecoder: drivenDecoder)
        useCaseRepository.register(for: EventBus.self) { [eventBus] in
            eventBus
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
   
    public func render(data: Data) throws {
        let response = try JSONDecoder().decode([LazilyDecodedTypeHolder].self, from: data)
        let components: [Component] = try response.map {
            let type = try componentRepository.component(for: $0.type)
            let component = try type.init(from: $0, decoder: drivenDecoder)
            if let eventHandler = component as? EventHandler {
                eventBus.add(handler: eventHandler)
            }
            return component
        }
        adapter.configure(using: components)
        drivenView.reloadData()
    }
}

private enum EventHandlerCodingKeys: String, CodingKey {
    case handleableEvents
}
