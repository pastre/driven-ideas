import UIKit

protocol DrivenTableViewManager {
    func configure(using components: [Component])
}

typealias DrivenTableViewAdapting = DrivenTableViewManager & UITableViewDataSource

final class DrivenTableViewAdapter: NSObject, DrivenTableViewAdapting {
    private var components: [Component] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DrivenCell.self, at: indexPath)
        let component = components[indexPath.row]
        cell.configure(drivenView: component.view)
        return cell
    }
    
    func configure(using components: [Component]) {
        self.components = components
    }
}
