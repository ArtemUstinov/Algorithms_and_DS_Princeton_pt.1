import Darwin
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


// MARK: - Selection sort:
/// Time complexity of tilte-notation: n^2 / 2 where array echange executes for linear time.
func selectionSort(_ array: inout [Int]) {
    for i in 0 ..< array.count {
        var minIndex = i

        for j in i + 1 ..< array.count where array[j] < array[minIndex] {
            minIndex = j
        }
        array.swapAt(i, minIndex)
    }
}

var array1 = [10, 1, 9, 2, 4, 0, 5]
selectionSort(&array1)




// MARK: - Insertion sort:
/// Time complexity is approximation ~ n^2 / 4. In the worst case is big O n^2 / 2.
func insertionSort(_ array: inout [Int]) {
    for i in 1 ..< array.count {
        for j in (1 ... i).reversed() where array[j] < array[j - 1] {
            array.swapAt(j, j - 1)
        }
    }
}

var array2 = [10, 1, 9, 2, 4, 0, 5]
insertionSort(&array2)





// MARK: - Shell' sort:
/// Time complexity is aproximation ~ (In our days no one knows the accurate complexity model for Shell's sort). In the worst case is big O(n^3/2), but it so faster ussually.
func shellSort(_ array: inout [Int]) {
    var h = 1

    while h < (array.count - 1) / 3 {
        h = 3 * h + 1
    }

    while h > 0 {
        for i in h ... array.count - 1 {
            for j in stride(from: i, through: 0, by: -h) where j >= h && array[j] < array[j - h] {
                array.swapAt(j, j - h)
            }
        }
        h /= 3
    }
}

var array3 = [10, 1, 9, 2, 4, 0, 5]
shellSort(&array3)





// MARK: - Shuffling:
/// Time complexity approximately is ~ n (linear).
func shuffle(_ array: inout [Int]) {
    for i in 0 ..< array.count {
        let randomNum = Int.random(in: 0 ... i)
        print(randomNum)
        array.swapAt(i, randomNum)
    }
}

var array4 = Array(0 ... 10)
shuffle(&array4)
