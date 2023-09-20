import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



// MARK: - QuickSort:
/// It's a not stable algorithm
/// The worst case is approximately ~ 1/2 n^2
/// The best case is approximately ~ n Ln N
func sort(_ array: inout [Int]) {
    shuffle(&array)
    sort(&array, low: 0, high: array.count - 1)
}

private func sort(_ array: inout [Int], low: Int, high: Int) {
    guard low < high else { return }
    let j = partition(&array, low: low, high: high)
    sort(&array, low: low, high: j - 1)
    sort(&array, low: j + 1, high: high)
}

private func partition(_ array: inout [Int], low: Int, high: Int) -> Int {
    var i = low + 1
    var j = high

    while true {
        while array[low] > array[i] {
            guard i < high else { break }
            i += 1
        }

        while array[low] < array[j] {
            guard j > low else { break }
            j -= 1
        }

        guard i < j else { break }
        array.swapAt(i, j)
    }
    array.swapAt(low, j)
    return j
}

private func shuffle(_ array: inout [Int]) {
    for i in 0 ..< array.count {
        let random = Int.random(in: 0 ... i)
        array.swapAt(i, random)
    }
}

var array1 = [0, 3, 10, 5, 9, 2, 1, 7, 4, 6, 8, 14, 11, 12, 13, 15]
sort(&array1)





// MARK: - Improved QuickSort:
/// It's a not stable algorithm
/// The worst case is approximately ~ 1/2 n^2
/// The best case is approximately ~ n Ln N
let cutoff = 10

func improvedSort(_ array: inout [Int]) {
    shuffle(&array)
    improvedSort(&array, low: 0, high: array.count - 1)
}

private func improvedSort(_ array: inout [Int], low: Int, high: Int) {
    guard low < high else { return }

    if low + cutoff - 1 > high {
        insertionSort(&array, low: low, high: high)
        return
    }

    let mid = low + (high - low) / 2
    let median = median(in: array, i: low, j: mid, k: high)
    array.swapAt(low, median)

    let j = partition(&array, low: low, high: high)
    improvedSort(&array, low: low, high: j - 1)
    improvedSort(&array, low: j + 1, high: high)
}

private func insertionSort(_ array: inout [Int], low: Int, high: Int) {
    for i in low ... high {
        for j in (low ... i).reversed() where j > low && array[j] < array[j - 1] {
            array.swapAt(j, j - 1)
        }
    }
}

private func median(in _: [Int], i: Int, j: Int, k: Int) -> Int {
    if i < j {
        if j < k {
            return j
        } else {
            if i < k {
                return k
            } else {
                return i
            }
        }
    } else {
        if k < j {
            return j
        } else {
            if k < i {
                return k
            } else {
                return i
            }
        }
    }
}

var array2 = [0, 3, 10, 5, 9, 2, 1, 7, 4, 6, 8, 14, 11, 12, 13, 15]
improvedSort(&array2)





// MARK: - QuickSelect:
// For example, when we need to find smallest K`th element
/// The worst case is approximately ~ 1/2 n^2
/// The best case is approximately ~ n (linear).
func select(in array: inout [Int], k: Int) -> Int? {
    guard k >= 0, k < array.count else { return nil }
    shuffle(&array)
    var low = 0
    var high = array.count - 1

    while low < high {
        let j = partition(&array, low: low, high: high)

        if j == k {
            return array[j]
        } else if j > k {
            high = j - 1
        } else {
            low = j + 1
        }
    }
    return array[low]
}

var array3 = [4, 5, 1, 3, 2]
select(in: &array3, k: 0)





// MARK: - Dijkstra 3-way QuickSort:
// Suitable sorting for the big arrays with duplicate's keys.
/// The worst case is approximately ~ n LgN
/// The best case is approximately ~ n (linear).
func threeWaySort(_ array: inout [Int]) {
    shuffle(&array)
    threeWaySort(&array, low: 0, high: array.count - 1)
}

private func threeWaySort(_ array: inout [Int], low: Int, high: Int) {
    guard low < high else { return }
    let v = array[low]
    var lt = low
    var gt = high
    var i = low + 1

    while i <= gt {
        if array[i] > v {
            array.swapAt(i, gt)
            gt -= 1
        } else if array[i] < v {
            array.swapAt(lt, i)
            lt += 1
            i += 1
        } else {
            i += 1
        }
    }
    threeWaySort(&array, low: low, high: lt - 1)
    threeWaySort(&array, low: gt + 1, high: high)
}

var array4 = [4, 5, 4, 1, 3, 2, 1, 4, 2, 2, 1, 5, 3, 3]
threeWaySort(&array4)





// MARK: - Example task. Nuts and bolts - where count of arrays is equal.
func sort1(_ nuts: inout [Int], _ bolts: inout [Int]) {
    shuffle(&nuts)
    shuffle(&bolts)
    sort1(&nuts, &bolts, low: 0, high: nuts.count - 1)
}

private func sort1(_ nuts: inout [Int], _ bolts: inout [Int], low: Int, high: Int) {
    guard low < high else { return }
    let pivot = partition1(&nuts, low: low, high: high, pivot: bolts[high])
    partition1(&bolts, low: low, high: high, pivot: nuts[pivot])
    sort1(&nuts, &bolts, low: low, high: pivot - 1)
    sort1(&nuts, &bolts, low: pivot + 1, high: high)
}

private func partition1(_ array: inout [Int], low: Int, high: Int, pivot: Int) -> Int {
    var i = low
    var j = low

    while j < high {
        if array[j] < pivot {
            array.swapAt(i, j)
            i += 1
        } else if array[j] == pivot {
            array.swapAt(j, high)
            j -= 1
        }
        j += 1
    }
    array.swapAt(high, i)
    return i
}

var nuts = [1, 4, 5, 2, 3]
var bolts = [5, 3, 4, 2, 1]
sort1(&nuts, &bolts)
print(nuts)
print(bolts)
