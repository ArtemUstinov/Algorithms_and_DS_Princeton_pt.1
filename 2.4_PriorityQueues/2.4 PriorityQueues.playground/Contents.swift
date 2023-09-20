import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



                                            // MARK: - PriorityQueues with arrays:


// MARK: - Unordered Array maxPQ:
/// Space: linear.
public final class UnorderedArrayMaxPQ {
    private var pq: [Int?] = []
    private var n: Int

    public init(size: Int) {
        pq = .init(repeating: nil, count: size)
        n = 0
    }

    public func isEmpty() -> Bool {
        return n == 0
    }

    public func size() -> Int {
        return n
    }

    /// Time: constant.
    public func insert(_ key: Int) {
        pq[n] = key
        n += 1
    }

    /// Time: linear.
    public func deleteMax() -> Int {
        var i = 0

        for j in 1 ..< n where pq[i]! < pq[j]! {
            i = j
        }

        exchange(i, n - 1)
        let removed = pq[n - 1]
        pq[n - 1] = nil
        n -= 1
        return removed!
    }

    private func exchange(_ i: Int, _ j: Int) {
        let swap = pq[i]
        pq[i] = pq[j]
        pq[j] = swap
    }
}

let unorderedArrayMaxPQ = UnorderedArrayMaxPQ(size: 5)
unorderedArrayMaxPQ.size()
unorderedArrayMaxPQ.isEmpty()

unorderedArrayMaxPQ.insert(3)
unorderedArrayMaxPQ.insert(1)
unorderedArrayMaxPQ.insert(5)
unorderedArrayMaxPQ.insert(2)
unorderedArrayMaxPQ.insert(4)

unorderedArrayMaxPQ.size()
unorderedArrayMaxPQ.isEmpty()

unorderedArrayMaxPQ.deleteMax()
unorderedArrayMaxPQ.size()




// MARK: - Ordered Array maxPQ:
/// Space: linear.
public final class OrderedArrayMaxPQ {
    private var pq: [Int?]
    private var n: Int

    public init(size: Int) {
        pq = .init(repeating: nil, count: size)
        n = 0
    }

    public func isEmpty() -> Bool {
        return n == 0
    }

    public func size() -> Int {
        return n
    }

    // Time: constant.
    public func deleteMax() -> Int {
        let removed = pq[n - 1]
        pq[n - 1] = nil
        n -= 1
        return removed!
    }

    // Time: linear.
    public func insert(_ value: Int) {
        var i = n - 1

        while i >= 0 && value < pq[i]! {
            pq[i + 1] = pq[i]
            i -= 1
        }

        pq[i + 1] = value
        n += 1
    }
}

let orderedArrayMaxPQ = OrderedArrayMaxPQ(size: 5)
orderedArrayMaxPQ.size()
orderedArrayMaxPQ.isEmpty()

orderedArrayMaxPQ.insert(3)
orderedArrayMaxPQ.insert(1)
orderedArrayMaxPQ.insert(5)
orderedArrayMaxPQ.insert(2)
orderedArrayMaxPQ.insert(4)

orderedArrayMaxPQ.size()
orderedArrayMaxPQ.isEmpty()

orderedArrayMaxPQ.deleteMax()
orderedArrayMaxPQ.size()




                                                    // MARK: - Heap based PQs:

// MARK: - Heap based & ordered maxPQ:
/// Space: linear.
public final class HeapBasedMaxPQ {
    private var pq: [Int?]
    private var n: Int

    public init(size: Int) {
        pq = .init(repeating: nil, count: size + 1)
        n = 0
    }

    public init(from array: [Int]) {
        pq = .init(repeating: nil, count: array.count + 1)
        n = array.count

        for i in 0 ..< array.count {
            pq[i + 1] = array[i]
        }

        for k in (1 ..< array.count / 2).reversed() {
            sink(k)
        }
    }

    // MARK: - Public API:
    public func isEmpty() -> Bool {
        return n == 0
    }

    public func size() -> Int {
        return n
    }

    // Time: constant.
    public func max() -> Int? {
        return isEmpty() ? nil : pq[1]
    }

    // Time: Log N.
    public func insert(_ value: Int) {
        if n == pq.count - 1 {
            resize(2 * pq.count)
        }

        n += 1
        pq[n] = value
        swim(n)

        print("Is heap tree max after insertion? - ", isMaxHeap())
    }

