import UIKit

class PersonViewController: UIViewController {
    var presenter: PersonPresenterProtocol {
        didSet {
            updateAndReloadData()
        }
    }
    
    let headBackgroundButton = UIButton()
    let nameLabel = UILabel()
    let stackView = UIStackView()
    let partnersTableView = UITableView()
    let parentsTableView = UITableView()
    let childrenTableView = UITableView()
    
    var partners: [Person]
    var person: Person
    var personChildren: [Person]
    var personParents: [Person]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
    }
    
    convenience init() {
        self.init(presenter: PersonPresenter())
    }
    
    init(presenter: PersonPresenterProtocol) {
        self.presenter = presenter
        self.person = presenter.getPerson()
        self.personParents = presenter.getParents()
        self.personChildren = presenter.getChildren()
        self.partners = presenter.getPartners()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func addSubviews() {
        headBackgroundButton.addTarget(self, action: #selector(tappedHeadBackgroundButton), for: .touchUpInside)
        view.addSubview(headBackgroundButton)
        headBackgroundButton.backgroundColor = .systemBlue
        headBackgroundButton.translatesAutoresizingMaskIntoConstraints = false
        headBackgroundButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        headBackgroundButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        headBackgroundButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headBackgroundButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        nameLabel.text = person.name + " " + person.surname
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        headBackgroundButton.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: headBackgroundButton.leadingAnchor, constant: standartSpace).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: headBackgroundButton.trailingAnchor, constant: -standartSpace).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: standartSpace).isActive = true
        nameLabel.heightAnchor.constraint(lessThanOrEqualTo: headBackgroundButton.heightAnchor).isActive = true
        
        partnersTableView.backgroundColor = .systemGroupedBackground
        partnersTableView.delegate = self
        partnersTableView.dataSource = self
        partnersTableView.tag = 0
        view.addSubview(partnersTableView)
        partnersTableView.translatesAutoresizingMaskIntoConstraints = false
        partnersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        partnersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        partnersTableView.topAnchor.constraint(equalTo: headBackgroundButton.bottomAnchor, constant: standartSpace).isActive = true
        partnersTableView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2).isActive = true
        let partnersTableViewHeightConstraint = partnersTableView.heightAnchor.constraint(equalToConstant: CGFloat(30 + partners.count * 44))
        partnersTableViewHeightConstraint.priority = .defaultLow
        partnersTableViewHeightConstraint.isActive = true
        parentsTableView.backgroundColor = .systemGroupedBackground
        
        // Parents
        parentsTableView.setContentCompressionResistancePriority(.required, for: .vertical)
        parentsTableView.delegate = self
        parentsTableView.dataSource = self
        parentsTableView.tag = 1
        view.addSubview(parentsTableView)
        parentsTableView.translatesAutoresizingMaskIntoConstraints = false
        parentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        parentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        parentsTableView.topAnchor.constraint(equalTo: partnersTableView.bottomAnchor, constant: standartSpace).isActive = true
        parentsTableView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2).isActive = true
        let parentsTableViewHeightConstraint = parentsTableView.heightAnchor.constraint(equalToConstant: CGFloat(30 + personParents.count * 44))
        parentsTableViewHeightConstraint.priority = .defaultLow
        parentsTableViewHeightConstraint.isActive = true
        
        // Children
        childrenTableView.bounces = false
        childrenTableView.backgroundColor = .systemGroupedBackground
        childrenTableView.showsVerticalScrollIndicator = false
        childrenTableView.isHidden = personChildren.count == 0
        childrenTableView.dataSource = self
        childrenTableView.delegate = self
        childrenTableView.tag = 2
        view.addSubview(childrenTableView)
        childrenTableView.translatesAutoresizingMaskIntoConstraints = false
        childrenTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        childrenTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        childrenTableView.topAnchor.constraint(equalTo: parentsTableView.bottomAnchor, constant: children.count > 0  ? standartSpace : 0).isActive = true
        
        let childrenTableViewHeightConstraint = childrenTableView.heightAnchor.constraint(equalToConstant: CGFloat(30 + children.count * 44))
        childrenTableViewHeightConstraint.priority = .defaultLow
        childrenTableViewHeightConstraint.isActive = true
        // childrenTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //childrenTableView.heightAnchor.constraint(equalToConstant: CGFloat(30 + children.count * 44)).isActive = true
        childrenTableView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        let emptyBottomView = UIView()
        view.addSubview(emptyBottomView)
        emptyBottomView.translatesAutoresizingMaskIntoConstraints = false
        emptyBottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        emptyBottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        emptyBottomView.topAnchor.constraint(equalTo: childrenTableView.bottomAnchor).isActive = true
        emptyBottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        emptyBottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func updateAndReloadData() {
        person = presenter.getPerson()
        personParents = presenter.getParents()
        personChildren = presenter.getChildren()
        
        person = presenter.getPerson()
        nameLabel.text = person.name + " " + person.surname
        
        partnersTableView.reloadData()
        partnersTableView.isHidden = partners.count == 0
        parentsTableView.reloadData()
        parentsTableView.isHidden = personParents.count == 0
        childrenTableView.reloadData()
        childrenTableView.isHidden = personChildren.count == 0
        view.layoutIfNeeded()
    }
    
    @objc private func tappedHeadBackgroundButton() {
        let alert = UIAlertController(title: "What do you want to edit?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit profile", style: .default) { _ in
        })
        alert.addAction(UIAlertAction(title: "Add partner", style: .default) { _ in
            let newPerson = DataManager.getPerson(by: nil)
            var pairs = DataManager.getPairsWithChildren()
            pairs[HumanPair(firstHuman: self.person.id, secondHuman: newPerson.id)] = []
            DataManager.set(pairsWithChildren: pairs)
            self.updateAndReloadData()
        })
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

