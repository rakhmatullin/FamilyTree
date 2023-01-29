import Foundation

struct HumanPair: Hashable {
    static func == (lhs: HumanPair, rhs: HumanPair) -> Bool {
        return lhs.firstHuman == rhs.firstHuman
            && lhs.secondHuman == rhs.secondHuman
    }
    
    var firstHuman: Int = 0
    var secondHuman: Int = 0
    
    init(firstHuman: Int, secondHuman: Int) {
        self.firstHuman = firstHuman
        self.secondHuman = secondHuman
    }
}

class DataManager {
    
    private static func getNewID() -> Int {
        let IDs = getIDs()
        let newID = IDs.last != nil ? IDs.last! + 1 : 0
        set(IDs: IDs + [newID], persons: getPersons())
        return newID
    }
    
    static func getPerson(by id: Int?) -> Person {
        guard let id = id, getIDs().contains(where: {$0 == id}) else {
            let newId = getNewID()
            let newPerson = Person(id: newId, name: "Person", surname: "Number \(newId)")
            add(ID: newId, person: newPerson)
            return newPerson
        }
        for person in getPersons() {
            if person.id == id {
                return person
            }
        }
        let newId = getNewID()
        let newPerson = Person(id: newId, name: "Person", surname: "Number \(newId)")
        add(ID: newId, person: newPerson)
        return newPerson
    }
    
    static func getPartners(for id: Int) -> [Person] {
        var partners: [Person] = []
        let pairsWithChildren = getPairsWithChildren()
        for key in pairsWithChildren.keys {
            guard let _ = pairsWithChildren[key]
            else { continue }
            
            partners.append(key.firstHuman != id ? DataManager.getPerson(by: key.firstHuman) : DataManager.getPerson(by: key.secondHuman))
        }
        return partners
    }
    
    static func getIDs() -> [Int] {
        UserDefaults.standard.array(forKey: "IDs") as? [Int] ?? []
    }
    
    static private func set(IDs: [Int], persons: [Person]) {
        UserDefaults.standard.set(IDs, forKey: "IDs")
        // To store in UserDefaults
        if let encoded = try? JSONEncoder().encode(persons) {
            UserDefaults.standard.set(encoded, forKey: "Persons")
        }
        //UserDefaults.standard.set(persons, forKey: "Persons")
    }
    
    static func add(ID: Int, person: Person) {
        set(IDs: getIDs() + [ID], persons: getPersons() + [person])
    }
    
    static func getPersons() -> [Person] {
        // Retrieve from UserDefaults
        if let data = UserDefaults.standard.object(forKey: "Persons") as? Data,
           let persons = try? JSONDecoder().decode([Person].self, from: data) {
            return persons
        }
        return []
        //UserDefaults.standard.array(forKey: "Persons") as? [Person] ?? []
    }
    
    static func set(pairsWithChildren: [HumanPair: [Int]]) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let fileName = "HumanPairs"

        if let documentPath = paths.first {
            let filePath = NSMutableString(string: documentPath).appendingPathComponent(fileName)

            let URL = NSURL.fileURL(withPath: filePath)

            let dictionary = NSMutableDictionary()
            for (humainPair, children) in pairsWithChildren {
                dictionary.setValue(children, forKey: "\(humainPair.firstHuman)+\(humainPair.secondHuman)")
            }
            let success = dictionary.write(to: URL, atomically: true)
            print("write: ", success)
        }
    }
    
    static func getPairsWithChildren() -> [HumanPair: [Int]] {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let fileName = "HumanPairs"

        if let documentPath = paths.first {
            let filePath = NSMutableString(string: documentPath).appendingPathComponent(fileName)

            let URL = NSURL.fileURL(withPath: filePath)

            if let dictionary = NSMutableDictionary(contentsOf: URL) as? [String: [Int]] {
                var humanDictionary = [HumanPair: [Int]]()
                for (humanPairString, children) in dictionary {
                    let plusSignIndex = humanPairString.firstIndex(of: "+")
                    guard let plusSignIndex = plusSignIndex else { continue }
                    
                    let firstID = Int(humanPairString[humanPairString.startIndex..<plusSignIndex])
                    guard let firstID = firstID else { continue }
                    
                    let secondID = Int(humanPairString[humanPairString.index(after: plusSignIndex)..<humanPairString.endIndex])
                    guard let secondID = secondID else { continue }
                    
                    humanDictionary[HumanPair(firstHuman: firstID, secondHuman: secondID)] = children
                }
                return humanDictionary
            }
        }
        return [:]
    }
    
    static func add(child: Int, to: (Int, Int)) {
        if !getIDs().contains(child) {
            add(ID: child, person: getPerson(by: child))
        }
        if !getIDs().contains(to.0) {
            add(ID: to.0, person: getPerson(by: to.0))
        }
        if !getIDs().contains(to.1) {
            add(ID: to.1, person: getPerson(by: to.1))
        }
        
        var pairsWithChildren = getPairsWithChildren()
        let pair = HumanPair(firstHuman: to.0, secondHuman: to.1)
        if let children = pairsWithChildren[pair] {
            pairsWithChildren[pair] = children + [child]
        } else {
            pairsWithChildren[pair] = [child]
        }
        set(pairsWithChildren: pairsWithChildren)
    }
    
}