    // Time: Log N.
    public func deleteMax() -> Int? {
        guard !isEmpty() else { return nil }
        let maxItem = pq[1]

        exchange(1, n)
        pq[n] = nil
        n -= 1

        sink(1)

        if n > 0, n == (pq.count - 1) / 4 {
            resize(pq.count / 2)
        }

        print("Is heap tree max afrer deleting? - ", isMaxHeap())
        return maxItem
    }

    // MARK: - Private helpers:
    private func resize(_ capacity: Int) {
        guard capacity > n else { return }
        var temp: [Int?] = .init(repeating: nil, count: capacity)

        for i in 1 ... n {
            temp[i] = pq[i]
        }
        pq = temp
    }

    private func exchange(_ i: Int, _ j: Int) {
        let swap = pq[i]
        pq[i] = pq[j]
        pq[j] = swap
    }

    private func sink(_ k: Int) {
        var k = k

        while 2 * k <= n {
            var j = 2 * k

            if j < n, pq[j]! < pq[j + 1]! {
                j += 1
            }

            guard pq[k]! < pq[j]! else { break }
            exchange(k, j)
            k = j
        }
    }

    private func swim(_ k: Int) {
        var k = k

        while k > 1, pq[k]! > pq[k / 2]! {
            exchange(k, k / 2)
            k /= 2
        }
    }

    // Time: Linear.
    private func isMaxHeap() -> Bool {
        guard pq[0] == nil else { return false }

        for i in 1 ... n where pq[i] == nil {
            return false
        }

        for i in n + 1 ..< pq.count where pq[i] != nil {
            return false
        }

        return isMaxHeapOrdered(1)
    }

    // Time: Logarithmic.
    private func isMaxHeapOrdered(_ k: Int) -> Bool {
        guard k < n else { return true }
        let left = 2 * k
        let right = 2 * k + 1

        if left <= n, pq[k]! < pq[left]! {
            return false
        }

        if right <= n, pq[k]! < pq[right]! {
            return false
        }

        return isMaxHeapOrdered(left) && isMaxHeapOrdered(right)
    }
}

let heapBasedMaxPQ = HeapBasedMaxPQ(size: 5)
heapBasedMaxPQ.size()
heapBasedMaxPQ.isEmpty()
heapBasedMaxPQ.max()

heapBasedMaxPQ.insert(3)
heapBasedMaxPQ.insert(1)
heapBasedMaxPQ.insert(5)
heapBasedMaxPQ.insert(2)
heapBasedMaxPQ.insert(4)
heapBasedMaxPQ.max()

heapBasedMaxPQ.size()
heapBasedMaxPQ.isEmpty()

heapBasedMaxPQ.deleteMax()
heapBasedMaxPQ.max()
heapBasedMaxPQ.size()

let heapBasedMaxPQ222 = HeapBasedMaxPQ(from: [4, 5, 2, 1, 3])
heapBasedMaxPQ222.isEmpty()
heapBasedMaxPQ222.size()
heapBasedMaxPQ222.max()

heapBasedMaxPQ222.deleteMax()
heapBasedMaxPQ222.max()
heapBasedMaxPQ222.size()





// MARK: - Heap based & ordered minPQ:
public final class HeapBasedMinPQ {
    private var pq: [Int?]
    private var n: Int

    public init(size: Int) {
        pq = .init(repeating: nil, count: size + 1)
        n = 0
    }

    public init(from array: [Int]) {
        pq = .init(repeating: nil, count: array.count + 1)
        n = array.count

        for i in 0 ..< array.count {
            pq[i + 1] = array[i]
        }

        for k in (1 ..< array.count / 2).reversed() {
            sink(k)
        }
    }

    // MARK: - Public API:
    public func isEmpty() -> Bool {
        return n == 0
    }

    public func size() -> Int {
        return n
    }

    // Time: constant.
    public func min() -> Int? {
        return isEmpty() ? nil : pq[1]
    }

    // Time: Log N.
    public func insert(_ value: Int) {
        if n == pq.count - 1 {
            resize(2 * pq.count)
        }
        n += 1
        pq[n] = value
        swim(n)

        print("Is heap tree `min` after insertion? - ", isMinHeap())
    }

    // Time: Log N.
    public func deleteMin() -> Int? {
        guard !isEmpty() else { return nil }
        let minItem = pq[1]

        exchange(1, n)
        pq[n] = nil
        n -= 1

        sink(1)

        if n > 0, n == (pq.count - 1) / 4 {
            resize(pq.count / 2)
        }

        print("Is heap tree `min` afrer deleting? - ", isMinHeap())
        return minItem
    }

