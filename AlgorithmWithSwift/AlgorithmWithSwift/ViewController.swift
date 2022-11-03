//
//  ViewController.swift
//  AlgorithmWithSwift
//
//  Created by Tr2e on 2021/4/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let prices: [Int] = []
        print(Solution.default.maxProfit(prices))
    }

}

// MARK: Sort

/// 冒泡排序
/// 稳定：稳定排序
/// 思想：从前往后扫描，与相邻的元素比较，将较大的元素交换到后边
/// 时间复杂度：与序列中的逆序对数量正相关
/// 最好时间复杂度 O(n)
/// 最坏时间复杂度 O(n^2)
private func bubbleSort(_ list: [Int]) -> [Int] {
    guard list.count > 1 else { return list }
    var result: [Int] = list
    for index in 1...result.count-1 {
        let end = list.count - index
        for begin in 1...end {
            if result[begin] < result[begin-1] {
                let temp = result[begin]
                result[begin] = result[begin-1]
                result[begin-1] = temp
            }
        }
    }
    return result
}

/// 选择排序
/// 稳定：不稳定排序
/// 思想：从0位置往后扫描数据，保证扫描结束位置为本轮扫描最大值
/// 时间复杂度: O(n^2)
private func selectionSort(_ list: [Int]) -> [Int] {
    guard list.count > 1 else { return list }
    var result = list
    for index in 1...result.count {
        let end = result.count - index
        var max = 0
        // 扫描获取最大值
        for scanner in 0...end {
            if result[max] < result[scanner] {
                max = scanner
            }
        }
        // 放到本轮最后
        let temp = result[end]
        result[end] = result[max]
        result[max] = temp
    }
    return result
}

/// 插入排序
/// 稳定：稳定排序
/// 思想：保证数组前方始终有序，将较小的数据`向前交换`
/// 时间复杂度：与序列中的逆序对数量正相关
/// 最好时间复杂度 O(n)
/// 最坏时间复杂度 O(n^2)
private func insertionSort(_ list: [Int]) -> [Int] {
    guard list.count > 1 else { return list }
    var result: [Int] = list
    for begin in 1...result.count-1 {
        var cmpIndex = begin
        /*
        while cmpIndex > 0 && result[cmpIndex] < result[cmpIndex-1] {
            let temp = result[cmpIndex-1]
            result[cmpIndex-1] = result[cmpIndex]
            result[cmpIndex] = temp
            cmpIndex -= 1
        } */
        let cmpValue = result[cmpIndex]
        // 挪动
        while cmpIndex > 0 && cmpValue < result[cmpIndex-1] {
            result[cmpIndex] = result[cmpIndex-1]
            cmpIndex -= 1
        }
        // 插入
        result[cmpIndex] = cmpValue
    }
    return result
}

/// 二分查找
/// 时间复杂度：O(logn)
private func binarySearch(_ list: [Int],_ target: Int) -> Int {
    guard list.count > 0 else { return -1 }
    var begin = 0
    var end = list.count - 1
    while begin <= end {
        let middle: Int = (begin + end) >> 1
        if list[middle] > target {
            end = middle - 1
        } else if list[middle] < target {
            begin = middle + 1
        } else {
            return middle
        }
    }
    return -1
}

/// 归并排序 (Merge Sort)
/// 稳定性：稳定排序
/// 思想：Divide Sort & Merge
/// 时间复杂度：O(nlogn)
private func mergeSort(_ list: inout [Int]) {
    let begin: Int = 0;
    let end: Int = list.count
    divideMergeSort(&list, begin, end)
}

private func divideMergeSort(_ list: inout [Int], _ begin: Int, _ end: Int) {
    if end - begin < 2 { return }
    let mid: Int = (end + begin) >> 1
    divideMergeSort(&list, begin, mid)
    divideMergeSort(&list, mid, end)
    merge(&list, begin, mid, end)
}

private func merge(_ list: inout [Int], _ begin: Int, _ mid: Int, _ end: Int) {
    
    var temp_left = 0
    let temp_length = mid - begin
    var right_left = mid
    var true_left = begin
    
    // 将前半部分复制进行操作
    var tempList: [Int] = []
    for index in 0..<temp_length {
        tempList.append(list[(begin + index)])
    }
    
    while temp_left < temp_length {
        // 因为左侧不可能越界，故以右侧为准，对原数组进行交换填充
        if right_left < end && tempList[temp_left] > list[right_left] {
            // tempList[temp_left] >= list[right_left] 则算法不稳定
            list[true_left] = list[right_left]
            right_left += 1
        } else {
            list[true_left] = tempList[temp_left]
            temp_left += 1
        }
        true_left += 1
    }
}

