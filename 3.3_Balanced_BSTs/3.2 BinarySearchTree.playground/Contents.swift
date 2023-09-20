import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true




                                            // MARK: - BinarySearchTree (BST):

/// The BST is used as one of the various implementations of "Symbol Table".
/// Almost all operations are logN if and only if keys were inserted in random order.
/// If keys were added in order or travserse order then running time is linear.
public final class BST<Key: Comparable, Value> {
    // MARK: - Node:

    final class Node {
        let key: Key
        var value: Value
        var left: Node?
        var right: Node?
        var size: Int

        public init(key: Key, value: Value, size: Int) {
            self.key = key
            self.value = value
            self.size = size
        }
    }

    private var root: Node?

    public init() {
        root = nil
    }

    init(_ root: Node) {
        self.root = root
    }

    // MARK: - Public API:
    // Time ~ constant.
    public func isEmpty() -> Bool {
        return size() == 0
    }

    // Time ~ constant.
    public func size() -> Int {
        return size(root)
    }

    // Time ~ logarithmic.
    public func contains(_ key: Key) -> Bool {
        getValue(key) != nil
    }

    // Time ~ logarithmic.
    public func getValue(_ key: Key) -> Value? {
        return getValue(root, key)
    }

    // Time ~ 2LogN.
    public func put(key: Key, value: Value?) {
        if value == nil {
            delete(key)
            return
        }

        root = put(root, key, value)

        //
        check()
        //
    }

    // Time ~ logarithmic.
    public func deleteMin() {
        guard !isEmpty() else { return }
        root = deleteMin(root)

        //
        check()
        //
    }

    // Time ~ logarithmic.
    public func deleteMax() {
        guard !isEmpty() else { return }
        root = deleteMax(root)

        //
        check()
        //
    }

    // Time ~ Sqrt(N).
    public func delete(_ key: Key) {
        root = delete(root, key)

        //
        check()
        //
    }

    // Time ~ logarithmic.
    public func minKey() -> Key? {
        return minKey(root)?.key
    }

    // Time ~ logarithmic.
    public func maxKey() -> Key? {
        return maxKey(root)?.key
    }

    /// First approach.
    // Time ~ logarithmic.
    public func floor(_ key: Key) -> Key? {
        return floor(root, key)?.key
    }

    /// Second approach.
    // Time ~ logarithmic.
    public func floor2(_ key: Key) -> Key? {
        return floor2(root, key, nil)
    }

    // Time ~ logarithmic.
    public func ceiling(_ key: Key) -> Key? {
        return ceiling(root, key)?.key
    }

    // Time ~ logarithmic.
    public func select(_ i: Int) -> Key? {
        return i >= 0 && i < size() ? select(root, i) : nil
    }

    /// Return the number of keys in the symbol table strictly less than given key.
    // Time ~ logarithmic.
    public func rank(_ key: Key) -> Int {
        return rank(root, key)
    }

    // Time ~ logarithmic.
    public func keys() -> [Key] {
        guard !isEmpty() else { return [] }
        return keys(low: minKey()!, high: maxKey()!)
    }

    /// We have great opportinity use it via PQ.
    // Time ~ logarithmic. Time in the worst case is linear.
    public func keys(low: Key, high: Key) -> [Key] {
        var allKeys: [Key] = []
        keys(root, in: &allKeys, low: low, high: high)
        return allKeys
    }

    // Time ~ 2LogN.
    public func size(low: Key, high: Key) -> Int {
        guard !isEmpty(), low <= high else { return 0 }

        if contains(high) {
            return rank(high) - rank(low) + 1
        } else {
            return rank(high) - rank(low)
        }
    }

    /// Returns the height of the BST (for debugging).
    /// return the height of the BST (a 1-node tree has height 0).
    // Time ~ linear
    public func height() -> Int {
        return height(root)
    }

    /// We have great opportinity use it via PQ.
    // Time ~ linear.
    public func levelOrder() -> [Key] {
        var allKeys: [Key] = []
        var nodes: [Node?] = [root]

        while !nodes.isEmpty {
            guard let tempNode = nodes.removeLast() else { continue }
            allKeys.append(tempNode.key)
            nodes.append(tempNode.left)
            nodes.append(tempNode.right)
        }
        return allKeys
    }

