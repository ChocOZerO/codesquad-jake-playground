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

protocol UnitConvertible {
    var value : Double { get set }
    var unitFrom : String { get set }
    var unitTo : String { get set }
    var unitBase : String { get set }
    func convert(from oldUnit: String, to newUnit: String) -> Double
    func _convertToBase(oldUnit: String) -> Double
    func _convertToTarget(value: Double, newUnit: String) -> Double
}

enum LengthUnit : String {
    case cm
    case m
    case inch
    case yard
}
let LengthUnitRate : [String:Double] = ["cm" : 1, "m" : 100, "inch" : 2.54, "yard" : 91.438]
let LengthDefaultUnit : [String:String] = ["cm" : "m", "m" : "cm", "yard" : "m"]
struct Length : UnitConvertible {
    var value : Double
    var unitFrom : String
    var unitTo : String
    var unitBase : String
    func convert(from oldUnit: String, to newUnit: String) -> Double {
        return _convertToTarget(value: _convertToBase(oldUnit: oldUnit), newUnit: newUnit)
    }
    func _convertToBase(oldUnit: String) -> Double {
        print("value : \(value)")
        return self.value * (LengthUnitRate[oldUnit] ?? 1.0)
    }
    func _convertToTarget(value: Double, newUnit: String) -> Double {
        return value / (LengthUnitRate[newUnit] ?? 1.0)
    }
}

func getLengthUnit(target: String) -> String {
    var unit : String = ""
    if target.contains(LengthUnit.cm.rawValue) {
        unit = LengthUnit.cm.rawValue
    } else if target.contains(LengthUnit.m.rawValue) {
        unit = LengthUnit.m.rawValue
    } else if target.contains(LengthUnit.inch.rawValue) {
        unit = LengthUnit.inch.rawValue
    } else if target.contains(LengthUnit.yard.rawValue) {
        unit = LengthUnit.yard.rawValue
    }
    return unit
}

func getTargetValue(from target: String) -> Double {
    var targetValue : Double = 0.0
    targetValue = Double(target.prefix(target.count - getLengthUnit(target: target).count)) ?? 0.0
    return targetValue
}


func printResult(_ result: String) {
    print("\(result)")
}

flag : while true {
    // input
    
    var unitFrom : String = ""
    var unitTo : String = ""
    repeat {
        print("변환시킬 길이 값을 입력해 주세요.")
        input = readLine() ?? ""
        if input == "q" || input == "quit" {
            break flag // 전체 loop 종료
        }
        inputArr = input.components(separatedBy: " ")
        
        // input validation
        if inputArr.count > 1 {
            if let unitTmp = LengthUnit(rawValue: inputArr[1]) {
                targetFlag = true
                unitTo = unitTmp.rawValue
            } else {
                print("지원하지 않는 단위입니다.")
                targetFlag = false
            }
        } else {
            targetFlag = true
        }
        if let unitTmp = LengthUnit(rawValue: getLengthUnit(target: inputArr[0])) {
            unitFlag = true
            unitFrom = unitTmp.rawValue
        } else {
            print("지원하지 않는 단위입니다.")
            unitFlag = false
        }
    } while(!targetFlag || !unitFlag)
    
    let value = getTargetValue(from: inputArr[0])
    let length = Length.init(value: value, unitFrom: unitFrom, unitTo: unitTo, unitBase: LengthUnit.cm.rawValue)
    if inputArr.count == 1 {
        unitTo = LengthDefaultUnit[unitFrom] ?? "cm"
    }
    printResult(String(length.convert(from: unitFrom, to: unitTo)) + unitTo)
}