/// 快排 (Quick Sort)
/// 稳定：不稳定排序
/// 思想：双指针 Divide & Conquer
/// 时间复杂度：
/// 最好时间复杂度 O(nlogn)
/// 最坏时间复杂度 O(n^2)
private func quickSort(_ list: inout [Int], _ first: Int, _ last: Int) {
    guard last > first else { return }
    
    /// Conquer
    /// pivot 确定轴点元素
    let pivot = list[first]
    var pre = first
    var post = last
    while pre != post {
        // 从后往前找小的
        while list[post] >= pivot && post > pre {
            post -= 1
        }
        // 从前往后找大的
        while list[pre] <= pivot && post > pre {
            pre += 1
        }
        // 将前半部分较大元素与后半部分较小元素进行交换
        if pre < post {
            let temp = list[pre]
            list[pre] = list[post]
            list[post] = temp
        }
    }
    
    // 目前的pre = post，即为轴点位置
    // 把目标值换到相遇的位置(交换元素)
    list[first] = list[pre]
    list[pre] = pivot
    
    /// Divide
    // 分离成两部分继续进行交换操作
    quickSort(&list, first, pre - 1)
    quickSort(&list, post + 1, last)
}

private func quickSort2(_ list: inout [Int], _ first: Int, _ last: Int) {
    guard first < last - 1 else { return }
    /// Conquer
    // 确定轴点元素存放合适位置并返回该位置
    let pivot_index = pivotIndex(&list, first, last)
    /// Divide
    // [first, pivot_index)
    quickSort2(&list, first, pivot_index)
    // [pivot_index+1, last)
    quickSort2(&list, pivot_index + 1, last)
}

/// 轴点构造
/// 返回轴点位置
private func pivotIndex(_ list: inout [Int], _ begin: Int, _ end: Int) -> Int {
    // 轴点元素
    let pivot = list[begin]
    var post = end - 1
    var pre = begin
    while pre < post {
        while pre < post {
            /// 保证分割均匀,尽量是每次sort的规模减半
            /// 避免出现分割不均匀导致时间最坏时间复杂度O(n^2)
            if list[post] > pivot {
                post -= 1
            } else {
                list[pre] = list[post]
                pre += 1
                break
            }
        }
        while pre < post {
            if list[pre] < pivot {
                pre += 1
            } else {
                list[post] = list[pre]
                post -= 1
                break
            }
        }
    }
    
    /// 此时pre-post相等
    /// 确定轴点元素位置并赋值
    list[pre] = pivot
    return pre
}

/// 希尔排序（Shell Sort）/ 递减增量排序（Diminishing Increment Sort）
/// 确定步长序列（Step Sequence）
/// 按照插入排序思想进行处理，综合性能优于插入排序
/// 稳定：不稳定排序
/// 时间复杂度：
/// 最好时间复杂度 O(n)
/// 最坏时间复杂度：O(n^2)
private func shellSort(_ list: inout [Int]) {
    let stepSequence = shellStepSequence(list.count)
    for step in stepSequence {
        shellInsertionSort(&list, step)
    }
}

/// 插入排序希尔版
private func shellInsertionSort(_ list: inout [Int], _ step: Int) {
    // 步长序列的每一列进行排序
    for column in 0..<step {
        // 插入排序思想遍历数据
        var begin = column + step
        while begin < list.count {
            let current = list[begin]
            var cmpIndex = begin
            // 注意使用current进行比较
            while cmpIndex > column && current < list[cmpIndex - step] {
                list[cmpIndex] = list[cmpIndex - step]
                cmpIndex -= step
            }
            list[cmpIndex] = current
            begin += step
        }
    }
}

/// 输入数据规模，确定希尔排序步长序列
private func shellStepSequence(_ dataSize: Int) -> [Int] {
    var size = dataSize >> 1
    var result: [Int] = []
    while size > 0 {
        result.append(size)
        size >>= 1
    }
    return result
}

/// 计数排序（Counting Sort）
/// 针对一定范围内的`整数`进行排序



// MARK: Data Structure - Array

/// 两数之和
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    guard nums.count >= 2 else { return [] }
    
    var numMap:[Int: Int] = [Int: Int]()
    for index in 0..<nums.count {
        numMap[nums[index]] = index
    }
    
    for index in 0..<nums.count {
        let a = nums[index]
        if let t = numMap[target - a] {
            if t != index { return [index,t] }
        }
    }
    
    return []
}

/// 三数之和

/// 暴力循环，超时
func threeSum(_ nums: [Int]) -> [[Int]] {
    guard nums.count >= 3 else { return [] }
    
    let sortedNums = nums.sorted()
    var result:[[Int]] = []

    // 没有负数
    if sortedNums.first! > 0 { return [] }
    
    var positive_index = -1
    for index in 0..<sortedNums.count {
        if sortedNums[index] >= 0 {
            positive_index = index
            break
        }
    }
    
    // 没有非负数
    if positive_index == -1 { return [] }
    
    for level_1 in 0..<sortedNums.count {
        let num_1 = sortedNums[level_1]
        for level_2 in (level_1 + 1)..<sortedNums.count {
            let num_2 = sortedNums[level_2]
            if num_1 + num_2 > 0 { break }
            for level_3 in max(level_2+1, positive_index)..<sortedNums.count {
                let num_3 = sortedNums[level_3]
                if num_1 + num_2 + num_3 == 0 {
                    let list = [num_1,num_2,num_3]
                    if (!result.contains(list)) {
                        result.append(list)
                    }
                }
            }
        }
    }
    
    return result
}

