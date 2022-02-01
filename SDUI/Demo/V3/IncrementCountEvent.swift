import CoreBFF
import UIKit

struct IncrementCountEvent: Event {
    static var type: String { "incrementCountEvent" }
    let id: String
}
