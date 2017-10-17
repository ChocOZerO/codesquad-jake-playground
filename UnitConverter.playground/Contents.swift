//: Playground - noun: a place where people can play

import UIKit

var input : String = "1.8m"
var result : String = ""

func getCentiMeterFromMeter(_ input:String) -> Int {
    return Int((Double(input.prefix(input.count - 1)) ?? 0) * 100)
}

func getMeterFromCentiMeter(_ input: String) -> Double {
    return (Double(input.prefix(input.count - 2)) ?? 0) / 100
}

func getResultString(_ input: String) {
    if input.contains("cm") {
        result = String(getMeterFromCentiMeter(input)) + "m"
    } else {
        result = String(getCentiMeterFromMeter(input)) + "cm"
    }
    printResult(result)
}

func printResult(_ result: String) {
    print("\(result)")
}

getResultString(input)