/// 优化后，使用双指针（官解）
func threeSum_(_ nums: [Int]) -> [[Int]] {
    guard nums.count >= 3 else { return [] }
    
    // 排序
    let sortedNums = nums.sorted()
    var result:[[Int]] = []

// 这东西还挺耗时的😔
//    // 没有非正数
//    if sortedNums.first! > 0 { return [] }
//
//    // 没有非负数
//    if sortedNums.last! < 0 { return [] }
    
    // 遍历
    for level_1 in 0..<sortedNums.count {
        let num_1 = sortedNums[level_1]
        
        // 当前数跟前一个相等，跳过
        if (level_1 > 0 && num_1 == sortedNums[level_1 - 1]) {
            continue
        }
        
        // 指向末尾
        var level_3 = sortedNums.count - 1
        for level_2 in (level_1 + 1)..<sortedNums.count {
            let num_2 = sortedNums[level_2]
            
            // 当前数跟前一个相等，跳过
            if level_2 > (level_1 + 1) && num_2 == sortedNums[level_2 - 1] {
                continue
            }
            
            // level_2 要在 level_3 左边
            while level_2 < level_3 && num_1 + num_2 + sortedNums[level_3] > 0 {
                level_3 -= 1
            }
            
            // 跳出
            if (level_2 == level_3) { break }
            
            let num_3 = sortedNums[level_3]
            if num_1 + num_2 + num_3 == 0 {
                let list = [num_1,num_2,num_3]
                result.append(list)
            }
        }
        
    }
    
    return result
}

/// 优化后，使用双指针
func threeSum__(_ nums: [Int]) -> [[Int]] {
    guard nums.count >= 3 else { return [] }
    // 排序
    let sortedNums = nums.sorted()
    var result:[[Int]] = []
    
    for (index, level_1) in sortedNums.enumerated() {
        // 跳过相同值
        if index > 0 && sortedNums[index - 1] == level_1 {
            continue
        }
        var left = index + 1
        var right = sortedNums.count - 1
        
        // 第二层数据指针始终在左边
        while left < right {
            let level_2 = sortedNums[left]
            let level_3 = sortedNums[right]
            let res = level_1 + level_2 + level_3
            if res < 0 {
                left += 1
            } else if res > 0 {
                right -= 1
            } else {
                result.append([level_1, level_2, level_3])
                // 移动左指针，剔除相同的值
                while left < right && sortedNums[left] == sortedNums[left + 1] {
                    left += 1
                }
                // 移动右指针，提出相同的值
                while left < right && sortedNums[right] == sortedNums[right - 1] {
                    right -= 1
                }
                // 左移
                left += 1
                // 右移
                right -= 1
            }
        }
    }
    
    return result
}

/// 最接近的三数之和
func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
    guard nums.count >= 3 else { return 0 }
    var result: Int = Int(powf(10, 4))
    
    let sortedArray = nums.sorted()
    
    for (index_1, level_1) in sortedArray.enumerated() {
        if index_1 > 0 && sortedArray[index_1 - 1] == level_1 {
            continue
        }
        
        var left = index_1 + 1
        var right = sortedArray.count - 1
        
        while left < right {
            let level_2 = sortedArray[left]
            let level_3 = sortedArray[right]
            
            let res = level_1 + level_2 + level_3
            
            if res == target {
                return res
            }
            
            if abs(target - result) > abs(target - res) {
                result = res
            }
            
            if res > target {
                while left < right && level_3 == sortedArray[right - 1] {
                    right -= 1
                }
                right -= 1
            } else {
                while left < right && level_2 == sortedArray[left + 1] {
                    left += 1
                }
                left += 1
            }
        }
        
    }
    
    return result
}


func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 4 else { return [] }
    var result:[[Int]] = []
    let sorted = nums.sorted()
    
    for index_1 in 0..<sorted.count-3 {
        
        let level_1 = sorted[index_1]
        if level_1 + sorted[index_1 + 1] + sorted[index_1 + 2] + sorted[index_1 + 3] > target { break }
        if index_1 > 0 && level_1 == sorted[index_1-1]{ continue }
        
        for index_2 in index_1+1..<sorted.count-2 {
            
            let level_2 = sorted[index_2]
            if level_1 + level_2 + sorted[index_2 + 1] + sorted[index_2 + 2] > target { break }
            if index_2 > index_1+1 && level_2 == sorted[index_2-1]{ continue }
            
            var left = index_2 + 1
            var right = sorted.count - 1
            
            while left < right {
                
                let left_num = sorted[left]
                let right_num = sorted[right]
                let temp = level_1 + level_2 + left_num + right_num
                
                if temp > target {
                    right -= 1
                } else if temp < target {
                    left += 1
                } else {
                    result.append([level_1, level_2, left_num, right_num])
                    while left < right && left_num == sorted[left+1] {
                        left += 1
                    }
                    while left < right && right_num == sorted[right-1] {
                        right -= 1
                    }
                    left += 1
                    right -= 1
                }
            }
        }
    }
    
    return result
}

