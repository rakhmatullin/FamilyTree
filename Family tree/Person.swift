import Foundation

class Person {
    let id: Int
    let name: String
    let surname: String
    let patronymic: String
    
    init(id: Int, name: String = "Name", surname: String = "Surname", patronymic: String = "Patronymic") {
        self.id = id
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
    }
}
