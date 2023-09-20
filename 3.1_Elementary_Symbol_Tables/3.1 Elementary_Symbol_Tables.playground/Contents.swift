import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



                            // MARK: - Symbol Table. (as known as `Dictionary` type in Swift):

// MARK: - Unordered ST via arrays:
public final class UnorderedST<Key: Comparable, Value> {
    private var keys: [Key?]
    private var values: [Value?]
    private var n: Int

    // Public API:
    public init(capacity: Int) {
        keys = .init(repeating: nil, count: capacity)
        values = .init(repeating: nil, count: capacity)
        n = 0
    }

    // Time is ~ linear.
    // Time in the best case is constant.
    public func put(key: Key, value: Value?) {
        if value == nil {
            delete(key)
            return
        }

        if containsKey(key) {
            let idx = getKeyIndex(key)!
            values[idx] = value
            return
        }

        keys[n] = key
        values[n] = value
        n += 1

        if n == keys.count {
            resize(keys.count * 2)
        }
    }

    // Time is ~ linear.
    public func getValue(_ key: Key) -> Value? {
        guard let idx = getKeyIndex(key) else { return nil }
        return values[idx]
    }

    // Time is ~ linear.
    public func delete(_ key: Key) {
        guard let idx = getKeyIndex(key) else { return }
        n -= 1
        exchange(idx, n)
        keys[n] = nil
        values[n] = nil

        guard n == (keys.count - 1) / 4 else { return }
        resize(keys.count / 2)
    }

    public func containsKey(_ key: Key) -> Bool {
        return getValue(key) != nil
    }

    public func isEmpty() -> Bool {
        return n == 0
    }

    public func size() -> Int {
        return n
    }

    public func allKeys() -> [Key] {
        return keys[0 ..< n].compactMap { $0 }
    }

    // Private helpers:
    private func getKeyIndex(_ key: Key) -> Int? {
        for i in 0 ..< keys.count where keys[i] == key {
            return i
        }
        return nil
    }

    private func resize(_ capacity: Int) {
        guard capacity > n else { return }
        var tempKeys: [Key?] = .init(repeating: nil, count: capacity)
        var tempValues: [Value?] = .init(repeating: nil, count: capacity)

        for i in 0 ..< n {
            tempKeys[i] = keys[i]
            tempValues[i] = values[i]
        }
        keys = tempKeys
        values = tempValues
    }

    private func exchange(_ i: Int, _ j: Int) {
        let keysSwap = keys[i]
        let valuesSwap = values[i]
        keys[i] = keys[j]
        keys[j] = keysSwap
        values[i] = values[j]
        values[j] = valuesSwap
    }
}

let unorderedST = UnorderedST<String, Int>(capacity: 1)
unorderedST.getValue("hello")
unorderedST.put(key: "hello", value: 1)
unorderedST.getValue("hello")
unorderedST.allKeys()
unorderedST.containsKey("hello")
unorderedST.size()

unorderedST.delete("hello")
unorderedST.getValue("hello")
unorderedST.size()
unorderedST.allKeys()
unorderedST.containsKey("hello")

unorderedST.put(key: "hello", value: 1)
unorderedST.getValue("hello")
unorderedST.allKeys()
unorderedST.containsKey("hello")
unorderedST.size()

unorderedST.put(key: "hi", value: 3)
unorderedST.getValue("hi")
unorderedST.allKeys()
unorderedST.containsKey("hi")
unorderedST.size()

unorderedST.put(key: "bye", value: 5)
unorderedST.getValue("bye")
unorderedST.allKeys()
unorderedST.containsKey("bye")
unorderedST.size()

unorderedST.delete("hi")
unorderedST.getValue("hi")
unorderedST.size()
unorderedST.allKeys()
unorderedST.containsKey("hi")





// MARK: - Unordered Sequential search ST via linked list:
public final class SequentialSearchST<Key: Comparable, Value> {
    private final class Node {
        let key: Key
        var value: Value?
        var next: Node?

        public init(key: Key, value: Value?, next: Node?) {
            self.key = key
            self.value = value
            self.next = next
        }
    }

    private var first: Node?
    private var n: Int

    public init() {
        first = nil
        n = 0
    }

    // Public API:
    public func size() -> Int {
        return n
    }

    public func isEmpty() -> Bool {
        return n == 0
    }

    // Time complexity is ~ linear.
    public func containsKey(_ key: Key) -> Bool {
        return getValue(key) != nil
    }