/// 最大盛水容器
/// 双指针，移动指向较小元素的指针，计算容积进行对比
func maxArea(_ height: [Int]) -> Int {
//    guard height.count > 1 else { return 0 }
//    guard height.count > 2 else { return min(height.first!, height.last!) }
    if height.count <= 1 { return 0 }
    if height.count == 2 { return min(height.first!, height.last!) }
    
    var first = 0
    var last = height.count - 1
    var result = 0
    
    while first < last {
        var short = 0
//        short = height[first] <= height[last] ? height[first] : height[last]
        let _first = height[first]
        let _last = height[last]
        if _first <= _last {
            short = _first
        } else {
            short = _last
        }
        
        result = max(short * (last - first), result)
        // 挪动指向较小位置的指针
        if _first <= _last {
            first += 1
        } else {
            last -= 1
        }
    }
    
    return result
}

/// 两个有序数组
func merge(_ A: inout [Int], _ m: Int, _ B: [Int], _ n: Int) {
    let t = A[0..<m]
    
    var A_index = 0
    var B_index = 0
    var t_index = 0
    
    while t_index < m {
        if B_index < n && t[t_index] > B[B_index] {
            // 如果使用t[t_index] >= B[B_index]，则算法不稳定
            A[A_index] = B[B_index]
            B_index += 1
        } else {
            A[A_index] = t[t_index]
            t_index += 1
        }
        A_index += 1
    }
    
    while A_index < m + n && B_index < n {
        A[A_index] = B[B_index]
        A_index += 1
        B_index += 1
    }
}

// MARK: Data Structure - String

/**
 *数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合。
 

 示例 1：

 输入：n = 3
 输出：["((()))","(()())","(())()","()(())","()()()"]
 示例 2：

 输入：n = 1
 输出：["()"]]
 */

/// 合成括号
func generateParenthesis(_ n: Int) -> [String] {
    guard n > 0 else { return [] }
    
    var result: [String] = []
    
    var temp: [String] = []
    let parenthesis = ["(", ")"]

    for _ in 0..<2*n {
        if temp.count == 0 {
            temp.append(parenthesis.first!)
            temp.append(parenthesis.last!)
        } else {
            var temp1: [String] = []
            for phs in parenthesis {
                for sub in temp {
                    var expending = sub
                    expending.append(phs)
                    temp1.append(expending)
                }
            }
            temp = temp1
        }
    }
    
    for target in temp {
        if target.first == ")" { continue }
        var stack = [Character]()
        for char in target {
            if char == "(" {
                stack.append(char)
            } else {
                if stack.last == "(" {
                    stack.removeLast()
                } else {
                    stack.append(char)
                }
            }
        }
        if stack.count == 0 {
            result.append(target)
        }
    }
    
    return result
}

/// 回溯：题目中出现所有组合，第一时间要想到搜索算法，深度优先或广度优先
/// 电话号码的字母组合
func letterCombinations(_ digits: String) -> [String] {
    let number_map: [String: [String]] = [
        "2" : ["a","b","c"],
        "3" : ["d","e","f"],
        "4" : ["g","h","i"],
        "5" : ["j","k","l"],
        "6" : ["m","n","o"],
        "7" : ["p","q","r","s"],
        "8" : ["t","u","v"],
        "9" : ["w","x","y","z"]
    ]
    
    var result = [String]()
    
    var temp = [[String]()];
        temp.removeAll();
    for char in digits {
        let arr = number_map[String(char)]!;
        temp.append(arr);
    }
    var index = 0;
    
    var tempResult = [String]();
    while index < temp.count {
        result.removeAll();
        let arr = temp[index];
        for char in arr {
            if tempResult.count > 0 {
                for preChar in tempResult {
                    result.append(preChar.appending(char));
                }
            } else {
                result.append(char);
            }
        }
        tempResult = result;
        index += 1;
    }
    return result
}


/// 贪心算法：当前时间做出最佳可能决策的算法，取出最大可能的目标
/// 整数转罗马数字
func intToRoman(_ num: Int) -> String {
    guard num > 0 && num < 4000 else { return "" }

    var roman_numeral = String()
    let num_map: [Int: String] = [
        1000 : "M",
        900  : "CM",
        500  : "D",
        400  : "CD",
        100  : "C",
        90   : "XC",
        50   : "L",
        40   : "XL",
        10   : "X",
        9    : "IX",
        5    : "V",
        4    : "IV",
        1    : "I"
    ]
    
    let key_nums = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    var cal_num = num
    var lastIndex = 0
    
    while cal_num != 0 {
        for index in lastIndex..<key_nums.count {
            let key_num = key_nums[index]
            if key_num > cal_num { continue }
            lastIndex = index
            cal_num = cal_num - key_num
            roman_numeral.append(num_map[key_num]!)
            break
        }
    }
    
    return roman_numeral
}

