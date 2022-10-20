//
//  LeetCode.swift
//  AlgorithmWithSwift
//
//  Created by Tree on 2022/10/20.
//

import Foundation

class LeetCode {
    static let `default` = LeetCode()
}

/// 移除元素
/// https://leetcode.cn/problems/remove-element/description/
extension LeetCode {
    func removeElement1(_ nums: inout [Int], _ val: Int) -> Int {
        var slow = 0
        for fast in 0 ..< nums.count {
            if nums[fast] != val {
                nums[slow] = nums[fast]
                slow += 1
            }
        }
        return slow
    }

    func removeElement2(_ nums: inout [Int], _ val: Int) -> Int {
        var prefix = 0
        var postfix = nums.count
        while prefix < postfix {
            if nums[prefix] != val {
                prefix += 1
            } else {
                postfix -= 1
                nums[prefix] = nums[postfix]
            }
        }
        return prefix
    }
}
