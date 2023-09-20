import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var array1 = Array(0 ... 9)

var array2 = Array(0 ... 9)

var array3 = Array(0 ... 9)
var size = Array(repeating: 1, count: 10)

var array4 = Array(0 ... 9)
var size2 = Array(repeating: 1, count: 10)

// MARK: - Quick find:
/// Time: O(n^2). Space: O(1).
func quickFind<T: Equatable>(in array: inout [T], i: Int, j: Int) {
    let iElement = array[i]
    let jElement = array[j]

    for index in 0 ..< array.count {
        if array[index] == iElement {
            array[index] = jElement
        }
    }
}

print("array1", array1)
quickFind(in: &array1, i: 0, j: 5)
quickFind(in: &array1, i: 1, j: 2)
quickFind(in: &array1, i: 1, j: 6)
quickFind(in: &array1, i: 2, j: 7)
quickFind(in: &array1, i: 5, j: 6)
quickFind(in: &array1, i: 3, j: 4)
quickFind(in: &array1, i: 3, j: 8)
quickFind(in: &array1, i: 4, j: 9)
print("array1", array1)

// MARK: - Quick-union:
/// Time: O(n). Space: O(n).
func quickUnion(in array: inout [Int], i: Int, j: Int) {
    guard !isConnected(i: i, j: j, in: array) else { return }
    let iElement = root(i, in: array)
    let jElement = root(j, in: array)
    array[iElement] = jElement
}

private func isConnected(i: Int, j: Int, in array: [Int]) -> Bool {
    return root(i, in: array) == root(j, in: array)
}

private func root(_ i: Int, in array: [Int]) -> Int {
    var value = i

    while value != array[value] {
        value = array[value]
    }
    return value
}

print("array2", array2)
quickUnion(in: &array2, i: 4, j: 3)
quickUnion(in: &array2, i: 3, j: 8)
quickUnion(in: &array2, i: 6, j: 5)
quickUnion(in: &array2, i: 9, j: 4)
quickUnion(in: &array2, i: 2, j: 1)
quickUnion(in: &array2, i: 8, j: 9)
quickUnion(in: &array2, i: 5, j: 0)
quickUnion(in: &array2, i: 7, j: 2)
quickUnion(in: &array2, i: 6, j: 1)
quickUnion(in: &array2, i: 7, j: 3)
print("array2", array2)




// MARK: - Weighted quick-union:
func weightedQuickUnion(in array: inout [Int], i: Int, j: Int) {
    guard !isConnected(i: i, j: j, in: array) else { return }
    let iElement = root(i, in: array)
    let jElement = root(j, in: array)

    if size[iElement] < size[jElement] {
        array[iElement] = jElement
        size[jElement] += size[iElement]
    } else {
        array[jElement] = iElement
        size[iElement] += size[jElement]
    }
}

print("array3", array3)
print("size", size)
weightedQuickUnion(in: &array3, i: 4, j: 3)
weightedQuickUnion(in: &array3, i: 3, j: 8)
weightedQuickUnion(in: &array3, i: 6, j: 5)
weightedQuickUnion(in: &array3, i: 9, j: 4)
weightedQuickUnion(in: &array3, i: 2, j: 1)
weightedQuickUnion(in: &array3, i: 5, j: 0)
weightedQuickUnion(in: &array3, i: 7, j: 2)
weightedQuickUnion(in: &array3, i: 6, j: 1)
weightedQuickUnion(in: &array3, i: 7, j: 3)
print("size", size)
print("array3", array3)




// MARK: - Weighted quick-union with path-compression:
func weightedQuickUnionWithPathCompression(in array: inout [Int], i: Int, j: Int) {
    guard !isConnectedGrandfathers(i: i, j: j, in: &array) else { return }
    let iElement = grandfatherRoot(i, in: &array)
    let jElement = grandfatherRoot(j, in: &array)

    if size[iElement] < size[jElement] {
        array[iElement] = jElement
        size[jElement] += size[iElement]
    } else {
        array[jElement] = iElement
        size[iElement] += size[jElement]
    }
}

private func isConnectedGrandfathers(i: Int, j: Int, in array: inout [Int]) -> Bool {
    return grandfatherRoot(i, in: &array) == grandfatherRoot(j, in: &array)
}

private func grandfatherRoot(_ i: Int, in array: inout [Int]) -> Int {
    var value = i

    while value != array[value] {
        array[value] = array[array[value]]
        value = array[value]
    }
    return value
}

print("array4", array4)
print("size2", size2)
weightedQuickUnionWithPathCompression(in: &array4, i: 4, j: 3)
weightedQuickUnionWithPathCompression(in: &array4, i: 3, j: 8)
weightedQuickUnionWithPathCompression(in: &array4, i: 6, j: 5)
weightedQuickUnionWithPathCompression(in: &array4, i: 9, j: 4)
weightedQuickUnionWithPathCompression(in: &array4, i: 2, j: 1)
weightedQuickUnionWithPathCompression(in: &array4, i: 5, j: 0)
weightedQuickUnionWithPathCompression(in: &array4, i: 7, j: 2)
weightedQuickUnionWithPathCompression(in: &array4, i: 6, j: 1)
weightedQuickUnionWithPathCompression(in: &array4, i: 7, j: 3)
print("size2", size2)
print("array4", array4)