    // Time is ~ linear.
    public func getValue(_ key: Key) -> Value? {
        return node(with: key)?.value
    }

    // Time is ~ linear.
    public func put(key: Key, value: Value?) {
        if value == nil {
            delete(key)
            return
        }

        if let node = node(with: key) {
            node.value = value
            return
        }

        let newNode = Node(key: key, value: value, next: first)
        first = newNode
        n += 1
    }

    // Time is ~ linear.
    public func delete(_ key: Key) {
        guard containsKey(key) else { return }
        first = delete(from: first, key: key)
    }

    // Private helpers:
    private func node(with key: Key) -> Node? {
        var currentNode = first

        while currentNode != nil {
            if currentNode?.key == key {
                return currentNode
            }
            currentNode = currentNode?.next
        }
        return nil
    }

    private func delete(from node: Node?, key: Key) -> Node? {
        guard node != nil else { return nil }

        if node?.key == key {
            n -= 1
            return node?.next
        }

        node?.next = delete(from: node?.next, key: key)
        return node
    }
}

let sequentialSearchST = SequentialSearchST<Int, String>()
sequentialSearchST.put(key: 1, value: "One")
sequentialSearchST.put(key: 2, value: "Two")
sequentialSearchST.put(key: 3, value: "Three")
sequentialSearchST.put(key: 4, value: "Four")
sequentialSearchST.put(key: 5, value: "Five")
sequentialSearchST.put(key: 6, value: "Six")
sequentialSearchST.put(key: 7, value: "Seven")
sequentialSearchST.put(key: 8, value: "Eight")
sequentialSearchST.put(key: 9, value: "Nine")
sequentialSearchST.put(key: 10, value: "Ten")
sequentialSearchST.size()

sequentialSearchST.containsKey(5)
sequentialSearchST.getValue(5)

sequentialSearchST.delete(5)
sequentialSearchST.size()
sequentialSearchST.put(key: 10, value: nil)
sequentialSearchST.containsKey(10)
sequentialSearchST.size()

sequentialSearchST.getValue(9)
sequentialSearchST.put(key: 9, value: "Nineteenth")
sequentialSearchST.getValue(9)





// MARK: - Ordered Binary search ST via arrays:
public final class BinarySearchST<Key: Comparable, Value> {
    private var keys: [Key?]
    private var vals: [Value?]
    private var n: Int

    public init(capacity: Int) {
        keys = .init(repeating: nil, count: capacity)
        vals = .init(repeating: nil, count: capacity)
        n = 0
    }

    // Public API:
    public func size() -> Int {
        return n
    }

    public func isEmpty() -> Bool {
        return n == 0
    }

    public func containsKey(_ key: Key) -> Bool {
        return getValue(key) != nil
    }

    public func getValue(_ key: Key) -> Value? {
        guard !isEmpty() else { return nil }
        let i = rank(key)

        if i < n, keys[i] == key {
            return vals[i]
        }
        return nil
    }

