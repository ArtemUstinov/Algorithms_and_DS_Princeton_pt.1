import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



// MARK: - MergeSort:
/// It's a stable algorithm
/// Time complexity is linearithmic approximately. O ~ n LogN.
func sort(_ array: inout [Int]) {
    var aux = Array(repeating: 0, count: array.count)
    sort(array: &array, aux: &aux, low: 0, high: array.count - 1)
}

private func sort(array: inout [Int], aux: inout [Int], low: Int, high: Int) {
    guard low < high else { return }
    let mid = low + (high - low) / 2
    sort(array: &array, aux: &aux, low: low, high: mid)
    sort(array: &array, aux: &aux, low: mid + 1, high: high)
    mergeSort(array: &array, aux: &aux, low: low, mid: mid, high: high)
}

private func mergeSort(array: inout [Int], aux: inout [Int], low: Int, mid: Int, high: Int) {
    var i = low
    var j = mid + 1

    for k in low ... high {
        aux[k] = array[k]
    }

    for k in low ... high {
        if i > mid {
            array[k] = aux[j]
            j += 1
        } else if j > high {
            array[k] = aux[i]
            i += 1
        } else if aux[j] < aux[i] {
            array[k] = aux[j]
            j += 1
        } else {
            array[k] = aux[i]
            i += 1
        }
    }
}

var array1 = [0, 3, 10, 5, 9, 2, 1, 7, 4, 6, 8]
sort(&array1)





// MARK: - Improved mergeSort:
/// Time complexity is linearithmic approximately. O ~ n LogN.
var cutoff = 7 // It's middle num for using insertion sort in case of it.

func improvedSort(_ array: inout [Int]) {
    var aux = Array(repeating: 0, count: array.count)
    improvedSort(array: &array, aux: &aux, low: 0, high: array.count - 1)
}

private func improvedSort(array: inout [Int], aux: inout [Int], low: Int, high: Int) {
    guard low + cutoff - 1 < high else {
        insertionSort(&array, low: low, high: high)
        return
    }
    let mid = low + (high - low) / 2
    improvedSort(array: &array, aux: &aux, low: low, high: mid)
    improvedSort(array: &array, aux: &aux, low: mid + 1, high: high)

    if array[mid + 1] >= array[mid] {
        return
    }

    mergeSort(array: &array, aux: &aux, low: low, mid: mid, high: high)
}

private func insertionSort(_ array: inout [Int], low: Int, high: Int) {
    for i in low ... high {
        for j in (low ... i).reversed() where j > low && array[j] < array[j - 1] {
            array.swapAt(j, j - 1)
        }
    }
}

var array2 = [0, 3, 10, 5, 9, 2, 1, 7, 4, 6, 8]
improvedSort(&array2)





// MARK: - Bottom-up mergeSort:
/// Time complexity is linearithmic approximately. O ~ n LogN.
func sort(array: inout [Int]) {
    var aux = Array(repeating: 0, count: array.count)
    var size = 1

    for sz in 1 ..< array.count where sz == size {
        size *= 2

        for low in stride(from: 0, through: array.count - 1 - sz, by: sz * 2) {
            let mid = low + sz - 1
            let high = min(low + sz + sz - 1, array.count - 1)
            mergeSort(array: &array, aux: &aux, low: low, mid: mid, high: high)
        }
    }
}

var array3 = [0, 3, 10, 5, 9, 2, 1, 7, 4, 6, 8]
sort(array: &array3)
