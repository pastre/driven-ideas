public protocol EventHandler {
    var handleableEvents: [Event] { get }
    func handle(event: Event)
}

extension EventHandler {
    var handleableEvents: [Event] { [] }
}

extension EventHandler {
    func handle(eventAt index: Int) {
        guard index >= 0, index < handleableEvents.count else {
            fatalError()
        }
        let event = handleableEvents[index]
        handle(event: event)
    }
}