    // MARK: - Private helpers:
    private func resize(_ capacity: Int) {
        guard capacity > n else { return }
        var temp: [Int?] = .init(repeating: nil, count: capacity)

        for i in 1 ... n {
            temp[i] = pq[i]
        }
        pq = temp
    }

    private func exchange(_ i: Int, _ j: Int) {
        let swap = pq[i]
        pq[i] = pq[j]
        pq[j] = swap
    }

    private func sink(_ k: Int) {
        var k = k

        while 2 * k <= n {
            var j = 2 * k

            if j < n, pq[j]! > pq[j + 1]! {
                j += 1
            }

            guard pq[k]! > pq[j]! else { break }
            exchange(k, j)
            k = j
        }
    }

    private func swim(_ k: Int) {
        var k = k

        while k > 1, pq[k]! < pq[k / 2]! {
            exchange(k, k / 2)
            k /= 2
        }
    }

    private func isMinHeap() -> Bool {
        guard pq[0] == nil else { return false }

        for i in 1 ... n where pq[i] == nil {
            return false
        }

        for i in n + 1 ..< pq.count where pq[i] != nil {
            return false
        }

        return isMinHeapOrdered(1)
    }

    private func isMinHeapOrdered(_ k: Int) -> Bool {
        guard k < n else { return true }
        let left = 2 * k
        let right = 2 * k + 1

        if left <= n, pq[k]! > pq[left]! {
            return false
        }

        if right <= n, pq[k]! > pq[right]! {
            return false
        }

        return isMinHeapOrdered(left) && isMinHeapOrdered(right)
    }
}

let heapBasedMinPQ = HeapBasedMinPQ(size: 5)
heapBasedMinPQ.size()
heapBasedMinPQ.isEmpty()
heapBasedMinPQ.min()

heapBasedMinPQ.insert(3)
heapBasedMinPQ.insert(1)
heapBasedMinPQ.insert(5)
heapBasedMinPQ.insert(2)
heapBasedMinPQ.insert(4)
heapBasedMinPQ.min()

heapBasedMinPQ.size()
heapBasedMinPQ.isEmpty()

heapBasedMinPQ.deleteMin()
heapBasedMinPQ.min()
heapBasedMinPQ.size()

heapBasedMinPQ.deleteMin()
heapBasedMinPQ.min()
heapBasedMinPQ.size()





// MARK: - Heap based & ordered INDEX maxPQ:
/// Space: 3n
public final class HeapBasedIndexMaxPQ {
    private var pq: [Int?]
    private var keys: [Int]
    private var items: [Int?]

    private var n: Int

    public init(capacity: Int) {
        guard capacity >= 0 else {
            pq = []
            keys = []
            items = []
            n = 0
            return
        }
        pq = .init(repeating: nil, count: capacity + 1)
        keys = .init(repeating: -1, count: capacity + 1)
        items = .init(repeating: nil, count: capacity + 1)
        n = 0
    }

    // MARK: - Public API:
    public func isEmpty() -> Bool {
        return n == 0
    }

    public func size() -> Int {
        return n
    }

    // Time: constant.
    public func maxItemKey() -> Int? {
        return isEmpty() ? nil : pq[1]
    }

    // Time: constant.
    public func maxItem() -> Int? {
        return isEmpty() ? nil : items[pq[1]!]
    }

    public func containsKey(_ key: Int) -> Bool {
        return validateIndex(key) && keys[key] != -1
    }

    public func item(of key: Int) -> Int? {
        return containsKey(key) ? items[key] : nil
    }

    public func changeItem(_ item: Int, for key: Int) {
        guard containsKey(key) else { return }
        items[key] = item
        swim(keys[key])
        sink(keys[key])
    }

    public func increaseItem(_ item: Int, for key: Int) {
        guard containsKey(key), items[key]! < item else { return }
        items[key] = item
        swim(keys[key])
    }

    public func decreaseItem(_ item: Int, for key: Int) {
        guard containsKey(key), items[key]! > item else { return }
        items[key] = item
        sink(keys[key])
    }

    // MARK: - Important public API:
    // Time: Log N
    public func insertItem(_ item: Int, for key: Int) {
        guard !containsKey(key) else { return }
        n += 1
        pq[n] = key
        keys[key] = n
        items[key] = item
        swim(n)
    }

