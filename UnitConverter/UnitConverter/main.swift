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

enum UnitType {
    case Length
    case Weight
    case Volume
}
struct Length {
    enum LengthUnit : String {
        case cm
        case m
        case inch
        case yard
    }
    let LengthUnitRate : [String:Double] = [LengthUnit.cm.rawValue : 1, LengthUnit.m.rawValue : 100, LengthUnit.inch.rawValue : 2.54, LengthUnit.yard.rawValue : 91.438]
    let LengthDefaultUnit : [String:String] = [LengthUnit.cm.rawValue : LengthUnit.m.rawValue, LengthUnit.m.rawValue : LengthUnit.cm.rawValue, LengthUnit.yard.rawValue : LengthUnit.m.rawValue]
    
    let LengthUnits : [String] = [LengthUnit.cm.rawValue, LengthUnit.m.rawValue, LengthUnit.inch.rawValue, LengthUnit.yard.rawValue]
}
func getUnit(target:String, units: Array<String>) -> String? {
    for item in units {
        if target.contains(item) {
            return item
        }
    }
    return nil
}

struct Unit {
    var value : Double
    var unitBase : String
    var unitRate : Dictionary<String,Double>
    
    func convert(from oldUnit: String, to newUnit: String) -> Double {
        return _convertToTarget(value: _convertToBase(oldUnit: oldUnit), newUnit: newUnit)
    }
    func _convertToBase(oldUnit: String) -> Double {
        return self.value * (unitRate[oldUnit] ?? 1.0)
    }
    func _convertToTarget(value: Double, newUnit: String) -> Double {
        return value / (unitRate[newUnit] ?? 1.0)
    }
}

let length = Length.init()


func getTargetValue(from target: String, units: Array<String>) -> Double {
    var targetValue : Double = 0.0
    targetValue = Double(target.prefix(target.count - (getUnit(target: target, units: units) ?? "").count)) ?? 0.0
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
            if let unitTmp = Length.LengthUnit(rawValue: inputArr[1]) {
                targetFlag = true
                unitTo = unitTmp.rawValue
            } else {
                print("지원하지 않는 단위입니다.")
                targetFlag = false
            }
        } else {
            targetFlag = true
        }
        if let unitTmp = Length.LengthUnit(rawValue: (getUnit(target: inputArr[0], units: length.LengthUnits) ?? "") ) {
            unitFlag = true
            unitFrom = unitTmp.rawValue
        } else {
            print("지원하지 않는 단위입니다.")
            unitFlag = false
        }
    } while(!targetFlag || !unitFlag)
    
    let value = getTargetValue(from: inputArr[0], units: length.LengthUnits)
    let lengthUnit = Unit.init(value: value, unitBase: Length.LengthUnit.cm.rawValue, unitRate: length.LengthUnitRate)
    if inputArr.count == 1 {
        unitTo = length.LengthDefaultUnit[unitFrom] ?? "cm"
    }
    printResult(String(lengthUnit.convert(from: unitFrom, to: unitTo)) + unitTo)
}