/// 动态规划 （Dynamic Programming）
/// 最长公共子序列 LCS（Longest Common Subsequence）
func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
    
//    let text1_list = text1.map{$0}
//    let text2_list = text2.map{$0}
    
    let text1_list = Array(text1)
    let text2_list = Array(text2)
    
    if text1_list.count == 0 || text2_list.count == 0 { return 0 }
    
    var dpList = [[Int]](repeating: [Int](repeating: 0, count: text2_list.count+1), count: text1_list.count+1)
    
    for i in 1...text1_list.count {
        for j in 1...text2_list.count {
            if (text1_list[i-1] == text2_list[j-1]) {
                dpList[i][j] = dpList[i-1][j-1] + 1
            } else {
                dpList[i][j] = max(dpList[i-1][j], dpList[i][j-1])
            }
        }
    }
    return dpList[text1_list.count][text2_list.count]
}


/// 字符串转整数
/** DFA (Deterministic Finite Automation) 确定有限状态机 - 自动机(Automaton)
 *  适用于有限的线性分析
 */
func myAtoi_DFA(_ s: String) -> Int {
    let automaton = Automaton()
    for char in s {
        let stop = automaton.getResult(char)
        if stop { break }
    }
    return automaton.result
}

private class Automaton : NSObject {
    var signed = 1
    var result = 0
    private var state = "start"
    private let table: [String: [String]] = [
        /*key:column  0         1           2              3   */
        "start":     ["start",  "signed",   "in_number",    "end"],
        "signed":    ["end",    "end",      "in_number",    "end"],
        "in_number": ["end",    "end",      "in_number",    "end"],
        "end":       ["end",    "end",      "end",          "end"]
    ]
    
    func getResult(_ c: Character) -> Bool {
        get(c)
        return state == "end"
    }
    
    private func get(_ c: Character) -> Void {
        state = table[state]![getColumn(c)]
        if state.elementsEqual("in_number") {
            let temp1 = Decimal(result * 10)
            let temp2 = Decimal(c.unicodeScalars.first!.value - "0".unicodeScalars.first!.value)
            let temp = temp1 + temp2
            if signed > 0 && temp > Decimal(1 << 31 - 1) {
                result = 1 << 31 - 1
                state = "end"
            } else if signed < 0 && temp > Decimal(1 << 31) {
                result = 1 << 31 * -1
                state = "end"
            } else {
                result = (temp as NSDecimalNumber).intValue
            }
        } else if state.elementsEqual("signed") {
            signed = c == "+" ? 1 : -1
        }
    }
    
    private func getColumn(_ c: Character) -> Int {
        if c == " " { return 0 }
        if c == "+" || c == "-" { return 1 }
        if c.isNumber { return 2 }
        return 3
    }
    
}

/** 线性扫描
 注意点：
 a. Swift中，默认的Int是Int64类型的，解题时需要注意不能直接使用Int.max
 b. 注意整数类型在计算时的溢出(overflow)问题
 c. 对于正负号的处理，需要注意连续出现"+"/"-"的case
 */
func myAtoi(_ s: String) -> Int {
    guard s.count > 0 else { return 0 }
    let letters = Array(s)
    var nsign = 1
    var result = String()
    var confirmedSign = false
    for char in letters {
        let current = String(char)
        if result.count == 0 && confirmedSign == false {
            if char == "-" {
                // 负数
                nsign = -1
                confirmedSign = true
            } else if (char == "+") {
                // 正数
                nsign = 1
                confirmedSign = true
            } else if current == " " {
                // 空格
                continue
            } else if char.isNumber {
                // 数字
                result.append(current)
                confirmedSign = true
            } else {
                // 其他
                break
            }
        } else {
            if char.isNumber {
                // 数字
                result.append(current)
            } else {
                break
            }
        }
    }
    
    if result.count != 0 {
        var num = 0
        let temp = Decimal(string: result)!
        if nsign > 0 {
            if temp > Decimal(integerLiteral: 1 << 31 - 1) {
                num = 1 << 31 - 1
            } else {
                num = Int(result)!
            }
        } else {
            if temp > Decimal(integerLiteral: 1 << 31 - 1) {
                num = 1 << 31 * nsign
            } else {
                num = Int(result)! * nsign
            }
        }
        return num
    } else {
        return 0
    }
}


/// Z字形变换
/// 解题关键：使用等于行数的游标进行二维数组遍历，选取第0行和第row-1行作为游标的切换点
func convert(_ s: String, _ numRows: Int) -> String {
    guard numRows > 1 else { return s }
    var letterList = [[String]](repeating: [String](), count: numRows)
    var convertedStr = String()
    let sList = Array(s)
    var row = 0
    var goDown = false
    for index in 0..<sList.count {
        if row == 0 || row == numRows - 1 {
            goDown = !goDown
        }
        letterList[row].append(String(sList[index]))
        row += (goDown ? 1 : -1)
    }
    for rowList in letterList {
        convertedStr.append(rowList.joined(separator: ""))
    }
    return convertedStr
}


