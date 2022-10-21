import UIKit

class PersonViewController: UIViewController {
    weak var presenter: PersonPresenterProtocol!
    
    let tableView = UITableView()
    
    var person: Person
    var personChildren: [Person]
    var personParents: [Person]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinEdges(to: view)
        tableView.dataSource = self
    }
    
    convenience init() {
        self.init(presenter: PersonPresenter())
    }
    
    init(presenter: PersonPresenterProtocol) {
        self.presenter = presenter
        self.person = presenter.getPerson()
        self.personParents = presenter.getParents()
        self.personChildren = presenter.getChildren()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func updateAndReloadData() {
        person = presenter.getPerson()
        personParents = presenter.getParents()
        personChildren = presenter.getChildren()
    }
    
}

extension PersonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HumanTableViewCell()
        cell.set(text: "123")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let hasParents = personParents.count > 0
        let hasChildren = personChildren.count > 0
        return 1 + (hasParents ? 1 : 0) + (hasChildren ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        let hasParents = personParents.count > 0
        let hasChildren = personChildren.count > 0
        if hasParents && hasChildren {
            switch section {
            case 1: return personParents.count
            case 2: return personChildren.count
            default: return 0
            }
        } else if hasParents {
            switch section {
            case 1: return personParents.count
            default: return 0
            }
        } else if hasChildren {
            switch section {
            case 1: return personChildren.count
            default: return 0
            }
        } else {
           return 0
        }
    }
    
}

extension UIView {
    func pinEdges(to other: UIView, leadingOffset: CGFloat = 0, trailingOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: leadingOffset).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: trailingOffset).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: topOffset).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: bottomOffset).isActive = true
    }
}
