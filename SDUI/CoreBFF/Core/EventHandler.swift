public protocol EventHandler {
    var handleableEvents: [Event] { get }
    func handle(event: Event)
}

extension EventHandler {
    var handleableEvents: [Event] { [] }
}

extension EventHandler {
    func handle(eventAt index: Int) {
        guard index >= 0, index < handleableEvents.count
        else { preconditionFailure("Trying to handle an event that cannot be handled by this handler") }
        let event = handleableEvents[index]
        handle(event: event)
    }
}
