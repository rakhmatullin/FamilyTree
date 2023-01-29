import Foundation

protocol PersonPresenterProtocol: AnyObject {
    func getPerson() -> Person
    func getParents() -> [Person]
    func getChildren() -> [Person]
    func getPartners() -> [Person]
    func changePerson(to id: Int)
}

class PersonPresenter: PersonPresenterProtocol {
    var personId: Int
    
    init(personId: Int) {
        self.personId = personId
    }
    
    init() {
        let allIds = DataManager.getIDs()
        if allIds.count != 0 {
            personId = allIds[0]
        } else {
            let person = DataManager.getPerson(by: nil)
            personId = person.id
            // personId = DataManager.getNewID()
            // let person = Person(id: personId, name: "Elon", surname: "Musk")
            // DataManager.add(ID: personId, person: person)
        }
    }
    
    func changePerson(to id: Int) {
        personId = id
    }
    
    func getPerson() -> Person {
        DataManager.getPerson(by: personId)
    }
    
    func getParents() -> [Person] {
        let pairsWithChildren = DataManager.getPairsWithChildren()
        for pairWithChildren in pairsWithChildren {
            let pair = pairWithChildren.key
            let children = pairWithChildren.value
            if children.contains(where: { personId == $0}) {
                return [DataManager.getPerson(by: pair.firstHuman), DataManager.getPerson(by: pair.secondHuman)]
            }
        }
        return []
//        [Person(id: 10, name: "MotherName", surname: "MotherSurname"),
//        Person(id: 20, name: "FatherName", surname: "FatherSurname")]
    }
    
    func getChildren() -> [Person] {
        let pairsWithChildren = DataManager.getPairsWithChildren()
        var children: [Person] = []
        for pairWithChildren in pairsWithChildren {
            let pair = pairWithChildren.key
            if pair.firstHuman == personId || pair.secondHuman == personId {
                children.append(contentsOf: pairWithChildren.value.map({ DataManager.getPerson(by: $0) }))
            }
        }
        return children
//        [Person(id: 30, name: "ChildName1", surname: "Armstrong"),
//        Person(id: 31, name: "ChildName2", surname: "Williams"),
//        Person(id: 32, name: "ChildName3", surname: "Redcliff")]
    }
    
    func getPartners() -> [Person] {
        DataManager.getPartners(for: personId)
    }
    
}