    // Time: Log N
    public func deleteItem(of key: Int) {
        guard containsKey(key) else { return }
        let idx = keys[key]
        exchange(idx, n)

        pq[n] = nil
        keys[key] = -1
        items[key] = nil
        n -= 1

        guard idx <= n else { return }

        swim(idx)
        sink(idx)
    }

    // Time: 2Log N
    // Returns index of max item
    public func deleteMaxItem() -> Int? {
        guard n > 0 else { return nil }
        let maxItemIdx = pq[1]!
        exchange(1, n)

        pq[n] = nil
        keys[maxItemIdx] = -1
        items[maxItemIdx] = nil
        n -= 1

        sink(1)

        return maxItemIdx
    }

    // MARK: - Private helpers:
    private func validateIndex(_ i: Int) -> Bool {
        return i > 0 && i <= pq.count
    }

    private func exchange(_ i: Int, _ j: Int) {
        let swap = pq[i]
        pq[i] = pq[j]
        pq[j] = swap
        keys[pq[i]!] = i
        keys[pq[j]!] = j
    }

    private func sink(_ k: Int) {
        var k = k

        while 2 * k <= n {
            var j = 2 * k

            if j < n, items[pq[j]!]! < items[pq[j + 1]!]! {
                j += 1
            }

            guard items[pq[k]!]! < items[pq[j]!]! else { break }
            exchange(k, j)
            k = j
        }
    }

    private func swim(_ k: Int) {
        var k = k

        while k > 1, items[pq[k]!]! > items[pq[k / 2]!]! {
            exchange(k, k / 2)
            k /= 2
        }
    }
}

let heapBasedIndexMaxPQ = HeapBasedIndexMaxPQ(capacity: 5)
heapBasedIndexMaxPQ.size()
heapBasedIndexMaxPQ.isEmpty()
heapBasedIndexMaxPQ.maxItem()
heapBasedIndexMaxPQ.maxItemKey()

heapBasedIndexMaxPQ.insertItem(3, for: 3)
heapBasedIndexMaxPQ.insertItem(1, for: 1)
heapBasedIndexMaxPQ.insertItem(5, for: 5)
heapBasedIndexMaxPQ.insertItem(2, for: 2)
heapBasedIndexMaxPQ.insertItem(4, for: 4)
heapBasedIndexMaxPQ.maxItem()
heapBasedIndexMaxPQ.maxItemKey()

heapBasedIndexMaxPQ.size()
heapBasedIndexMaxPQ.isEmpty()

heapBasedIndexMaxPQ.containsKey(5)
heapBasedIndexMaxPQ.item(of: 5)

heapBasedIndexMaxPQ.deleteMaxItem()
heapBasedIndexMaxPQ.maxItem()
heapBasedIndexMaxPQ.maxItemKey()
heapBasedIndexMaxPQ.size()

heapBasedIndexMaxPQ.containsKey(5)
heapBasedIndexMaxPQ.item(of: 5)

heapBasedIndexMaxPQ.item(of: 4)
heapBasedIndexMaxPQ.increaseItem(10, for: 4)
heapBasedIndexMaxPQ.item(of: 4)
heapBasedIndexMaxPQ.maxItemKey()
heapBasedIndexMaxPQ.maxItem()
heapBasedIndexMaxPQ.changeItem(4, for: 4)
heapBasedIndexMaxPQ.item(of: 4)

heapBasedIndexMaxPQ.deleteItem(of: 4)
heapBasedIndexMaxPQ.maxItemKey()
heapBasedIndexMaxPQ.maxItem()
heapBasedIndexMaxPQ.size()





// MARK: - Heap based & ordered INDEX minPQ:
/// Space: 3n
public final class HeapBasedIndexMinPQ {
    private var pq: [Int?]
    private var keys: [Int]
    private var items: [Int?]

    private var n: Int

    public init(capacity: Int) {
        guard capacity >= 0 else {
            pq = []
            keys = []
            items = []
            n = 0
            return
        }
        pq = .init(repeating: nil, count: capacity + 1)
        keys = .init(repeating: -1, count: capacity + 1)
        items = .init(repeating: nil, count: capacity + 1)
        n = 0
    }

    // MARK: - Public API:
    public func isEmpty() -> Bool {
        return n == 0
    }

    public func size() -> Int {
        return n
    }

    public func minItemKey() -> Int? {
        return isEmpty() ? nil : pq[1]
    }