// MARK: UITableViewDataSource
extension PersonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView.tag {
        case 0: return "Partners"
        case 1: return "Parents"
        case 2: return "Children"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .label
        header.textLabel?.font = UIFont.systemFont(ofSize: 24)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var people: [Person] = []
        switch tableView.tag {
        case 0: people = partners
        case 1: people = personParents
        case 2: people = personChildren
        default: return UITableViewCell()
        }
        if indexPath.row < people.count {
            let cell = HumanTableViewCell()
            let human = people[indexPath.row]
            cell.set(text: human.name + " " + human.surname)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0: return partners.count
        case 1: return personParents.count
        case 2: return personChildren.count
        default: return 0
        }
    }
    
}

// MARK: UITableViewDelegate
extension PersonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView.tag {
        case 0:
            let alert = UIAlertController(title: "What do you want to?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Open profile", style: .default) { _ in
                switch tableView.tag {
                case 0:
                    self.person = self.partners[indexPath.row]
                    self.presenter.changePerson(to: self.person.id)
                default:  break
                }
            })
            alert.addAction(UIAlertAction(title: "Add child to the partner", style: .default) { _ in
                DataManager.add(child: DataManager.getPerson(by: nil).id, to: (self.person.id, self.partners[indexPath.row].id))
                self.updateAndReloadData()
            })
            alert.addAction(.init(title: "Cancel", style: .cancel))
            present(alert, animated: true)
            
        case 1:
            person = personParents[indexPath.row]
            presenter.changePerson(to: person.id)
            updateAndReloadData()
        case 2:
            person = personChildren[indexPath.row]
            presenter.changePerson(to: person.id)
            updateAndReloadData()
        default: break
        }
    }
}

// MARK: UI Constants
extension PersonViewController {
    var standartSpace: CGFloat { 10 }
}

extension UIView {
    func pinEdges(to other: UIView, leadingOffset: CGFloat = 0, trailingOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: leadingOffset).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: trailingOffset).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor, constant: topOffset).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: bottomOffset).isActive = true
    }
}
