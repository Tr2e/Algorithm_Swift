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
    
    // https://leetcode.cn/problems/cong-shang-dao-xia-da-yin-er-cha-shu-lcof/
    func levelOrder(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        var stack: [TreeNode] = [root]
        var result: [Int] = []
        
        while let node = stack.first {
            result.append(node.val)
            stack.removeFirst()
            if let left = node.left {
                stack.append(left)
            }
            if let right = node.right {
                stack.append(right)
            }
        }
        return result
    }
    
    // https://leetcode.cn/problems/cong-shang-dao-xia-da-yin-er-cha-shu-ii-lcof/
    func levelOrder2D(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        var result: [[Int]] = []
        var stack: [TreeNode] = [root]
        var level: Int = 0
        var levelCount: Int = stack.count
        
        while let node = stack.first {
            if result.count < level + 1 {
                result.append([])
            }
            result[level].append(node.val)
            stack.removeFirst()
            levelCount -= 1
            if let left = node.left {
                stack.append(left)
            }
            if let right = node.right {
                stack.append(right)
            }
            if levelCount == 0 {
                levelCount = stack.count
                level += 1
            }
        }
        
        return result
    }
    
    // https://leetcode.cn/problems/cong-shang-dao-xia-da-yin-er-cha-shu-iii-lcof/
    func levelOrder2Dcycle(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        var result: [[Int]] = []
        var level: Int = 0
        var levelStack: [TreeNode] = [root]
        var levelCount: Int = levelStack.count
        
        var temp: [Int] = []
        while let node = levelStack.first {
            if level % 2 == 0 {
                temp.append(node.val)
            } else {
                temp.insert(node.val, at: 0)
            }
            levelStack.removeFirst()
            levelCount -= 1
            if let left = node.left {
                levelStack.append(left)
            }
            if let right = node.right {
                levelStack.append(right)
            }
            if levelCount == 0 {
                levelCount = levelStack.count
                level += 1
                result.append(temp)
                temp.removeAll()
            }
        }
        
        return result
    }
    
    // https://leetcode.cn/problems/shu-de-zi-jie-gou-lcof/description/
    func isSubStructure(_ A: TreeNode?, _ B: TreeNode?) -> Bool {
        guard let A = A else { return false }
        guard let B = B else { return false }
        
        func isRecur(_ A: TreeNode?, _ B: TreeNode?) -> Bool {
            guard let B = B else { return true }
            guard let A = A else { return false }
            if A.val != B.val { return false }
            return isRecur(A.left, B.left) && isRecur(A.right, B.right)
        }
        
        return isRecur(A, B) || isSubStructure(A.left, B) || isSubStructure(A.right, B)
    }
    
    // https://leetcode.cn/problems/er-cha-shu-de-jing-xiang-lcof/
    func mirrorTree(_ root: TreeNode?) -> TreeNode? {
        guard let root = root else { return nil }
        
        let left = root.left
        let right = root.right
        let temp = left
        
        root.left = right
        root.right = temp
        
        _ = mirrorTree(root.left)
        _ = mirrorTree(root.right)
        
        return root
    }
    
    // https://leetcode.cn/problems/dui-cheng-de-er-cha-shu-lcof/
    func isSymmetric(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        func mirror(_ left: TreeNode?, _ right: TreeNode?) -> Bool {
            if left == nil, right == nil {
                return true
            }
            if left == nil || right == nil {
                return false
            }
            return left?.val == right?.val
                && mirror(left?.left, right?.right)
                && mirror(left?.right, right?.left)
        }
        return mirror(root.left, root.right)
    }
    
    // https://leetcode.cn/problems/fei-bo-na-qi-shu-lie-lcof/
//    var map: [Int: Int] = [:]
//    func fib(_ n: Int) -> Int {
//        if let cache = map[n] {// 记忆化搜索 空间换时间
//            return cache
//        }
//        if n == 0 || n == 1 {
//            map[n] = n
//            return n
//        }
//        let result = (fib(n - 1) + fib(n - 2)) % 1000000007
//        map[n] = result
//        return result
//    }
    
