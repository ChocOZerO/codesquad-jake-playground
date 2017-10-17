//
//  main.swift
//  UnitConverter
//
//  Created by TaeHyeonLee on 2017. 10. 17..
//  Copyright © 2017년 ChocOZerO. All rights reserved.
//

import Foundation

var flag : Bool = false
var input : String = ""
var result : String = ""
var inputArr : Array<String> = ["", ""]

enum Unit : String {
    case cm
    case m
    case inch
}

repeat {
    print("변환시킬 길이 값을 입력해 주세요.")
    input = readLine() ?? ""
    inputArr = input.components(separatedBy: " ")
    if Unit(rawValue: inputArr[1]) != nil {
        flag = true
    } else {
        print("지원하지 않는 단위입니다.")
    }
} while(!flag)

func getCentiMeterFromMeter(_ input: String) -> Int {
    return Int((Double(input.prefix(input.count - 1)) ?? 0) * 100)
}
func getCentiMeterFromInch(_ input: String) -> Double {
    return (Double(input.prefix(input.count - 4)) ?? 0) * 2.54
}

func getMeterFromCentiMeter(_ input: String) -> Double {
    return (Double(input.prefix(input.count - 2)) ?? 0) / 100
}

func getInchFromCentiMeter(_ input: String) -> Double {
    return (Double(input.prefix(input.count - 2)) ?? 0) * 0.3937
}

func getResultString(_ input: String) {
    
    if input.contains(Unit.cm.rawValue) {
        result = String(getMeterFromCentiMeter(input)) + "m"
    } else if input.contains(Unit.m.rawValue) {
        result = String(getCentiMeterFromMeter(input)) + "cm"
    } else if input.contains(Unit.inch.rawValue) {
        result = String(getCentiMeterFromInch(input)) + "cm"
    }
    printResult(result)
}
func getResultString(_ input: String, _ target: String) {
    
    if input.contains(Unit.cm.rawValue) {
        switch target {
        case Unit.inch.rawValue:
            result = String(getInchFromCentiMeter(input)) + "inch"
        default:
            result = String(getMeterFromCentiMeter(input)) + "m"
        }
    } else if input.contains(Unit.m.rawValue) {
        switch target {
        case Unit.inch.rawValue:
            result = String(getInchFromCentiMeter(String(getCentiMeterFromMeter(input)) + "cm")) + "inch"
        default:
            result = String(getCentiMeterFromMeter(input)) + "cm"
        }
    } else if input.contains(Unit.inch.rawValue) {
        switch target {
        case Unit.m.rawValue:
            result = String(getMeterFromCentiMeter(String(getCentiMeterFromInch(input)) + "cm")) + "m"
        default:
            result = String(getCentiMeterFromInch(input)) + "cm"
        }
    }
    printResult(result)
}

func printResult(_ result: String) {
    print("\(result)")
}

if inputArr.count > 1 {
    getResultString(inputArr[0], inputArr[1])
} else {
    getResultString(inputArr[0])
}

