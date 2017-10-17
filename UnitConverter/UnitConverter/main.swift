//
//  main.swift
//  UnitConverter
//
//  Created by TaeHyeonLee on 2017. 10. 17..
//  Copyright © 2017년 ChocOZerO. All rights reserved.
//

import Foundation

print("변환시킬 길이 값을 입력해 주세요. 예) 1.8m -> 180cm")
var input : String? = readLine()
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
    } else if input.contains("m") {
        result = String(getCentiMeterFromMeter(input)) + "cm"
    }
    printResult(result)
}

func printResult(_ result: String) {
    print("\(result)")
}

getResultString(input ?? "0m")
