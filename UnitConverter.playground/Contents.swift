//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var input : String = "120cm"
var result : String = ""
if input.contains("cm") {
    result = String((Double(input.prefix(input.count - 2)) ?? 0) / 100) + "m"
} else {
    result = String(Int((Double(input.prefix(input.count - 1)) ?? 0) * 100)) + "cm"
}

print("\(result)")