//    func fib(_ n: Int) -> Int {
//        var sum = 0, a = 0, b = 1
//        for _ in 0 ..< n {
//            sum = (a + b) % 1000000007
//            a = b
//            b = sum
//        }
//        return a
//    }
    
    func fib(_ n: Int) -> Int {
        var a = 0, b = 1
        if n < 2 { return n }
        var sum = 0
        for _ in 0...(n-2) {
            sum = a + b
            a = b
            b = sum
        }
        return sum
    }
    
    
    // https://leetcode.cn/problems/qing-wa-tiao-tai-jie-wen-ti-lcof/
//    func numWays(_ n: Int) -> Int {
//        var sum = 0, a = 1, b = 1
//        for _ in 0 ..< n {
//            sum = (a + b) % 1000000007
//            a = b
//            b = sum
//        }
//        return a
//    }
    func numWays(_ n: Int) -> Int {
        var a = 1, b = 1
        if n < 2 { return max(n, 1) }
        var sum = 0
        for _ in 0...(n-2) {
            sum = a + b
            a = b
            b = sum
        }
        return sum
    }
    
    // https://leetcode.cn/problems/gu-piao-de-zui-da-li-run-lcof/
//    func maxProfit(_ prices: [Int]) -> Int {
//        guard prices.count > 0 else { return 0 }
//        var profit = 0
//        let count = prices.count
//        for row in 0 ..< count - 1 {
//            let rowNum = prices[row]
//            for column in row + 1 ..< count {
//                let columnNum = prices[column]
//                let num = columnNum - rowNum
//                if num > profit {
//                    profit = num
//                }
//            }
//        }
//        return profit
//    }
    
    func maxProfit(_ prices: [Int]) -> Int {
        var minPrice = Int.max
        var maxProfit = 0
        for day in 0 ..< prices.count {
            if prices[day] < minPrice {
                minPrice = prices[day]
            } else if prices[day] - minPrice > maxProfit {
                maxProfit = prices[day] - minPrice
            }
        }
        return maxProfit
    }
    
    // https://leetcode.cn/problems/lian-xu-zi-shu-zu-de-zui-da-he-lcof/
    func maxSubArray(_ nums: [Int]) -> Int {
//        var dp: [Int] = []
//        for i in 0 ..< nums.count {
//            if i == 0 {
//                dp.append(nums[i])
//            } else {
//                let bigger = max(dp[i - 1] + nums[i], nums[i])
//                dp.append(bigger)
//            }
//        }
//        return dp.max() ?? Int.min
        guard nums.count > 0, var num = nums.first else { return Int.min }
        var pre = num
        for i in 1 ..< nums.count {
            pre = max(pre + nums[i], nums[i])
            num = max(pre, num)
        }
        return num
    }
    
    // https://leetcode.cn/problems/li-wu-de-zui-da-jie-zhi-lcof/
    func maxValue(_ grid: [[Int]]) -> Int {
        let rowCt = grid.count
        let colCt = grid.first!.count
        var dp: [[Int]] = []
        for rowTag in 0 ..< rowCt {
            var rowList: [Int] = []
            for colTag in 0 ..< colCt {
                let current = grid[rowTag][colTag]
                if rowTag == 0, colTag == 0 {
                    rowList.append(current)
                } else if rowTag == 0 {
                    rowList.append(rowList[colTag - 1] + current)
                } else if colTag == 0 {
                    rowList.append(dp[rowTag - 1][colTag] + current)
                } else {
                    rowList.append(max(dp[rowTag - 1][colTag] + current, rowList[colTag - 1] + current))
                }
            }
            dp.append(rowList)
        }
        return dp[rowCt - 1][colCt - 1]
    }
    
    // https://leetcode.cn/problems/ba-shu-zi-fan-yi-cheng-zi-fu-chuan-lcof/
