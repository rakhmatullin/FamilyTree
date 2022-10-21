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
    
    static func getNewID() -> Int {
        let ids = getIDs()
        if let lastID = ids.last {
            return lastID + 1
        } else {
            return 0
        }
    }
    
    static func getPerson(by id: Int) -> Person {
        Person(id: id)
    }
    
    static func getIDs() -> [Int] {
        return UserDefaults.standard.array(forKey: "IDs") as? [Int] ?? []
    }
    
    static private func set(IDs: [Int]) {
        UserDefaults.standard.set(IDs, forKey: "IDs")
    }
    
    static func add(ID: Int) {
        set(IDs: getIDs() + [ID])
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
            add(ID: child)
        }
        if !getIDs().contains(to.0) {
            add(ID: to.0)
        }
        if !getIDs().contains(to.1) {
            add(ID: to.1)
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