    public func minItem() -> Int? {
        return isEmpty() ? nil : items[pq[1]!]
    }

    public func containsKey(_ key: Int) -> Bool {
        return validateIndex(key) && keys[key] != -1
    }

    public func item(of key: Int) -> Int? {
        return containsKey(key) ? items[key] : nil
    }

    public func changeItem(_ item: Int, for key: Int) {
        guard containsKey(key) else { return }
        items[key] = item
        swim(keys[key])
        sink(keys[key])
    }

    public func increaseItem(_ item: Int, for key: Int) {
        guard containsKey(key), items[key]! < item else { return }
        items[key] = item
        swim(keys[key])
    }

    public func decreaseItem(_ item: Int, for key: Int) {
        guard containsKey(key), items[key]! > item else { return }
        items[key] = item
        sink(keys[key])
    }

    // MARK: - Important public API:
    // Time: Log N
    public func insertItem(_ item: Int, for key: Int) {
        guard !containsKey(key) else { return }
        n += 1
        pq[n] = key
        keys[key] = n
        items[key] = item
        swim(n)
    }

    // Time: Log N
    public func deleteItem(of key: Int) {
        guard containsKey(key) else { return }
        let idx = keys[key]
        exchange(idx, n)

        pq[n] = nil
        keys[key] = -1
        items[key] = nil
        n -= 1

        guard idx <= n else { return }
        swim(idx)
        sink(idx)
    }

    // Time: 2Log N
    // Returns index of minimal item
    public func deleteMinItem() -> Int? {
        guard n > 0 else { return nil }
        let minItemIdx = pq[1]!
        exchange(1, n)

        pq[n] = nil
        keys[minItemIdx] = -1
        items[minItemIdx] = nil
        n -= 1

        sink(1)

        return minItemIdx
    }

    // MARK: - Private helpers:
    private func validateIndex(_ i: Int) -> Bool {
        return i > 0 && i <= pq.count
    }

    private func exchange(_ i: Int, _ j: Int) {
        let swap = pq[i]
        pq[i] = pq[j]
        pq[j] = swap
        keys[pq[i]!] = i
        keys[pq[j]!] = j
    }

    private func sink(_ k: Int) {
        var k = k

        while 2 * k <= n {
            var j = 2 * k

            if j < n, items[pq[j]!]! > items[pq[j + 1]!]! {
                j += 1
            }

            guard items[pq[k]!]! > items[pq[j]!]! else { break }
            exchange(k, j)
            k = j
        }
    }

    private func swim(_ k: Int) {
        var k = k

        while k > 1, items[pq[k]!]! < items[pq[k / 2]!]! {
            exchange(k, k / 2)
            k /= 2
        }
    }
}

let heapBasedIndexMinPQ = HeapBasedIndexMinPQ(capacity: 50)
heapBasedIndexMinPQ.size()
heapBasedIndexMinPQ.isEmpty()
heapBasedIndexMinPQ.minItem()
heapBasedIndexMinPQ.minItemKey()

heapBasedIndexMinPQ.insertItem(3, for: 3)
heapBasedIndexMinPQ.insertItem(1, for: 15)
heapBasedIndexMinPQ.insertItem(5, for: 5)
heapBasedIndexMinPQ.insertItem(2, for: 2)
heapBasedIndexMinPQ.insertItem(4, for: 4)

heapBasedIndexMinPQ.minItem()
heapBasedIndexMinPQ.minItemKey()
heapBasedIndexMinPQ.size()
heapBasedIndexMinPQ.isEmpty()

heapBasedIndexMinPQ.containsKey(5)
heapBasedIndexMinPQ.item(of: 5)

heapBasedIndexMinPQ.deleteMinItem()
heapBasedIndexMinPQ.minItem()
heapBasedIndexMinPQ.minItemKey()
heapBasedIndexMinPQ.size()

heapBasedIndexMinPQ.containsKey(15)
heapBasedIndexMinPQ.item(of: 1)

heapBasedIndexMinPQ.item(of: 4)
heapBasedIndexMinPQ.increaseItem(10, for: 4)
heapBasedIndexMinPQ.item(of: 4)
heapBasedIndexMinPQ.decreaseItem(8, for: 4)
heapBasedIndexMinPQ.item(of: 4)
heapBasedIndexMinPQ.changeItem(4, for: 4)
heapBasedIndexMinPQ.item(of: 4)

