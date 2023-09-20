import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

                                            // MARK: - Hash table:


                                    // MARK: - Hashing with separate chaining:
/*
 A symbol table implemented with a separate-chaining hash function.

 Symbol table implementation with sequential search in an unordered linked list of key-value pairs.
 */

// MARK: - SequentialSearchST:
final class SequentialSearchST<Key: Equatable, Value> {
    final class Node {
        let key: Key
        var value: Value
        var next: Node?

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
            self.next = nil
        }

        init(key: Key, value: Value, next: Node?) {
            self.key = key
            self.value = value
            self.next = next
        }
    }

    // MARK: - Private properties:
    private var root: Node?
    private var n: Int

    // MARK: - Initializers:
    init() {
        root = nil
        n = 0
    }

    init(_ root: Node) {
        self.root = root
        n = 1
    }

    // MARK: - Public API:
    /// Returns the number of key-value pairs in this symbol table.
    /// >: Time: O(1). Space: O(1).
    func size() -> Int {
        return n
    }

    /// Does this symbol table contain the given key?
    /// >: Time: O(1). Space: O(1).
    func isEmpty() -> Bool {
        return n == 0
    }

    /// Does this symbol table contain the given key?
    /// > :Time: O(n). Space: O(1).
    func contains(_ key: Key) -> Bool {
        return getValue(key) != nil
    }

    /// Returns the value associated with the given key.
    /// >: Time: O(n). Space: O(1).
    func getValue(_ key: Key) -> Value? {
        guard !isEmpty() else { return nil }
        var currentNode = root

        while currentNode != nil, currentNode?.key != key {
            currentNode = currentNode?.next
        }
        return currentNode?.value
    }

    /// Inserts the key-value pair into the symbol table, overwriting the old value
    /// with the new value if the key is already in the symbol table.
    /// If the value is NIL, this effectively deletes the key from the symbol table.
    /// >: Time: O(n). Space: O(n).
    func put(key: Key, value: Value?) {
        if value == nil {
            delete(key)
            return
        }

        var currentNode = root

        while currentNode?.next != nil {
            if currentNode?.key == key {
                currentNode?.value = value!
                return
            }
            currentNode = currentNode?.next
        }

        root = .init(key: key, value: value!, next: root)
        n += 1
    }

    /// Removes the key and associated value from the symbol table (if the key is in the symbol table).
    /// >: Time: O(n). Space: O(n).
    func delete(_ key: Key) {
        root = delete(root, key: key)
    }

    // Can do it by using PQ.
    /// Returns all keys in the symbol table
    /// > Time: O(n). Space: O(n).
    func keys() -> [Key] {
        guard !isEmpty() else { return [] }
        var currentNode = root
        var keys: [Key] = []

        while currentNode != nil {
            keys.append(currentNode!.key)
            currentNode = currentNode?.next
        }
        return keys
    }

    // MARK: - Private helpers:
    private func delete(_ node: Node?, key: Key) -> Node? {
        guard node != nil else { return nil }

        if node!.key == key {
            n -= 1
            return node!.next
        }

        node!.next = delete(node!.next, key: key)
        return node
    }
}

let seqSearchSTRoot = SequentialSearchST(.init(key: 1, value: "1"))
seqSearchSTRoot.isEmpty()
seqSearchSTRoot.getValue(2)
seqSearchSTRoot.getValue(1)
seqSearchSTRoot.size()
seqSearchSTRoot.contains(2)
seqSearchSTRoot.contains(1)

seqSearchSTRoot.put(key: 5, value: "5")
seqSearchSTRoot.put(key: 3, value: "3")
seqSearchSTRoot.put(key: 4, value: "4")
seqSearchSTRoot.put(key: 2, value: "2")
seqSearchSTRoot.put(key: 6, value: "6")

seqSearchSTRoot.getValue(4)
seqSearchSTRoot.size()
seqSearchSTRoot.keys()

seqSearchSTRoot.delete(3)
seqSearchSTRoot.keys()



// MARK: - SeparateChainingHashST:
protocol HashingProtocol {
    func hashCode() -> Int32
}

extension Int: HashingProtocol {
    func hashCode() -> Int32 {
        let stack = Array(String(self))
        var hash = 1

        for i in 0..<stack.count {
            hash = 31 * hash + Int(stack[i].asciiValue!)
        }
        return Int32(hash)
    }
}

extension String: HashingProtocol {
    func hashCode() -> Int32 {
        let stack = Array(self)
        var hash = 1

        for i in 0..<stack.count {
            hash = 31 * hash + Int(stack[i].asciiValue!)
        }
        return Int32(hash)
    }
}