    // MARK: - Private helpers:
    // Number of pairs rooted at node.
    private func size(_ node: Node?) -> Int {
        return node?.size ?? 0
    }

    private func getValue(_ node: Node?, _ key: Key) -> Value? {
        guard let node = node else { return nil }

        if node.key == key {
            return node.value
        } else if key > node.key {
            return getValue(node.right, key)
        } else {
            return getValue(node.left, key)
        }
    }

    private func put(_ node: Node?, _ key: Key, _ value: Value?) -> Node {
        guard let node = node else { return Node(key: key, value: value!, size: 1) }

        if key == node.key {
            node.value = value!
        } else if key > node.key {
            node.right = put(node.right, key, value)
        } else {
            node.left = put(node.left, key, value)
        }

        node.size = 1 + size(node.left) + size(node.right)
        return node
    }

    private func deleteMin(_ node: Node?) -> Node? {
        guard node?.left != nil else { return node?.right }
        node?.left = deleteMin(node?.left)
        node?.size = 1 + size(node?.right) + size(node?.left)
        return node
    }

    private func deleteMax(_ node: Node?) -> Node? {
        guard node?.right != nil else { return node?.left }
        node?.right = deleteMax(node?.right)
        node?.size = 1 + size(node?.left) + size(node?.right)
        return node
    }

    private func delete(_ node: Node?, _ key: Key) -> Node? {
        guard var node = node else { return nil }

        if key > node.key {
            node.right = delete(node.right, key)
        } else if key < node.key {
            node.left = delete(node.left, key)
        } else {
            if node.left == nil {
                return node.right
            } else if node.right == nil {
                return node.left
            }

            let tempNode = node
            node = minKey(tempNode.right)!
            node.right = deleteMin(tempNode.right)
            node.left = tempNode.left
        }
        node.size = 1 + size(node.left) + size(node.right)
        return node
    }

    private func minKey(_ node: Node?) -> Node? {
        guard node?.left != nil else { return node }
        return minKey(node?.left)
    }

    private func maxKey(_ node: Node?) -> Node? {
        guard node?.right != nil else { return node }
        return maxKey(node?.right)
    }

    /// the largest key in the subtree rooted at x less than or equal to the given key
    private func floor(_ node: Node?, _ key: Key) -> Node? {
        guard let node = node else { return nil }

        if key == node.key {
            return node
        } else if key < node.key {
            return floor(node.left, key)
        } else {
            let tempNode = floor(node.right, key)
            return tempNode ?? node
        }
    }

    private func floor2(_ node: Node?, _ key: Key, _ bestKey: Key?) -> Key? {
        guard let node = node else { return bestKey }

        if key == node.key {
            return key
        } else if key > node.key {
            return floor2(node.right, key, node.key)
        } else {
            return floor2(node.left, key, bestKey)
        }
    }

    private func ceiling(_ node: Node?, _ key: Key) -> Node? {
        guard let node = node else { return nil }

        if key == node.key {
            return node
        } else if key > node.key {
            return ceiling(node.right, key)
        } else {
            let tempNode = ceiling(node.left, key)
            return tempNode ?? node
        }
    }

    private func select(_ node: Node?, _ i: Int) -> Key? {
        guard let node = node else { return nil }
        let leftSize = size(node.left)

        if leftSize == i {
            return node.key
        } else if leftSize > i {
            return select(node.left, i)
        } else {
            return select(node.right, i - leftSize - 1)
        }
    }

    private func rank(_ node: Node?, _ key: Key) -> Int {
        guard let node = node else { return 0 }

        if key == node.key {
            return size(node.left)
        } else if key > node.key {
            return 1 + size(node.left) + rank(node.right, key)
        } else {
            return rank(node.left, key)
        }
    }

    private func keys(_ node: Node?, in allKeys: inout [Key], low: Key, high: Key) {
        guard let node = node else { return }

        if low < node.key {
            keys(node.left, in: &allKeys, low: low, high: high)
        }

        if low <= node.key && high >= node.key {
            allKeys.append(node.key)
        }

        if high > node.key {
            keys(node.right, in: &allKeys, low: low, high: high)
        }
    }

    private func height(_ node: Node?) -> Int {
        guard node != nil else { return -1 }
        return 1 + max(height(node?.left), height(node?.right))
    }

