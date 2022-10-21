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
}

