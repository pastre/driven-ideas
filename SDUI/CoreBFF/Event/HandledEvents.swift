@propertyWrapper
public final class HandledEvents {
    private var handledEvents: [Event]
    
    public init(handledEvents: [Event] = []) {
        self.handledEvents = handledEvents
    }
    
    public var wrappedValue: [Event] {
        handledEvents
    }
}

extension HandledEvents: Decodable {
    convenience public init(from decoder: Decoder) throws {
        self.init()
    }
}

public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> T where T: HandledEvents {
        try events(type, forKey: key) ?? .init()
    }
    
    private func events<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> T? where T: HandledEvents {
        let superDecoder = try superDecoder()
        let contextKey = DrivenContainerResolving.drivenContext

        guard let context = superDecoder.userInfo[contextKey] as? DrivenDecodingContext
        else { return nil }
        
        var events: [Event] = []
        var container = try nestedUnkeyedContainer(forKey: key)
        
        while !container.isAtEnd {
            let anyEvent = try container.decode(LazilyDecodedTypeHolder.self)
            let type = try context.eventContainer.event(for: anyEvent.type)
            let event = try type.init(from: anyEvent, decoder: DefaultDrivenDecoder(userInfo: superDecoder.userInfo))
            events.append(event)
        }
        return HandledEvents(handledEvents: events) as? T
    }
}