heapBasedIndexMinPQ.minItemKey()
heapBasedIndexMinPQ.minItem()
heapBasedIndexMinPQ.size()

heapBasedIndexMinPQ.deleteItem(of: 4)
heapBasedIndexMinPQ.item(of: 4)
heapBasedIndexMinPQ.size()

heapBasedIndexMinPQ.minItemKey()
heapBasedIndexMinPQ.minItem()
heapBasedIndexMinPQ.deleteItem(of: 2)
heapBasedIndexMinPQ.size()

heapBasedIndexMinPQ.minItemKey()
heapBasedIndexMinPQ.minItem()
heapBasedIndexMinPQ.deleteItem(of: 3)
heapBasedIndexMinPQ.size()

heapBasedIndexMinPQ.deleteMinItem()
heapBasedIndexMinPQ.size()




                                                    // MARK: - HeapSort:

// MARK: - Min HeapSort:
public final class BottomUpHeapSort {
    // MARK: - Public API:
    // In place, theta of place: Constant.
    // Time theta: 2 N Log N
    public func sort(_ array: inout [Int]) {
        var k = array.count

        for i in stride(from: k / 2, to: 0, by: -1) {
            sink(&array, i, k)
        }

        while k > 1 {
            exchange(&array, 1, k)
            k -= 1

            sink(&array, 1, k)
        }
    }

    // MARK: - Private helpers:
    private func sink(_ array: inout [Int], _ i: Int, _ n: Int) {
        var k = i

        while 2 * k <= n {
            var j = 2 * k

            if j < n, array[j - 1] < array[j] {
                j += 1
            }

            guard array[k - 1] < array[j - 1] else { break }
            exchange(&array, k, j)
            k = j
        }
    }

    private func exchange(_ array: inout [Int], _ i: Int, _ j: Int) {
        let swap = array[i - 1]
        array[i - 1] = array[j - 1]
        array[j - 1] = swap
    }
}

let bottomUpHeapSort = BottomUpHeapSort()
var array = [5, 0, 10, 4, 2, 1, 8, 9, 3, 6, 7, 4, 10]

bottomUpHeapSort.sort(&array)
array




// MARK: - Max HeapSort:
public final class UpBottomHeapSort {
    // MARK: - Public API:
    // In place, theta of place: Constant.
    // Time Theta: 2 N Log N
    public func sort(_ array: inout [Int]) {
        var k = array.count

        for i in stride(from: k / 2, to: 0, by: -1) {
            sink(&array, i, k)
        }

        while k > 1 {
            exchange(&array, 1, k)
            k -= 1

            sink(&array, 1, k)
        }
    }

    // MARK: - Private helpers:
    private func sink(_ array: inout [Int], _ i: Int, _ n: Int) {
        var k = i

        while 2 * k <= n {
            var j = 2 * k

            if j < n, array[j - 1] > array[j] {
                j += 1
            }

            guard array[k - 1] > array[j - 1] else { break }
            exchange(&array, k, j)
            k = j
        }
    }

    private func exchange(_ array: inout [Int], _ i: Int, _ j: Int) {
        let swap = array[i - 1]
        array[i - 1] = array[j - 1]
        array[j - 1] = swap
    }
}

let upBottomHeapSort = UpBottomHeapSort()
var ar = [5, 0, 10, 4, 2, 1, 8, 9, 3, 6, 7, 4, 10]

upBottomHeapSort.sort(&ar)
ar





// MARK: - From Sedgewick' exercises:
final class HeapBasedMedianPQ {
    private var pq: [Int?] = [nil]
    private var randomN: Int?
    private var n: Int

    // MARK: - Public API:
    public init(for array: [Int]) {
        n = array.count

        guard !array.isEmpty else { return }
        pq = .init(repeating: nil, count: array.count + 1)

        for i in 0 ..< array.count {
            pq[i + 1] = array[i]
        }

        for k in (1 ... pq.count / 2).reversed() {
            sink(k)
        }
    }

    // Time: Logarithmic.
    public func push(_ val: Int) {
        if pq.count - 1 == n {
            resize(pq.count * 2)
        }

        n += 1
        pq[n] = val
        swim(n)
    }

    // Time: Logarithmic.
    public func popMedian() -> Int? {
        guard !isEmpty() else { return nil }
        let medianItem = pq[n / 2]

        exchange(n / 2, n)
        pq[n] = nil
        n -= 1

        sink(n / 2)
        swim(n / 2)

        if n == (pq.count - 1) / 4 {
            resize(pq.count / 2)
        }

        return medianItem
    }