// All complexities are according if and only if there under uniform hashing assumption.
// Regarding the n / m (math model) - it's extremely close to the 1.0, which is amazing result.

// Key property is M < N.
final class SeparateChainingHashST<Key: Equatable & HashingProtocol, Value> {

    // MARK: - Private properties:
    private var m: Int // hash table size
    private var n: Int // number of key-value pairs
    private var st: [SequentialSearchST<Key, Value>] // array of linked-list symbol tables

    private let initialCapacity = 4 // initial hash table capacity

    // MARK: - Initializers:
    init() {
        m = initialCapacity
        n = 0
        st = .init(repeating: .init(), count: initialCapacity)

        for i in 0..<m {
            st[i] = .init()
        }
    }

    init(capacity: Int) {
        if capacity < initialCapacity {
            m = initialCapacity
            n = 0
            st = .init(repeating: .init(), count: initialCapacity)

            for i in 0..<m {
                st[i] = .init()
            }
            return
        }

        m = capacity
        n = 0
        st = .init(repeating: .init(), count: m)

        for i in 0..<m {
            st[i] = .init()
        }
    }

    // MARK: - Public API:
    /// Returns the number of key-value pairs in this symbol table.
    /// >: Time: O(1). Space: O(1).
    func size() -> Int {
        return n
    }

    /// Returns true if this symbol table is empty.
    /// >: Time: O(1). Space: O(1).
    func isEmpty() -> Bool {
        return n == 0
    }

    /// Returns true if this symbol table contains the specified key.
    /// >: Time: O(logN). Space: O(1).
    ///
    /// >: Time in average: ~ n / m. Space in average: 1.
    func contains(_ key: Key) -> Bool {
        return getValue(key) != nil
    }

    /// Returns the value associated with the specified key in this symbol table.
    /// >: Time: O(logN). Space: O(1).
    ///
    /// >: Time in average: ~ n / m. Space in average: 1.
    func getValue(_ key: Key) -> Value? {
        let i = hash(key)
        return st[i].getValue(key)
    }

    /// Inserts the specified key-value pair into the symbol table, overwriting the old value with the new value if the symbol table already contains the specified key.
    /// Deletes the specified key (and its associated value) from this symbol table if the specified value is NULL.
    /// >: Time: O(logN). Space: O(logN).
    ///
    /// >: Time in average: ~ n / m. Space in average: n / m.
    func put(key: Key, value: Value?) {
        if value == nil {
            delete(key)
            return
        }

        // double table size if average length of list >= 10 * m
        if n >= 10 * m {
            resize(2 * m)
        }

        let i = hash(key)

        if !st[i].contains(key) {
            n += 1
        }
        st[i].put(key: key, value: value)
    }

    /// Removes the specified key and its associated value from this symbol table (if the key is in this symbol table).
    /// >: Time: O(logN). Space: O(logN).
    ///
    /// >: Time in average: ~ n / m. Space in average: n / m.
    func delete(_ key: Key) {
        let i = hash(key)

        if st[i].contains(key) {
            n -= 1
        }
        st[i].delete(key)

        // halve table size if average length of list <= 2 * m
        if (m > initialCapacity && n <= 2 * m) {
            resize(m / 2)
        }
    }

    // PQ is nice one for this function.
    /// returns keys in symbol table.
    /// >: Time: O(n + m). Space: O(n + m).
    func keys() -> [Key] {
        var res: [Key] = []

        for i in 0..<m {
            print("i: \(i), keys: \(st[i].keys())")
            res.append(contentsOf: st[i].keys())
        }
        return res
    }

    // MARK: - Private helpers:
    /// hash function for keys - returns value between 0 and m-1 (assumes m is a power of 2).
    private func hash(_ key: Key) -> Int {
        var h = key.hashCode() // Due to Swift generic swift restricions - we should implement polymorphic functions.
        h ^= (h >> 20) ^ (h >> 12) ^ (h >> 7) ^ (h >> 4) // as a standard from R.Sedgewick.
        return Int(h) & (m - 1)
    }

    // We can use this hash computation instead of above one.
    /// hash function for keys - returns value between 0 and m-1
    private func hashTextBook(_ key: Key) -> Int {
        return (Int(key.hashCode()) & 0x7fffffff) % m
    }

    /// resize the hash table to have the given number of chains, rehashing all of the keys.
    /// >: Time: O(n + m). Space: O(n + m).
    private func resize(_ capacity: Int) {
        guard capacity > initialCapacity else { return }
        let temp = SeparateChainingHashST(capacity: capacity)

        for i in 0..<m {
            for key in st[i].keys() {
                temp.put(key: key, value: st[i].getValue(key))
            }
        }
        m = temp.m
        n = temp.n
        st = temp.st
    }
}

