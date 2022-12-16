import UIKit

class PersonViewController: UIViewController {
    weak var presenter: PersonPresenterProtocol!
    
    let tableView = UITableView()
    let nameLabel = UILabel()
    
    var person: Person
    var personChildren: [Person]
    var personParents: [Person]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        setupSubviews()
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
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    private func addSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: STANDART_SPACE).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -STANDART_SPACE).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: STANDART_SPACE).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: STANDART_SPACE).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -STANDART_SPACE).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupSubviews() {
        nameLabel.text = person.name
        nameLabel.backgroundColor = .systemBackground
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        
        tableView.dataSource = self
        
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

// MARK: UI Constants
extension PersonViewController {
    var STANDART_SPACE: CGFloat { 10 }
}

extension UIView {
    func pinEdges(to other: UIView, leadingOffset: CGFloat = 0, trailingOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: leadingOffset).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: trailingOffset).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: topOffset).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: bottomOffset).isActive = true
    }
}
