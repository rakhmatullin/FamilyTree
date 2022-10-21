import Foundation

protocol PersonPresenterProtocol: AnyObject {
    func getPerson() -> Person
    func getParents() -> [Person]
    func getChildren() -> [Person]
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
            personId = DataManager.getNewID()
            DataManager.add(ID: personId)
        }
    }
    
    func getPerson() -> Person {
        DataManager.getPerson(by: personId)
    }
    
    func getParents() -> [Person] {
        []
    }
    
    func getChildren() -> [Person] {
        []
    }
    
}