    // Check integrity of BST data structure (Not for PROD).
    private func check() -> Bool {
        if !isBST() {
            print("Not in symmetric order")
        }

        if !isSizeConsistent() {
            print("Subtree counts not consistent")
        }

        if !isRankConsistent() {
            print("Ranks not consistent")
        }

        return isBST() && isSizeConsistent() && isRankConsistent()
    }

    private func isBST() -> Bool {
        return isBST(root, nil, nil)
    }

    private func isBST(_ node: Node?, _ min: Key?, _ max: Key?) -> Bool {
        guard let node = node else { return true }

        if min != nil, node.key <= min! {
            return false
        }

        if max != nil, node.key >= max! {
            return false
        }

        return isBST(node.left, min, node.key) && isBST(node.right, node.key, max)
    }

    private func isSizeConsistent() -> Bool {
        return isSizeConsistent(root)
    }

    private func isSizeConsistent(_ node: Node?) -> Bool {
        guard let node = node else { return true }

        if size(node) != size(node.left) + 1 + size(node.right) {
            return false
        }
        return isSizeConsistent(node.left) && isSizeConsistent(node.right)
    }

    private func isRankConsistent() -> Bool {
        for i in 0 ..< size() where i != rank(select(i)!) {
            return false
        }

        for key in keys() where key != select(rank(key)) {
            return false
        }

        return true
    }

    // MARK: - Non recursive methods: Put(), Get(), keys():
    func putNonRecursive(_ key: Key, _ value: Value) {
        let newNode = Node(key: key, value: value, size: 1)
        var parent: Node?
        var x = root

        if x == nil {
            x = newNode
            return
        }

        while x != nil {
            parent = x

            if key == x!.key {
                x!.value = value
            } else if key > x!.key {
                x = x?.right
            } else {
                x = x?.left
            }
        }

        if key > parent!.key {
            parent?.right = newNode
        } else {
            parent?.left = newNode
        }
    }

    func getValueNonRecursive(_ key: Key) -> Value? {
        var currentNode = root

        while currentNode != nil {
            if key < currentNode!.key {
                currentNode = currentNode?.left
            } else if key > currentNode!.key {
                currentNode = currentNode?.right
            } else {
                return currentNode?.value
            }
        }
        return nil
    }

    func keysNonRecursive() -> [Key] {
        var stack: [Node?] = []
        var keys: [Key] = []
        var currentNode = root

        while currentNode != nil || !stack.isEmpty {
            if currentNode != nil {
                stack.append(currentNode)
                currentNode = currentNode?.left
            } else {
                currentNode = stack.removeLast()
                keys.append(currentNode!.key)
                currentNode = currentNode?.right
            }
        }
        return keys
    }
}

let bst = BST<Int, String>()
bst.put(key: 5, value: "five")
bst.put(key: 2, value: "two")
bst.put(key: 12, value: "twelve")
bst.put(key: 1, value: "one")
bst.put(key: 3, value: "three")
bst.put(key: 9, value: "nine")
bst.put(key: 21, value: "twenty one")
bst.put(key: 19, value: "ninetheen")
bst.put(key: 25, value: "twenty five")

bst.isEmpty()
bst.getValue(19)
bst.floor(20)
bst.floor2(20)
bst.ceiling(24)

bst.keys(low: 0, high: 2)
bst.keys()

bst.size(low: 8, high: 10)
bst.size(low: 8, high: 12)

bst.height()
bst.levelOrder()

bst.contains(25)
bst.contains(20)

bst.put(key: 5, value: nil)
bst.keys()
bst.levelOrder()
bst.deleteMax()
bst.keys()
bst.delete(1)
bst.keys()
bst.levelOrder()

// Non recursive checking:
bst.putNonRecursive(22, "Twenty two")
bst.levelOrder()
bst.getValueNonRecursive(22)
bst.keysNonRecursive()





// MARK: -  Method for In-order traversal of a BST in ascending order.
// The best case to use there the PQ.
func allKeysInAscendingOrder(_ node: BST<Int, String>.Node?) -> [Int] {
    guard let node = node else { return [] }
    return allKeysInAscendingOrder(node.left) + [node.key] + allKeysInAscendingOrder(node.right)
}

/// Make `root` property the public.
// allKeysInAscendingOrder(bst.root)




