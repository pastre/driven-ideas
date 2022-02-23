final class EventBus {
    
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
        do {
            let eventType = try eventRepository.event(for: event.type)
            let decodedEvent = try eventType.init(from: event, decoder: drivenDecoder)
            handlers
                .filter { $0.handleableEvents.contains(where: { event.type == $0.type }) }
                .filter { $0.handleableEvents.contains(where: { $0.id == decodedEvent.id}) }
                .forEach { $0.handle(event: decodedEvent) }
        } catch {
            // TODO log error when decoding event
        }
    }
}
