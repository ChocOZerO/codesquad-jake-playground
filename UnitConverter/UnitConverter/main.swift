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
    let VolumeUnits : [String] = [VolumeUnit.pt.rawValue, VolumeUnit.qt.rawValue, VolumeUnit.gal.rawValue, VolumeUnit.L.rawValue]
}

struct Unit {
    var value : Double
    var unitRate : Dictionary<String,Double>
    
    func convert(from oldUnit: String, to newUnits: Array<String>) -> String {
        var result : String = ""
        for newUnit in newUnits {
            result += " " + String(_convertToTarget(value: _convertToBase(oldUnit: oldUnit), newUnit: newUnit)) + newUnit
        }
        return result
    }
    private func _convertToBase(oldUnit: String) -> Double {
        return self.value * (unitRate[oldUnit] ?? 1.0)
    }
    private func _convertToTarget(value: Double, newUnit: String) -> Double {
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

func printResult(value: Double, unitFrom: String, unitTypeTo: UnitType, unitTo unitTargets: Array<String>) {
    var result : String = ""
    var unitTo = unitTargets
    switch unitTypeTo {
    case UnitType.Length:
        let lengthUnit = Unit.init(value: value, unitRate: length.LengthUnitRate)
        if inputArr.count == 1 {
            unitTo = getTargetUnits(from: unitFrom, to: length.LengthUnits)
        }
        result = lengthUnit.convert(from: unitFrom, to: unitTo)
    case UnitType.Weight:
        let weightUnit = Unit.init(value: value, unitRate: weight.WeightUnitRate)
        if inputArr.count == 1 {
            unitTo = getTargetUnits(from: unitFrom, to: weight.WeightUnits)
        }
        result = weightUnit.convert(from: unitFrom, to: unitTo)
    case UnitType.Volume:
        let volumeUnit = Unit.init(value: value, unitRate: volume.VolumeUnitRate)
        if inputArr.count == 1 {
            unitTo = getTargetUnits(from: unitFrom, to: volume.VolumeUnits)
        }
        result = volumeUnit.convert(from: unitFrom, to: unitTo)
    default:
        print("입력이 올바르지 않습니다")
    }
    print("결과 :\(result)")
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

func getTargetUnits(from: String, to: Array<String>) -> Array<String> {
    var result : Array<String> = []
    for item in to {
        if item != from {
            result.append(item)
        }
    }
    return result
}

programWhile : while true {
    // input
    var unitFrom : String = ""
    var unitTo : Array<String> = []
    var value : Double = 0.0
    var unitTypeFrom : UnitType = UnitType.None
    var unitTypeTo : UnitType = UnitType.None
    
    var fromFlag : Bool = false
    var toFlag : Bool = false
    
    unitWhile : repeat {
        unitTo = []
        print("변환시킬 값과 단위를 입력해 주세요.")
        input = readLine() ?? ""
        if input == "q" || input == "quit" {
            break programWhile // 전체 loop 종료
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
            var unitTypeTos : Array<UnitType> = []
            let targets : Array<String> = inputArr[1].components(separatedBy: ",")
            for target in targets {
                if let unitTmp = getUnit(target: target) {
                    toFlag = true
                    unitTo.append(unitTmp)
                    unitTypeTo = checkUnitType(target: unitTmp)
                    unitTypeTos.append(unitTypeTo)
                } else {
                    print("지원하지 않는 단위입니다.")
                    continue unitWhile
                }
            }
            for unitTypeToTmp in unitTypeTos {
                if unitTypeToTmp != unitTypeTo {
                    print("변환하려는 단위가 같은 변환단위가 아닙니다.")
                    continue unitWhile
                }
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
    
    printResult(value: value, unitFrom: unitFrom, unitTypeTo: unitTypeTo, unitTo: unitTo)
}
