//
//  SwordOffer.swift
//  AlgorithmWithSwift
//
//  Created by Tree on 2022/10/20.
//

import Foundation

// MARK: https://leetcode.cn/problems/yong-liang-ge-zhan-shi-xian-dui-lie-lcof/
struct Stack<T> {
    private var array: Array<T> = []
    var isEmpty: Bool {
        array.isEmpty
    }
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        array.popLast()
    }
}

class CQueue {
    private var stack0 = Stack<Int>()
    private var stack1 = Stack<Int>()

    func appendTail(_ value: Int) {
        stack0.push(value)
    }
    
    func deleteHead() -> Int {
        if stack1.isEmpty {
            while let trail = stack0.pop() {
                stack1.push(trail)
            }
        }
        return stack1.pop() ?? -1
    }
}

// MARK: https://leetcode.cn/problems/bao-han-minhan-shu-de-zhan-lcof/
class MinStack {
    private var elements: Array = [Int]()
    private var minElements: Array = [Int]()
    
    func push(_ x: Int) {
        elements.append(x)
        if minElements.isEmpty {
            minElements.append(x)
        } else {
            minElements.append(Swift.min(x, min()))
        }
    }
    
    func pop() {
        let _ = elements.popLast()
        let _ = minElements.popLast()
    }
    
    func top() -> Int {
        elements.last ?? 0
    }
    
    func min() -> Int {
        minElements.last ?? 0
    }
}


class Solution {
    
    static let `default` = Solution()
    
    // MARK: https://leetcode.cn/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/
    func reversePrint(_ head: ListNode?) -> [Int] {
        // 第一反应就是哨兵节点，遍历节点存入数组，缺点是调用了系统Api，跟用栈其实很类似
        //        var stack = [Int]()
        //        var sentinal = ListNode()
        //        sentinal.next = head
        //        while let node = sentinal.next {
        //            stack.append(node.val)
        //            sentinal = node
        //        }
        //        return stack.reversed()
        
        // 递归存储逆序节点
        var stack = [Int]()
        func recursiveStoreNode(_ head: ListNode?) {
            guard let node = head else { return }
            recursiveStoreNode(head?.next)
            stack.append(node.val)
        }
        recursiveStoreNode(head)
        return stack
    }
    
    // MARK: https://leetcode.cn/problems/fan-zhuan-lian-biao-lcof/
    func reverseList(_ head: ListNode?) -> ListNode? {
        var newHead: ListNode? = nil
        var current = head
        while let node = current {
            let temp = node.next
            node.next = newHead
            newHead = current
            current = temp
        }
        return newHead
    }
    
    // MARK: https://leetcode.cn/problems/fu-za-lian-biao-de-fu-zhi-lcof/description/
    func copyRandomList(_ head: ListNode?) -> ListNode? {
        guard let ahead = head else {
            return head
        }
        
        var map = [ListNode: ListNode]()
        var current: ListNode? = ahead
        
        // 处理映射: 先遍历创建所有节点，并存储映射关系
        while let node = current {
            current = ListNode(node.val)
            map[node] = current
            current = node.next
        }
        
        // 处理next, random: 重新遍历，以旧链表节点为key将新的节点从map中取出
        current = ahead
        while let node = current, let target = map[node] {
            if let oldNext = node.next {
                target.next = map[oldNext]
            } else {
                target.next = nil
            }
            
            if let oldRandom = node.random {
                target.random = map[oldRandom]
            } else {
                target.random = nil
            }
            current = node.next
        }
        
        return map[ahead]
    }
    