    // Time: Constant.
    public func median() -> Int? {
        print(pq)
        return isEmpty() ? nil : pq[n / 2]
    }

    // Time: Constant.
    public func sample() -> Int? {
        guard !isEmpty() else { return nil }
        randomN = Int.random(in: 1 ... n)
        return randomN
    }

    // Time: Logarithmic.
    public func popRandom() -> Int? {
        guard !isEmpty() else { return nil }
        let randomItem = pq[randomN!]

        exchange(randomN!, n)
        pq[n] = nil
        n -= 1

        guard randomN! <= n else { return randomItem }
        sink(randomN!)
        swim(randomN!)

        if n == (pq.count - 1) / 4 {
            resize(pq.count / 2)
        }

        return randomItem
    }

    // MARK: - Private helpers:
    private func isEmpty() -> Bool {
        return n == 0
    }

    private func swim(_ k: Int) {
        var k = k

        while k > 1, pq[k]! < pq[k / 2]! {
            exchange(k, k / 2)
            k /= 2
        }
    }

    private func sink(_ k: Int) {
        var k = k

        while 2 * k <= n {
            var j = 2 * k

            if j < n, pq[j]! > pq[j + 1]! {
                j += 1
            }

            guard pq[k]! > pq[j]! else { break }
            exchange(k, j)
            k = j
        }
    }

    private func exchange(_ i: Int, _ j: Int) {
        let swap = pq[i]!
        pq[i]! = pq[j]!
        pq[j]! = swap
    }

    private func resize(_ capacity: Int) {
        guard capacity > n else { return }
        var temp: [Int?] = .init(repeating: nil, count: capacity)

        for i in 1 ... n {
            temp[i] = pq[i]
        }
        pq = temp
    }
}

let medianPQ = HeapBasedMedianPQ(for: [5, 0, 10, 4, 2, 1, 8, 9, 3, 6, 7])
medianPQ.median()
medianPQ.popMedian()
medianPQ.median()
medianPQ.popMedian()
medianPQ.median()
medianPQ.popMedian()

medianPQ.sample()
medianPQ.popRandom()





// MARK: - Work example for LeetCode:
private final class LeetCodeHeapBasedMinPQ {
    private var pq: [Int?] = [nil]
    private var n: Int

    // MARK: - Public API:
    public init(with array: [Int]) {
        n = array.count

        guard !array.isEmpty else { return }
        pq = .init(repeating: nil, count: array.count + 1)

        for i in 0 ..< array.count {
            pq[i + 1] = array[i]
        }

        for k in (1 ... pq.count / 2).reversed() {
            sink(k)
        }
    }

    public func insert(_ value: Int) {
        if pq.count - 1 == n {
            resize(pq.count * 2)
        }

        n += 1
        pq[n] = value
        swim(n)
    }

    public func deleteMin() -> Int? {
        guard !isEmpty() else { return nil }
        let minItem = pq[1]

        exchange(1, n)
        pq[n] = nil
        n -= 1
        sink(1)

        if n > 0, n == (pq.count - 1) / 4 {
            resize(pq.count / 2)
        }

        return minItem
    }

    public func minItem() -> Int? {
        return isEmpty() ? nil : pq[1]
    }

    public func size() -> Int {
        return n
    }

    // MARK: - Private helpers:
    private func isEmpty() -> Bool {
        return n == 0
    }

    private func sink(_ k: Int) {
        var k = k

        while 2 * k <= n {
            var j = 2 * k

            if j < n, pq[j]! > pq[j + 1]! {
                j += 1
            }

            guard pq[k]! > pq[j]! else { break }
            exchange(k, j)
            k = j
        }
    }

    private func swim(_ k: Int) {
        var k = k

        while k > 1, pq[k]! < pq[k / 2]! {
            exchange(k, k / 2)
            k /= 2
        }
    }

    private func exchange(_ i: Int, _ j: Int) {
        let swap = pq[i]!
        pq[i]! = pq[j]!
        pq[j]! = swap
    }

    private func resize(_ capacity: Int) {
        guard capacity > n else { return }
        var temp: [Int?] = .init(repeating: nil, count: capacity)

        if !isEmpty() {
            for i in 1 ... n {
                temp[i] = pq[i]
            }
        }

        pq = temp
    }
}