//    func translateNum(_ num: Int) -> Int {
//        var dp: [Int] = [1]
//        let numString = String(num)
//        let numList = numString.map { String($0) }
//        
//        let count = numList.count
//        for i in 1 ..< count {
//            let a: Int = Int(String(numList[i - 1]))! * 10 + Int(String(numList[i]))!
//            if a > 25 || a < 10 {
//                dp.append(dp[i - 1])
//            } else {
//                if i == 1 {
//                    dp.append(2)
//                } else {
//                    dp.append(dp[i - 1] + dp[i - 2])
//                }
//            }
//        }
//        return dp[count - 1]
//    }
    
    func translateNum(_ num: Int) -> Int {
        var a = 1, b = 1 // a是i-1, b是i-2
        let numList = String(num).map { String($0) }
        if numList.count >= 2 {
            for i in 2 ... numList.count {
                if let count = Int(numList[i - 2] + numList[i - 1]) {
                    let sum = count > 25 || count < 10 ? a : a + b
                    b = a
                    a = sum
                }
            }
        }
        return a
    }
    
    // https://leetcode.cn/problems/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof/
    func lengthOfLongestSubstring(_ s: String) -> Int {
        var substring = ""
        var longestSubstring = ""
        for letter in s {
            while substring.contains(letter) {
                substring.removeFirst()
            }
            substring.append(letter)
            if longestSubstring.count < substring.count {
                longestSubstring = substring
            }
        }
        return longestSubstring.count
    }
    
    // https://leetcode.cn/problems/shan-chu-lian-biao-de-jie-dian-lcof/
    func deleteNode(_ head: ListNode?, _ val: Int) -> ListNode? {
        var target = head
        if target?.val == val {
            return target?.next
        }
        while let node = target?.next, node.val != val {
            target = node
        }
        if let node = target?.next, node.val == val {
            let temp = node.next
            target?.next = temp
        }
        return head
    }
    
    // https://leetcode.cn/problems/lian-biao-zhong-dao-shu-di-kge-jie-dian-lcof/
    func getKthFromEnd(_ head: ListNode?, _ k: Int) -> ListNode? {
        var tag = 0
        var fastNode: ListNode? = head
        var slowNode: ListNode? = head
        while fastNode != nil {
            tag += 1
            fastNode = fastNode?.next
            if tag > k {
                slowNode = slowNode?.next
            }
        }
        return k > tag || k < 0 ? nil : slowNode
    }
    
    // https://leetcode.cn/problems/he-bing-liang-ge-pai-xu-de-lian-biao-lcof/
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        guard let l1 = l1 else {
            return l2
        }
        guard let l2 = l2 else {
            return l1
        }
        if l1.val > l2.val {
            l2.next = mergeTwoLists(l2.next, l1)
        } else {
            l1.next = mergeTwoLists(l1.next, l2)
        }
        return l1.val > l2.val ? l2 : l1
    }
    
    func mergeTwoListsIteration(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        guard let l1 = l1 else {
            return l2
        }
        guard let l2 = l2 else {
            return l1
        }
        let sentinal = ListNode(-1)
        var pre: ListNode? = sentinal
        var node1: ListNode? = l1, node2: ListNode? = l2
        while let temp1 = node1, let temp2 = node2, let tempPre = pre {
            if temp1.val > temp2.val {
                tempPre.next = temp2
                node2 = temp2.next
            } else {
                tempPre.next = node1
                node1 = temp1.next
            }
            pre = tempPre.next
        }
        pre?.next = node1 == nil ? node2 : node1
        return sentinal.next
    }
    
    // https://leetcode.cn/problems/liang-ge-lian-biao-de-di-yi-ge-gong-gong-jie-dian-lcof/
    func getIntersectionNode(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var a = l1, b = l2
        while a != b {
            a = a == nil ? l2 : a?.next
            b = b == nil ? l1 : b?.next
        }
        return a
    }
    
    // https://leetcode.cn/problems/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof/
    func exchange(_ nums: [Int]) -> [Int] {
        var result = nums
        var first = 0, last = nums.count - 1
        while first <= last {
            if nums[last] % 2 != 0 {
                if nums[first] % 2 != 0 {
                    first += 1
                } else {
                    result[first] = nums[last]
                    result[last] = nums[first]
                    first += 1
                    last -= 1
                }
            } else {
                last -= 1
            }
        }
        return result
    }
}