func longestCommonString(_ text1: String, _ text2: String) -> String? {
    
    let shortString: String
    let longString: String
    
    if text1.count > text2.count {
        shortString = text2
        longString = text1
    } else {
        shortString = text1
        longString = text2
    }
    
    for i in 0...shortString.count {
        let length = shortString.count - i
        // 执行i次
        for j in 0...i {
            let short_sub = (shortString as NSString).substring(with: NSRange.init(location: j, length: length))
            if longString.contains(short_sub) {
                return short_sub
            }
        }
    }
    return ""
}

/// 最长不重复子字符串
/// 滑动窗口
func lengthOfLongestSubstring(_ s: String) -> Int {
    // 安全判断
    if s.count <= 1 { return s.count }
    
    //
    var longestSubstring = String()
    var stringWindow = String()
    for letter in s {
        
        // 字符串截取非常耗性能，如果用下面这种方式取，最后一个超长case超时
        // let letter = s[s.index(s.startIndex, offsetBy: i)]
        
        // 如果碰到相等的字符
        while stringWindow.contains(letter) {
            // 移除首位(窗口移动)
            stringWindow.remove(at: stringWindow.startIndex)
        }
        
        // 添加新字符
        stringWindow.append(letter)
        
        // 更新记录最长字符串
        if longestSubstring.count < stringWindow.count {
            longestSubstring = stringWindow
        }
    }
    return longestSubstring.count
}

/// 暴力解法 -  全遍历
/// 最长不重复子字符串
func lengthOfLongestSubstring_(_ s: String) -> Int {
    if s.count <= 1 { return s.count }
    var longestSubstring = ""
    for i in 0..<s.count {
        var sublongest: String = ""
        for j in 0..<s.count-i {
            let letter = s[s.index(s.index(s.startIndex, offsetBy: i), offsetBy: j)]
            if !sublongest.contains(letter) {
                sublongest.append(letter)
            } else {
                break
            }
        }
        if sublongest.count > longestSubstring.count {
            longestSubstring = sublongest
        }
    }
    return longestSubstring.count
}

/// 最长回文子串（对称字符串）
/// 中心扩散
func longestPalindrome(_ s: String) -> String {
    
    var longestPalindrome = String()
    let stringList = Array(s)
    for index in 0..<stringList.count {
        let expended = expendString(stringList, index)
        if expended.count > longestPalindrome.count {
            longestPalindrome = expended
        }
    }
    return longestPalindrome
    
    /// 开始考虑的回文字符串，以为是收尾呼应的那种，思维固化在滑动窗口方法中
    /// 使用判定首位必须是当前遍历字符进行窗口移动
    /// 本质原因是不理解什么是回文字符串
//    var palindrome = String(s[s.startIndex])
//    var window = ""
//    for char in s {
//        if window.contains(char) {
//            while window[window.startIndex] != char {
//                window.remove(at: window.startIndex)
//            }
//            window.append(char)
//        }
//        if window.count > palindrome.count { palindrome = window }
//    }
//    return palindrome
}

func expendString(_ s:[String.Element],_ index: Int) -> String {
    var palindrome = String(s[index])
    var post = index + 1
    while post < s.count && palindrome[palindrome.startIndex] == s[post] {
        palindrome.append(s[post])
        post = post + 1
    }
    var front = index - 1
    while front >= 0 && post < s.count && s[front] == s[post] {
        palindrome.append(s[post])
        palindrome.insert(s[front], at: palindrome.startIndex)
        front -= 1
        post += 1
    }
    return palindrome
}

func reverseWords(_ s: String) -> String {
    // 两端去空格
    let temp = s.trimmingCharacters(in: CharacterSet.whitespaces)
    
    // 分解数组
    let list = temp.components(separatedBy: " ")
    
    var buffer:String = ""
    var length = list.count - 1
    for words in list.reversed() {
        length -= 1
        if words == "" { continue }
        buffer.append(words)
        if length >= 0 {
            buffer.append(" ")
        }
    }
    return buffer
}

// MARK: Data Structure - List

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public var random: ListNode?

    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}

func detectCycle(_ head: ListNode?) -> ListNode? {
    var slow = head?.next
    var fast = head?.next?.next
    while fast != nil && slow != nil {
        // 首先判断有环
        if fast === slow {
            // 创建头结点及相遇结点
            var outside = head
            var inside = fast
            
            // 直到内部指针与外部指针相遇
            // 则找到入环结点
            while outside !== inside {
                outside = outside?.next
                inside = inside?.next
            }
            return outside
        } else {
            fast = fast?.next?.next
            slow = slow?.next
        }
    }
    
    return nil
}