    // https://leetcode.cn/problems/ti-huan-kong-ge-lcof/
    func replaceSpace(_ s: String) -> String {
        var result = ""
        for char in s {
            if char == " " {
                result.append("%20")
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    // https://leetcode.cn/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof/
    func reverseLeftWords(_ s: String, _ n: Int) -> String {
        guard n < s.count else { return s }
        var left = ""
        var right = ""
        for (index, char) in s.enumerated() {
            if index < n {
                right.append(char)
            } else {
                left.append(char)
            }
        }
        return left + right
    }
    
    // https://leetcode.cn/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/
    func findRepeatNumber(_ nums: [Int]) -> Int {
        var map = [Int: Int]()
        for item in nums {
            if let _ = map[item] {
                return item
            } else {
                map[item] = 1
            }
        }
        return nums.first ?? Int.min
    }
    
    func findRepeatNumberSpaceBetter(_ nums: [Int]) -> Int {
        var index = 0
        var target = nums
        while index < target.count {
            if target[index] == index {
                index += 1
                continue
            } else if target[target[index]] == target[index] {
                return target[index]
            }
            let temp = target[target[index]]
            target[target[index]] = target[index]
            target[index] = temp
        }
        return Int.min
    }
    
    // https://leetcode.cn/problems/zai-pai-xu-shu-zu-zhong-cha-zhao-shu-zi-lcof/
    func search(_ nums: [Int], _ target: Int) -> Int {
        var begin = 0
        var end = nums.count - 1
        var index = 0
        var count = 0
        
        // 二分查找
        while begin <= end {
            let mid: Int = (begin + end) >> 1
            if  nums[mid] > target {
                end = mid - 1
            } else if nums[mid] < target {
                begin = mid + 1
            } else {
                index = mid
                break
            }
        }
        
        // 中心扩散 -> left
        var left = index
        while left >= 0, left < nums.count, nums[left] == target {
            count += 1
            left -= 1
        }
        
        // 中心扩散 -> right
        var right = index + 1
        while right < nums.count, nums[right] == target {
            count += 1
            right += 1
        }
        
        return count
    }
    
    // https://leetcode.cn/problems/que-shi-de-shu-zi-lcof/
    // 解题关键点在于理解[0, n-1]n个数字都在n-1范围内
    // 正确的数字应该是跟索引一一对应
    // 错误的数字是唯一一个不对的，说明每个数字间隔1
//    func missingNumber(_ nums: [Int]) -> Int {
//        var left = 0
//        var right = nums.count - 1
//        while left <= right {
//            let mid = (left + right) >> 1
//            if nums[mid] == mid {
//                left = mid + 1
//            } else {
//                right = mid - 1
//            }
//        }
//        return left // 缺失的数字等于 “右子数组的首位元素” 对应的索引
//    }
    
    func missingNumber(_ nums: [Int]) -> Int {
        var missingIndex = 0
        for index in 1...nums.count {
            missingIndex += index
            missingIndex -= nums[index - 1]
        }
        return missingIndex
    }
    
    // https://leetcode.cn/problems/er-wei-shu-zu-zhong-de-cha-zhao-lcof/
//    func findNumberIn2DArray(_ matrix: [[Int]], _ target: Int) -> Bool {
//        for subArray in matrix {
//            var left = 0, right = subArray.count - 1
//            while left <= right {
//                let rowMid = (left + right) >> 1
//                let mid = subArray[rowMid]
//                if mid == target {
//                    return true
//                } else if mid > target {
//                    right = rowMid - 1
//                } else {
//                    left = rowMid + 1
//                }
//            }
//        }
//        return false
//    }
    
    func findNumberIn2DArray(_ matrix: [[Int]], _ target: Int) -> Bool {
        var row = matrix.count - 1, column = 0
        while row >= 0, column < (matrix.first?.count ?? 0) {
            let flag = matrix[row][column]
            if flag == target {
                return true
            } else if flag > target {
                row -= 1
            } else {
                column += 1
            }
        }
        return false
    }
    
    // https://leetcode.cn/problems/xuan-zhuan-shu-zu-de-zui-xiao-shu-zi-lcof/
    func minArray(_ numbers: [Int]) -> Int {
        var left = 0, right = numbers.count - 1
        while left < right, numbers[left] >= numbers[right] {
            left += 1
        }
        return numbers[left]
    }
    
    func minArray(numbers: [Int]) -> Int {
        var left = 0, right = numbers.count - 1
        while left < right {
            let mid = (left + right) >> 1
            let midNum = numbers[mid]
            if midNum > numbers[right] {
                left = mid + 1
            } else if midNum < numbers[right] {
                right = mid
            } else {
                right -= 1
            }
        }
        return numbers[left]
    }
    
    // https://leetcode.cn/problems/di-yi-ge-zhi-chu-xian-yi-ci-de-zi-fu-lcof/
//    func firstUniqChar(_ s: String) -> Character {
//        var charsMap: [Character: Bool] = [:]
//        var uniqChars: [Character] = []
//        for char in s {
//            if charsMap[char] != nil {
//                uniqChars.removeAll { $0 == char }
//            } else {
//                charsMap[char] = true
//                uniqChars.append(char)
//            }
//        }
//        return uniqChars.first ?? " "
//    }
    
    func firstUniqChar(_ s: String) -> Character {
        var charsMap: [Character: Int] = [:]
        for char in s {
            if let count = charsMap[char] {
                charsMap[char] = count + 1
            } else {
                charsMap[char] = 1
            }
        }
        
        for char in s {
            if let count = charsMap[char], count == 1 {
                return char
            }
        }
        return " "
    }
}

