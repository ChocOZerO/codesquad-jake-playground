//
//  main.swift
//  UnitConverter
//
//  Created by TaeHyeonLee on 2017. 10. 17..
//  Copyright © 2017년 ChocOZerO. All rights reserved.
//

import Foundation

var input : String = ""
var result : String = ""
var inputArr : Array<String> = ["", ""]

enum UnitType {
    case Length
    case Weight
    case Volume
    case None
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
struct Weight {
    enum WeightUnit : String {
        case g
        case kg
        case lb
        case oz
    }
    let WeightUnitRate : [String:Double] = [WeightUnit.g.rawValue : 1, WeightUnit.kg.rawValue : 1000, WeightUnit.lb.rawValue : 453.592, WeightUnit.oz.rawValue : 28.3495]
    let WeightDefaultUnit : [String:String] = [WeightUnit.g.rawValue : WeightUnit.kg.rawValue, WeightUnit.kg.rawValue : WeightUnit.g.rawValue, WeightUnit.lb.rawValue : WeightUnit.kg.rawValue, WeightUnit.oz.rawValue : WeightUnit.kg.rawValue]
    let WeightUnits : [String] = [WeightUnit.kg.rawValue, WeightUnit.g.rawValue, WeightUnit.lb.rawValue, WeightUnit.oz.rawValue]
}
struct Volume {
    enum VolumeUnit : String {
        case L
        case pt
        case qt
        case gal
    }
    let VolumeUnitRate : [String:Double] = [VolumeUnit.L.rawValue : 1, VolumeUnit.pt.rawValue : 0.473176, VolumeUnit.qt.rawValue : 0.946353, VolumeUnit.gal.rawValue : 3.78541]
    let VolumeDefaultUnit : [String:String] = [VolumeUnit.pt.rawValue : VolumeUnit.L.rawValue, VolumeUnit.qt.rawValue : VolumeUnit.L.rawValue, VolumeUnit.gal.rawValue : VolumeUnit.L.rawValue]
    let VolumeUnits : [String] = [VolumeUnit.pt.rawValue, VolumeUnit.qt.rawValue, VolumeUnit.gal.rawValue, VolumeUnit.L.rawValue]
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
let weight = Weight.init()
let volume = Volume.init()

func getUnit(target:String) -> String? {
    let unitTypes = [volume.VolumeUnits, weight.WeightUnits, length.LengthUnits]
    
    for units in unitTypes {
        for item in units {
            if target.contains(item) {
                return item
            }
        }
    }
    return nil
}

func getTargetValue(from target: String) -> Double {
    var targetValue : Double = 0.0
    targetValue = Double(target.prefix(target.count - (getUnit(target: target) ?? "").count)) ?? 0.0
    return targetValue
}

func printResult(_ result: String) {
    print("결과 : \(result)")
}

func checkUnitType(target: String) -> UnitType {
    var unitType : UnitType = UnitType.None
    
    if Length.LengthUnit(rawValue: target) != nil {
        unitType = UnitType.Length
    } else if Weight.WeightUnit(rawValue: target) != nil {
        unitType = UnitType.Weight
    } else if Volume.VolumeUnit(rawValue: target) != nil {
        unitType = UnitType.Volume
    }
    return unitType
}

flag : while true {
    // input
    var unitFrom : String = ""
    var unitTo : String = ""
    var value : Double = 0.0
    var unitTypeFrom : UnitType = UnitType.None
    var unitTypeTo : UnitType = UnitType.None
    
    var fromFlag : Bool = false
    var toFlag : Bool = false
    
    repeat {
        print("변환시킬 값과 단위를 입력해 주세요.")
        input = readLine() ?? ""
        if input == "q" || input == "quit" {
            break flag // 전체 loop 종료
        }
        inputArr = input.components(separatedBy: " ")
        
        if let unitTmp = getUnit(target: inputArr[0]) {
            fromFlag = true
            unitFrom = unitTmp
        } else {
            print("지원하지 않는 단위입니다.")
            continue
        }
        value = getTargetValue(from: inputArr[0])
        unitTypeFrom = checkUnitType(target: unitFrom)
        
        // input validation
        if inputArr.count > 1 {
            if let unitTmp = getUnit(target: inputArr[1]) {
                toFlag = true
                unitTo = unitTmp
                unitTypeTo = checkUnitType(target: unitTo)
            } else {
                print("지원하지 않는 단위입니다.")
                continue
            }
        } else {
            unitTypeTo = unitTypeFrom
            toFlag = true
        }
        
        if unitTypeTo != unitTypeFrom {
            print("두 단위는 변환할 수 없습니다.")
            toFlag = false
        }
    } while(!toFlag || !fromFlag)
    
    var unitBase : String
    switch unitTypeTo {
    case UnitType.Length:
        unitBase = Length.LengthUnit.cm.rawValue
        let lengthUnit = Unit.init(value: value, unitBase: unitBase, unitRate: length.LengthUnitRate)
        if inputArr.count == 1 {
            unitTo = length.LengthDefaultUnit[unitFrom] ?? unitBase
        }
        printResult(String(lengthUnit.convert(from: unitFrom, to: unitTo)) + unitTo)
    case UnitType.Weight:
        unitBase = Weight.WeightUnit.g.rawValue
        let weightUnit = Unit.init(value: value, unitBase: unitBase, unitRate: weight.WeightUnitRate)
        if inputArr.count == 1 {
            unitTo = weight.WeightDefaultUnit[unitFrom] ?? unitBase
        }
        printResult(String(weightUnit.convert(from: unitFrom, to: unitTo)) + unitTo)
    case UnitType.Volume:
        unitBase = Volume.VolumeUnit.L.rawValue
        let volumeUnit = Unit.init(value: value, unitBase: unitBase, unitRate: volume.VolumeUnitRate)
        if inputArr.count == 1 {
            unitTo = volume.VolumeDefaultUnit[unitFrom] ?? unitBase
        }
        printResult(String(volumeUnit.convert(from: unitFrom, to: unitTo)) + unitTo)
    default:
        print("입력이 올바르지 않습니다")
        continue
    }
    
    
}