    // Time is ~ logarithmic.
    public func rank(_ key: Key) -> Int {
        var low = 0
        var high = n - 1

        while low <= high {
            let mid = low + (high - low) / 2

            if key == keys[mid] {
                return mid
            } else if key > keys[mid]! {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        return low
    }

    // Time in the worst case is ~ 2N.
    public func put(key: Key, val: Value?) {
        if val == nil {
            delete(key)
            return
        }

        let i = rank(key)

        if i < n, keys[i] == key {
            vals[i] = val
            return
        }

        if i < n {
            for j in (i + 1 ... n).reversed() {
                keys[j] = keys[j - 1]
                vals[j] = vals[j - 1]
            }
        }

        keys[i] = key
        vals[i] = val
        n += 1

        if n == keys.count {
            resize(keys.count * 2)
        }

        // Not for PROD.
        rankCheck()
    }

    // Time average is ~ linear.
    public func delete(_ key: Key) {
        guard !isEmpty(), containsKey(key) else { return }
        let i = rank(key)
        guard i < n else { return }

        if i < n - 1 {
            for j in i ..< n - 1 {
                keys[j] = keys[j + 1]
                vals[j] = vals[j + 1]
            }
        }

        n -= 1
        keys[n] = nil
        vals[n] = nil

        if n > 0, n == (keys.count - 1) / 4 {
            resize(keys.count / 2)
        }

        // Not for PROD.
        rankCheck()
    }

    public func deleteMax() {
        delete(max())
    }

    public func deleteMin() {
        delete(min())
    }

    public func min() -> Key {
        return keys[0]!
    }

    public func max() -> Key {
        return keys[n - 1]!
    }

    public func select(_ i: Int) -> Key? {
        return i >= 0 && i < n ? keys[i] : nil
    }

    // Time is ~ logarithimc.
    public func floor(_ key: Key) -> Key? {
        guard !isEmpty() else { return nil }
        let i = rank(key)
        guard i > 0 else { return nil }
        return keys[i] == key ? keys[i] : keys[i - 1]
    }

    // Time is ~ logarithimc.
    public func ceiling(_ key: Key) -> Key? {
        guard !isEmpty() else { return nil }
        let i = rank(key)
        guard i > 0, i < n else { return nil }
        return keys[i]
    }

    // Time is ~ 2logN.
    public func size(low: Key, high: Key) -> Int {
        guard !isEmpty(), low <= high else { return 0 }

        if containsKey(high) {
            return rank(high) - rank(low) + 1
        } else {
            return rank(high) - rank(low)
        }
    }

    // Time is ~ linearithmic.
    public func allKeys() -> [Key] {
        guard !isEmpty() else { return [] }
        return keys(low: min(), high: max())
    }

    // Time is ~ linearithmic.
    public func keys(low: Key, high: Key) -> [Key] {
        guard !isEmpty(), low <= high else { return [] }
        let i = rank(low)
        let j = rank(high)

        // Best point in that there is we can work with PQ.
        if containsKey(high) {
            return keys[i ... j].compactMap { $0 }
        } else {
            return keys[i ..< j].compactMap { $0 }
        }
    }

    // Private helpers:
    private func resize(_ capacity: Int) {
        guard capacity > n else { return }
        var tempK: [Key?] = .init(repeating: nil, count: capacity)
        var tempV: [Value?] = .init(repeating: nil, count: capacity)

        for i in 0 ..< n {
            tempK[i] = keys[i]
            tempV[i] = vals[i]
        }
        keys = tempK
        vals = tempV
    }

    // Internal checking (Not for PROD):
    private func check() -> Bool {
        return isSorted() && rankCheck()
    }

    private func isSorted() -> Bool {
        for i in 1 ..< n where keys[i]! < keys[i - 1]! {
            print("isSorted = false")
            return false
        }
        print("isSorted = true")
        return true
    }

    private func rankCheck() -> Bool {
        for i in 0 ..< n where i != rank(select(i)!) {
            print("rankCheck #1 = false")
            return false
        }

        for i in 0 ..< n where keys[i] != select(rank(keys[i]!)) {
            print("rankCheck #2 = false")
            return false
        }

        print("rankCheck = true")
        return true
    }
}

let binarySearchST = BinarySearchST<Int, String>(capacity: 1)
binarySearchST.put(key: 1, val: "One")
binarySearchST.put(key: 2, val: "Two")
binarySearchST.put(key: 3, val: "Three")
binarySearchST.put(key: 4, val: "Four")
binarySearchST.put(key: 5, val: "Five")
binarySearchST.put(key: 6, val: "Six")
binarySearchST.put(key: 7, val: "Seven")
binarySearchST.put(key: 8, val: "Eight")
binarySearchST.put(key: 9, val: "Nine")
binarySearchST.put(key: 10, val: "Ten")

binarySearchST.size()
binarySearchST.allKeys()
binarySearchST.min()
binarySearchST.max()

binarySearchST.keys(low: 7, high: 12)
binarySearchST.size(low: 7, high: 10)

binarySearchST.floor(11)
binarySearchST.ceiling(11)
binarySearchST.rank(6)

binarySearchST.deleteMin()
binarySearchST.deleteMax()
binarySearchST.allKeys()
binarySearchST.size()
binarySearchST.getValue(9)

binarySearchST.put(key: 9, val: nil)
binarySearchST.containsKey(9)
binarySearchST.put(key: 20, val: "Twenty")
binarySearchST.put(key: 15, val: "Fifteenth")
binarySearchST.allKeys()
binarySearchST.size()

binarySearchST.delete(9)
binarySearchST.allKeys()
binarySearchST.size()

binarySearchST.delete(8)
binarySearchST.allKeys()
binarySearchST.size()

binarySearchST.rank(9)
binarySearchST.rank(15)
binarySearchST.rank(3)
binarySearchST.select(1)