// 暴力法
func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    var tempA = headA
    var tempB = headB
    var target : ListNode? = nil
    var hasSame = false
    while tempA != nil {
        while tempB != nil {
            if tempA?.val == tempB?.val {
                if target == nil {
                    target = tempA
                }
                hasSame = true
            } else {
                hasSame = false
            }
            tempB = tempB?.next
        }
        tempA = tempA?.next
    }
    if hasSame {
        return target
    }
    return nil
}


/// 链表的翻转
func reverseList(_ head: ListNode?) -> ListNode? {
    // 虚拟头结点
    var newHead: ListNode? = nil
    var current = head
    while current != nil {
        let temp = current?.next
        current!.next = newHead
        newHead = current
        current = temp
    }
    return newHead
}


/// 合并两个有序链表
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    guard let l1 = l1 else { return l2 }
    guard let l2 = l2 else { return l1 }
    if l1.val < l2.val {
        l1.next = mergeTwoLists(l1.next, l2)
        return l1
    } else {
        l2.next = mergeTwoLists(l2.next, l1)
        return l2
    }
}

/// 两数相加
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var current1Node = l1
    var current2Node = l2

    var needUpdate = 0

    var result: ListNode?
    var next: ListNode?

    while let _ = current1Node ?? current2Node {
        
        var num1 = 0
        var num2 = 0
        if current1Node != nil { num1 = current1Node!.val }
        if current2Node != nil { num2 = current2Node!.val }
        
        let res = num1 + num2 + needUpdate
        let current = res % 10
        needUpdate = res / 10
        
        if let _ = result {
            next?.next = ListNode(current)
            next = next?.next
        } else {
            result = ListNode(current)
            next = result
        }
        
        if current1Node != nil { current1Node = current1Node?.next }
        if current2Node != nil { current2Node = current2Node?.next }
    }
    
    if needUpdate > 0 {
        next?.next = ListNode(needUpdate)
    }

    return result
}

//func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
//
//    var current1Node = l1
//    var current2Node = l2
//
//    var needUpdate = false
//
//    let result = ListNode()
//    var resultNext = result
//
//    while current1Node != nil && current2Node != nil {
//        let num1 = current1Node!.val
//        let num2 = current2Node!.val
//        let res = num1 + num2 + (needUpdate ? 1 : 0)
//        let current = res % 10
//        resultNext.val = current
//        needUpdate = res >= 10
//
//        current1Node = current1Node!.next
//        current2Node = current2Node!.next
//
//        if current1Node != nil && current2Node != nil {
//            resultNext.next = ListNode()
//            resultNext = resultNext.next!
//        }
//
//    }
//
//    var addNode = current1Node == nil ? current2Node : current1Node
//
//    if addNode == nil && needUpdate { addNode = ListNode() }
//
//    while addNode != nil {
//        let num1 = addNode!.val
//        let num2 = needUpdate ? 1 : 0
//        let res = num1 + num2
//        let current = res % 10
//        needUpdate = res >= 10
//
//        resultNext.next = ListNode(current)
//        resultNext = resultNext.next!
//        addNode = addNode?.next
//        if addNode == nil && needUpdate { addNode = ListNode() }
//    }
//
//    return result
//}

/// 删除链表的倒数第 N 个结点
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    
    let sentinal = ListNode(-1)
    sentinal.next = head
    var first:ListNode? = sentinal
    var slow:ListNode? = sentinal
    
    for _ in 0..<n {
        first = first?.next
    }
    
    while first?.next != nil {
        first = first?.next
        slow = slow?.next
    }
    
    slow?.next = slow?.next?.next
    
    return sentinal.next
    
//    var current = head
//    var length = 0
//    while current != nil {
//        length += 1
//        current = current?.next
//    }
//
//    let target = length - n
//    let sentinel:ListNode = ListNode(-1)
//    sentinel.next = head
//    current = sentinel
//    if target >= 0 {
//        var i = 0
//        while i < target {
//            i += 1
//            current = current?.next
//        }
//        current?.next = current?.next?.next
//    }
//    return sentinel.next
    
    
//    var stack: [ListNode] = []
//    var temp = head
//    while temp != nil {
//        stack.append(temp!)
//        temp = temp?.next
//    }
//    let index = stack.count - n
//    if index >= 0 {
//        stack.remove(at: index)
//        let sentinel = ListNode(-1)
//        var last = sentinel
//        for node in stack {
//            last.next = node
//            last = node
//            last.next = nil // 需要清空
//        }
//        return sentinel.next
//    } else {
//        return head
//    }
    
//        let sentinel = ListNode.init(-1)
//        sentinel.next = reverseList(head)
//        var last: ListNode? = sentinel
//        for _ in 0..<n-1 {
//            last = last?.next
//        }
//        last!.next = last?.next?.next
//        return reverseList(sentinel.next)
}

//class Solution {
//    func detectCycle(_ head: ListNode?) -> ListNode? {
//        var map = Set<ListNode>()
//        var temp = head
//        while temp != nil && map.contains(temp!) == false {
//            map.insert(temp!)
//            temp = temp!.next
//        }
//        return temp
//    }
//}

