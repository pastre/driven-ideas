import Foundation

protocol Nameable: AnyObject {
    func set(name: String)
}

final class RenameUseCase {
    func execute() -> String { UUID().uuidString }
}
