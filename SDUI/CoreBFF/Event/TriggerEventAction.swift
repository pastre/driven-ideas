public struct TriggerEventAction: Action {
    
    public static var type: String { "trigger" }
    
    private var event: LazilyDecodedTypeHolder?
    
    @Injected
    private var eventBus: EventBus
    
    public func perform(using component: Component) {
        eventBus.trigger(
            event: event
        )
    }
}
