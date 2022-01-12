import Foundation
import UIKit
import Combine
import CoreBFF

final class DemoViewController: UIViewController {
    
    private let engine: DrivenEngineRendering
    
    init(engine: DrivenEngineRendering) {
        self.engine = engine
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should only be used programatically")
    }
    
    override func loadView() {
        view = engine.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = Payloads.b
        do {
            try engine.render(data: data)
        } catch {
            // TODO log error on crashlytics + present user try again screen
            print(error)
        }
    }
}
