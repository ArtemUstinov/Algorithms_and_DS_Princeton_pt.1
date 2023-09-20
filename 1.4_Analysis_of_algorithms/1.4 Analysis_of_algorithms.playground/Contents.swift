import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Brute-force algorithm:
/// Time: O(n^3).
func tripleSum(in array: [Int]) -> Int {
    var count = 0

    measureTime {
        for i in 0 ..< array.count {
            for j in i + 1 ..< array.count {
                for k in j + 1 ..< array.count {
                    guard array[i] + array[j] + array[k] == 0 else { continue }
                    count += 1
                }
            }
        }
    }
    return count
}

/// Time: O(n^2 logN).
func tripleSumWithBS(in array: [Int]) -> Int {
    let array = array.sorted()
    var count = 0

    measureTime {
        for i in 0 ..< array.count {
            for j in i + 1 ..< array.count {
                let k = getIndexByBinarySearch(in: array, for: -(array[i] + array[j]))
                if k > j {
                    count += 1
                }
            }
        }
    }
    return count
}

private func getIndexByBinarySearch(in array: [Int], for num: Int) -> Int {
    var low = 0
    var high = array.count - 1

    while low <= high {
        let middle = low + (high - low) / 2

        if array[middle] == num {
            return middle
        } else if array[middle] > num {
            high = middle - 1
        } else {
            low = middle + 1
        }
    }
    return -1
}

private func measureTime(closure: () -> Void) {
    let start = CFAbsoluteTimeGetCurrent()
    closure()
    let dif = (CFAbsoluteTimeGetCurrent() - start) / 1_000_000
    print("Took \(dif) seconds")
}



var testArray1 = [30, -40, -20, -10, 40, 0, 10, 5]
var testArray2 = Array(-50 ... 50)

DispatchQueue.main.async {
    print("triple: ", tripleSum(in: testArray1))
}

DispatchQueue.main.async {
    print("triple with BS: ", tripleSumWithBS(in: testArray1))
}