// 两两交换链表中的节点
func swapPairs(_ head: ListNode?) -> ListNode? {
    guard let first = head, let second = first.next else { return head }
    let temp = second.next
    first.next = swapPairs(temp)
    second.next = first
    return second
}

extension ListNode: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(val)
        hasher.combine(ObjectIdentifier(self))
    }
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs === rhs
    }
}

// MARK: Data Structure - Tree

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

/// 判断二叉树是否对称
func isSymmetric(_ root: TreeNode?) -> Bool {
    guard let root = root else { return true }
    return isMirror(root.left, root.right)
}

func isMirror(_ left: TreeNode?,_ right: TreeNode?) -> Bool {
    if left == nil && right == nil { return true }
    if left == nil || right == nil { return false }
    return left!.val == right!.val && isMirror(right!.right, left!.left) && isMirror(right!.left, left!.right)
}

func preorderTraversal_2(_ root: TreeNode?) -> [Int] {
    
    guard let root = root else { return [] }
    
    var result: [Int] = []
    var stack: [TreeNode] = [root]
    var node: TreeNode? = root
    
    while stack.count > 0 || node != nil {
        
        // left
        while node != nil {
            result.append(node!.val)
            if let leftNode = node!.left {
                stack.append(leftNode)
                node = leftNode
            } else {
                node = nil
            }
        }
        
        // right
        if stack.count > 0 {
            node = stack.popLast()
            if let rightNode = node!.right {
                stack.append(rightNode)
                node = rightNode
            } else {
                node = nil
            }
        }
    }
    
    return result
}

func preorderTraversal(_ root: TreeNode?) -> [Int] {
    guard let root = root else { return [] }
    var stack: [TreeNode] = [root]
    var result: [Int] = []
    
    while let node = stack.popLast() {
        result.append(node.val)
        if let rightNode = node.right {
            stack.append(rightNode)
        }
        if let leftNode = node.left {
            stack.append(leftNode)
        }
    }
    return result
}

func inorderTraversal(_ root: TreeNode?) -> [Int] {
    guard let root = root else { return [] }
    var result: [Int] = []
    result += inorderTraversal(root.left)
    result.append(root.val)
    result += inorderTraversal(root.right)
    return result
}

func levelOrderTraversal(_ root: TreeNode?) -> [Int] {
    guard let root = root else { return [] }
    var stack: [TreeNode] = [root]
    var result: [Int] = []
    var level: Int
    var height: Int = 0
    
    level = stack.count
    while let node = stack.first {
        level -= 1
        stack.removeFirst()
        result.append(node.val)
        if let leftNode = node.left { stack.append(leftNode) }
        if let rightNode = node.right { stack.append(rightNode) }
        if level == 0 {
            level = stack.count
            height += 1
        }
    }
    return result
}

func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else { return [] }
    var stack: [TreeNode] = [root]
    var result: [[Int]] = []
    var level: Int
    var levelStack: [Int] = []
    
    level = stack.count
    
    while let node = stack.first {
        level -= 1
        stack.removeFirst()
        levelStack.append(node.val)
        if let leftNode = node.left { stack.append(leftNode) }
        if let rightNode = node.right { stack.append(rightNode) }
        if level == 0 {
            level = stack.count
            result.append(levelStack)
            levelStack.removeAll()
        }
    }
    return result
}

func maxDepth(_ root: TreeNode?) -> Int {
    guard let root = root else { return 0 }
    var stack: [TreeNode] = [root]
    var level = stack.count
    var height = 0
    while let node = stack.first {
        stack.removeFirst()
        if let leftNode = node.left {
            stack.append(leftNode)
        }
        if let rightNode = node.right {
            stack.append(rightNode)
        }
        level -= 1
        if level == 0 {
            level = stack.count
            height += 1
        }
    }
    return height
}

func maxDepthRecursive(_ root: TreeNode?) -> Int {
    guard let root = root else { return 0 }
    var rightHeight = 0
    var leftHeight = 0
    if let leftNode = root.left {
        leftHeight = maxDepthRecursive(leftNode)
    }
    if let rightNode = root.right {
        rightHeight = maxDepthRecursive(rightNode)
    }
    return 1 + max(leftHeight, rightHeight)
}

func mirrorTree(_ root: TreeNode?) -> TreeNode? {
    
    guard let root = root else { return nil }
    
    let left: TreeNode? = root.left
    let right: TreeNode? = root.right
    let temp = left
    root.left = right
    root.right = temp
    
    root.left = mirrorTree(root.left)
    root.right = mirrorTree(root.right)
    
    return root
}

func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    if (p == nil && q == nil) { return true }
    if (p == nil && q != nil) { return false }
    if (q == nil && p != nil) { return false }
    if (p!.val != q!.val) { return false }
    return isSameTree(p!.right, q!.right) && isSameTree(p!.left, q!.left);
}