// MARK: -  Method for Breadth First Traversal (Search) in a BST.
// The best case to use there the PQ.
func breadthFirstTraversal(_ node: BST<Int, String>.Node?) -> [Int] {
    var keys: [Int] = []
    var nodes = [node]

    while !nodes.isEmpty {
        guard let temp = nodes.removeFirst() else { continue }
        keys.append(temp.key)
        nodes.append(temp.left)
        nodes.append(temp.right)
    }
    return keys
}

/// Make `root` property the public.
// breadthFirstTraversal(bst.root)





// MARK: - When need to add array into BST:
public enum PerfectBalance {
    static func perfect<Key: Comparable, Value>(in bst: BST<Key, Value>, keys: [Key]) {
        // Here we can sort by using our logic
        // Or we just can use PQ
        let keys = keys.sorted(by: <)
        perfect(in: bst, keys: keys, low: 0, high: keys.count - 1)
    }

    static func perfect<Key: Comparable, Value>(in bst: BST<Key, Value>, keys: [Key], low: Int, high: Int) {
        guard low <= high else { return }
        let median = low + (high - low) / 2
        bst.put(key: keys[median], value: "\(keys[median])" as? Value)
        perfect(in: bst, keys: keys, low: 0, high: median - 1)
        perfect(in: bst, keys: keys, low: median + 1, high: high)
    }
}

// PerfectBalance.perfect(in: bst, keys: [25, 6, 15])
// bst.keys()
// bst.getValue(25)




// MARK: - The great tree-list recursion doubly problem:
typealias Node = BST<Int, String>.Node

func fromBSTtoLinkedList(_ node: Node?) -> Node? {
    guard let node = node else { return nil }

    /// Recursively convert left and right subtrees
    let left = fromBSTtoLinkedList(node.left)
    let right = fromBSTtoLinkedList(node.right)

    /// Make a circular linked list of single node
    node.left = node
    node.right = node

    return concatenate(left: concatenate(left: left, right: node), right: right)
}

func concatenate(left: Node?, right: Node?) -> Node? {
    if left == nil {
        return right
    } else if right == nil {
        return left
    }

    /// Store the last Node of left List and right list
    let leftLastNode = left?.left
    let rightLastNode = right?.left

    /// Connect the last node of Left List with the first Node of the right List
    leftLastNode?.right = right
    right?.left = leftLastNode

    /// Left of first node refers to the last node in the right list
    left?.left = rightLastNode
    /// Right of last node refers to the first node of the left List
    rightLastNode?.right = left

    /// Return the Head of the List
    return left
}

private func printLinkedList(_ head: Node?) -> [Int?] {
    var keys: [Int?] = [head?.key]
    var currentNode = head?.right

    while currentNode !== head {
        keys.append(currentNode?.key)
        currentNode = currentNode?.right
    }
    return keys
}

let root = Node(key: 10, value: "Ten", size: 0)
root.left = Node(key: 12, value: "Twelve", size: 0)
root.right = Node(key: 15, value: "Fifteenth", size: 0)
root.left?.left = Node(key: 25, value: "Twenty five", size: 0)
root.left?.right = Node(key: 30, value: "Thirthty", size: 0)
root.right?.left = Node(key: 36, value: "Thirthty six", size: 0)

// let head = fromBSTtoLinkedList(root)
// printLinkedList(head)





// MARK: - Traverse BST:
func traverse(_ node: Node?) {
    guard let node = node else { return }
    traverse(node.left)
    traverse(node.right)
    exchangeChildren(node)
}

private func exchangeChildren(_ node: Node?) {
    let leftNode = node?.left
    node?.left = node?.right
    node?.right = leftNode
}

/// Make `root` property the public.
// breadthFirstTraversal(bst.root)
// traverse(bst.root)
// breadthFirstTraversal(bst.root)
// traverse(bst.root)
// breadthFirstTraversal(bst.root)





// MARK: - Level-order traversal reconstruction of a BST:
var testArray = [10, 8, 12, 5, 9, 11, 14]
// 1   2   3  4  5   6   7
// 0   1   2  3  4   5   6
func check() -> Bool {
    for i in 0 ..< testArray.count {
        guard i * 2 + 2 != testArray.count - 1 else { return true }

        if testArray[i] < testArray[i * 2 + 1] {
            return false
        }

        if testArray[i] > testArray[i * 2 + 2] {
            return false
        }
    }
    return true
}

check()