let separateChainingHashST = SeparateChainingHashST<Int, String>()
separateChainingHashST.isEmpty()
separateChainingHashST.size()
separateChainingHashST.keys()

separateChainingHashST.put(key: 1, value: "1")
separateChainingHashST.put(key: 3, value: "3")
separateChainingHashST.put(key: 5, value: "5")
separateChainingHashST.put(key: 2, value: "2")
separateChainingHashST.put(key: 4, value: "4")
separateChainingHashST.put(key: 10, value: "10")
separateChainingHashST.size()
separateChainingHashST.keys()


separateChainingHashST.put(key: 10, value: "12")
separateChainingHashST.getValue(10)
separateChainingHashST.size()
separateChainingHashST.keys()

separateChainingHashST.getValue(7)
separateChainingHashST.getValue(3)

separateChainingHashST.delete(10)
separateChainingHashST.contains(10)

separateChainingHashST.put(key: 2, value: nil)
separateChainingHashST.keys()


// ________________________________________________
1.hashCode() // 01010000
private func hashTest(_ key: Int) -> Int {
    var h = key.hashCode()
    h ^= (h >> 20) ^ (h >> 12) ^ (h >> 7) ^ (h >> 4)
    return Int(h) & (4 - 1)
}
hashTest(1)

// Hash shifting logic.
/*
 01010000
 >> 20
 00000000

 01010000
 >> 12
 00000000

 01010000
 >> 7
 00000000

 01010000
 >> 4
 00000101

 01010000
 ^=
 00000101

 = 01010101

 01010101
 &
 00000011

 = 00000001
 */

// __________________________________________




                                    // MARK: - Hashing with linear probing:
/*
 A symbol table implemented with a linear probing hash function.

 Symbol table implementation with open addressing approach for resolving collision in arrays of key-value pairs.
 */

// MARK: - LinearProbingHashST:
// Key property is M > N.
final class LinearProbingHashST<Key: Equatable & HashingProtocol, Value: Equatable> {

    // MARK: - Private properties:
    private var m: Int // hash table size
    private var n: Int // number of key-value pairs in ST
    private var keys: [Key?]
    private var values: [Value?]

    private let initialCapacity = 4 // must a power of two

    // MARK: - Initializers:
    init() {
        m = initialCapacity
        n = 0
        keys = .init(repeating: nil, count: m)
        values = .init(repeating: nil, count: m)
    }

    init(capacity: Int) {
        if capacity < initialCapacity {
            m = initialCapacity
            n = 0
            keys = .init(repeating: nil, count: m)
            values = .init(repeating: nil, count: m)
            return
        }

        m = capacity
        n = 0
        keys = .init(repeating: nil, count: m)
        values = .init(repeating: nil, count: m)
    }

    // MARK: - Public API:
    /// Returns the number of key-value pairs in this symbol table.
    /// >: Time: O(1). Space: O(1).
    func size() -> Int {
        return n
    }

    /// Returns true if this symbol table is empty.
    /// >: Time: O(1). Space: O(1).
    func isEmpty() -> Bool {
        return n == 0
    }

    /// Returns true if this symbol table contains the specified key.
    /// >: Time: O(logN). Space: O(1).
    ///
    /// >: Time in average: ~ n / m. Space in average: 1.
    func contains(_ key: Key) -> Bool {
        return getValue(key) != nil
    }

    /// Returns the value associated with the specified key in this symbol table.
    /// >: Time: O(logN). Space: O(1).
    ///
    /// >: Time in average: ~ n / m. Space in average: 1.
    func getValue(_ key: Key) -> Value? {
        var i = hash(key)

        while keys[i] != nil, keys[i] != key {
            i = (i + 1) % m // when we are reached out the ends of array we wrap our idx to beggining of array by using remainder.
            // 4 % 24 = 4
            // 27 % 24 = 3
        }
        return values[i]
    }

    /// Inserts the specified key-value pair into the symbol table, overwriting the old value with the new value if the symbol table already contains the specified key.
    /// Deletes the specified key (and its associated value) from this symbol table if the specified value is NULL.
    /// >: Time: O(logN). Space: O(logN).
    ///
    /// >: Time in average: ~ n / m. Space in average: n / m.
    func put(key: Key, value: Value?) {
        if value == nil {
            delete(key)
            return
        }

        // double table size if 50% full
        if n >= m / 2 {
            resize(m * 2)
        }

        var i = hash(key)

        while keys[i] != nil {
            if keys[i] == key {
                values[i] = value
                return
            }
            i = (i + 1) % m
        }

        keys[i] = key
        values[i] = value
        n += 1
    }

