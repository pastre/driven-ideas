public protocol Event: TypeHolder, Decodable {}

public final class EventBus {
    
    private let eventRepository: EventRepository
    private let drivenDecoder: DrivenDecoder
    
    private var handlers: [EventHandler] = []
    
    init(eventRepository: EventRepository,
                drivenDecoder: DrivenDecoder) {
        self.eventRepository = eventRepository
        self.drivenDecoder = drivenDecoder
    }
    
    func add(handler: EventHandler) {
        handlers.append(handler)
    }
    
    func trigger(event: LazilyDecodedTypeHolder?) {
        guard let event = event else { return }
        handlers
            .filter { $0.handleableEvents.contains(where: { event.type == $0.type })}
            // TODO filter based on ID
            .forEach {
                guard let index = $0.handleableEvents.firstIndex(where: { event.type == $0.type })
                else { return }
                $0.handle(eventAt: index)
            }
    }
}
