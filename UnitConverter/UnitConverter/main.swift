//
//  main.swift
//  UnitConverter
//
//  Created by TaeHyeonLee on 2017. 10. 17..
//  Copyright © 2017년 ChocOZerO. All rights reserved.
//

import Foundation

var unitFlag : Bool = false
var targetFlag : Bool = false
var input : String = ""
var result : String = ""
var inputArr : Array<String> = ["", ""]

enum Unit : String {
    case cm
    case m
    case inch
}
func getUnit(target: String) -> String {
    var unit : String = ""
    if target.contains(Unit.cm.rawValue) {
        unit = Unit.cm.rawValue
    } else if target.contains(Unit.m.rawValue) {
        unit = Unit.m.rawValue
    } else if target.contains(Unit.inch.rawValue) {
        unit = Unit.inch.rawValue
    }
    return unit
}
// input
repeat {
    print("변환시킬 길이 값을 입력해 주세요.")
    input = readLine() ?? ""
    inputArr = input.components(separatedBy: " ")
    if inputArr.count > 1 {
        if Unit(rawValue: inputArr[1]) != nil {
            targetFlag = true
        } else {
            print("지원하지 않는 단위입니다.")
            targetFlag = false
        }
    } else {
        targetFlag = true
    }
    if Unit(rawValue: getUnit(target: inputArr[0])) != nil {
        unitFlag = true
    } else {
        print("지원하지 않는 단위입니다.")
        unitFlag = false
    }
} while(!targetFlag || !unitFlag)

// calculate
func getCentiMeterFromMeter(_ input: Double) -> Double {
    return input * 100
}
func getCentiMeterFromInch(_ input: Double) -> Double {
    return input * 2.54
}

func getMeterFromCentiMeter(_ input: Double) -> Double {
    return input / 100
}

func getInchFromCentiMeter(_ input: Double) -> Double {
    return input * 0.3937
}

func getTargetValue(from target: String) -> Double {
    var targetValue : Double = 0.0
    if target.contains(Unit.cm.rawValue) {
        targetValue = Double(target.prefix(target.count - 2)) ?? 0.0
    } else if target.contains(Unit.m.rawValue) {
        targetValue = Double(target.prefix(target.count - 1)) ?? 0.0
    } else if target.contains(Unit.inch.rawValue) {
        targetValue = Double(target.prefix(target.count - 4)) ?? 0.0
    }
    return targetValue
}


// output
func getResultString(_ input: String) {
    let value = getTargetValue(from: input)
    if input.contains(Unit.cm.rawValue) {
        result = String(getMeterFromCentiMeter(value)) + "m"
    } else if input.contains(Unit.m.rawValue) {
        result = String(getCentiMeterFromMeter(value)) + "cm"
    } else if input.contains(Unit.inch.rawValue) {
        result = String(getCentiMeterFromInch(value)) + "cm"
    }
    printResult(result)
}
func getResultString(_ input: String, _ target: String) {
    let value = getTargetValue(from: input)
    if input.contains(Unit.cm.rawValue) {
        switch target {
        case Unit.inch.rawValue:
            result = String(getInchFromCentiMeter(value)) + "inch"
        default:
            result = String(getMeterFromCentiMeter(value)) + "m"
        }
    } else if input.contains(Unit.m.rawValue) {
        switch target {
        case Unit.inch.rawValue:
            result = String(getInchFromCentiMeter(getCentiMeterFromMeter(value))) + "inch"
        default:
            result = String(getCentiMeterFromMeter(value)) + "cm"
        }
    } else if input.contains(Unit.inch.rawValue) {
        switch target {
        case Unit.m.rawValue:
            result = String(getMeterFromCentiMeter(getCentiMeterFromInch(value))) + "m"
        default:
            result = String(getCentiMeterFromInch(value)) + "cm"
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