    /// Removes the specified key and its associated value from this symbol table (if the key is in this symbol table).
    /// >: Time: O(logN). Space: O(logN).
    ///
    /// >: Time in average: ~ n / m. Space in average: n / m.
    func delete(_ key: Key) {
        guard contains(key) else { return }
        // find idx of key
        var i = hash(key)

        // look up of key
        while keys[i] != key {
            i = (i + 1) % m
        }

        // remove key-value pair from ST
        keys[i] = nil
        values[i] = nil

        // go to the next idx to right of deleted key in current cluster
        i = (i + 1) % m

        // rehash all keys in the same cluster
        while keys[i] != nil {
            let rehashKey = keys[i]!
            let rehashVal = values[i]

            keys[i] = nil
            values[i] = nil
            n -= 1

            put(key: rehashKey, value: rehashVal)
            i = (i + 1) % m
        }

        n -= 1

        // halves size of array if it's 12.5% full or less
        if n > 0, n <= m / 8 {
            resize(m / 2)
        }

        assert(check())
    }

    // PQ is nice one for this function.
    /// returns keys in symbol table.
    /// >: Time: O(n + m). Space: O(n + m).
    func allKeys() -> [Key] {
        var res: [Key] = []

        for i in 0..<m where keys[i] != nil {
            res.append(keys[i]!)
        }
        print("all keys \n", res)
        return res
    }

    // MARK: - Private helpers:
    /// hash function for keys - returns value between 0 and m-1 (assumes m is a power of 2).
    private func hash(_ key: Key) -> Int {
        var h = key.hashCode() // Due to Swift generic swift restricions - we should implement polymorphic functions.
        h ^= (h >> 20) ^ (h >> 12) ^ (h >> 7) ^ (h >> 4) // as a standard from R.Sedgewick book.
        return Int(h) & (m - 1)
    }

    // We can use this hash computation instead of above one.
    /// hash function for keys - returns value between 0 and m - 1.
    private func hashTextBook(_ key: Key) -> Int {
        return (Int(key.hashCode()) & 0x7fffffff) % m
    }

    /// Resizes the hash table to the given capacity by re-hashing all of the keys.
    /// >: Time: O(m). Space: O(m).
    private func resize(_ capacity: Int) {
        guard capacity > initialCapacity else { return }
        let temp = LinearProbingHashST(capacity: capacity)

        for i in 0..<m where keys[i] != nil {
            temp.put(key: keys[i]!, value: values[i])
        }

        m = temp.m
        keys = temp.keys
        values = temp.values
    }

    // MARK: - Checkers (NOT FOR PROD):
    // integrity check - don't check after each put() because integrity not maintained during a call to delete()
    private func check() -> Bool {
        // check that hash table is at most 50% full
        if m < n * 2 {
            print("Hash table size is occupied on more than 50%. \n m size: \(m). \n n size: \(n)")
            return false
        }

        // check that each key in table can be found by get()
        for i in 0..<m where keys[i] != nil && getValue(keys[i]!) != values[i] {
            print("For the idx: \(i) there should be the same value in values and getValue().")
            return false
        }
        return true
    }
}

let linearProbingHashST = LinearProbingHashST<Int, String>(capacity: 1)
linearProbingHashST.size()
linearProbingHashST.getValue(10)
linearProbingHashST.allKeys()
linearProbingHashST.isEmpty()
linearProbingHashST.contains(5)
linearProbingHashST.delete(3)

linearProbingHashST.put(key: 1, value: "1")
linearProbingHashST.put(key: 2, value: "2")
linearProbingHashST.put(key: 3, value: "3")
linearProbingHashST.put(key: 4, value: "4")
linearProbingHashST.put(key: 5, value: "5")
linearProbingHashST.put(key: 6, value: "6")
linearProbingHashST.put(key: 7, value: "7")
linearProbingHashST.put(key: 8, value: "8")
linearProbingHashST.put(key: 9, value: "9")
linearProbingHashST.put(key: 10, value: "10")

linearProbingHashST.size()
linearProbingHashST.allKeys()

linearProbingHashST.contains(12)
linearProbingHashST.contains(3)
linearProbingHashST.getValue(5)

linearProbingHashST.delete(5)
linearProbingHashST.contains(5)
linearProbingHashST.size()
linearProbingHashST.allKeys()
