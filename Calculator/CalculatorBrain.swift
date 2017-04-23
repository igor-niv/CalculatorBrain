//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by macuser on 19.04.17.
//  Copyright © 2017 com.inarvaev. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var resultInPending: Bool?
    private var description: String? { willSet { NSLog(newValue!) } }
        
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> (Double))
        case binaryOperation((Double,Double) -> Double)
        case equales
    }
    
    private var operations : Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "sin" : Operation.unaryOperation(sin),
        "tg" : Operation.unaryOperation(tan),
        "log2" : Operation.unaryOperation(log2),
        "^" : Operation.binaryOperation({ pow($0, $1) }),
        "=" : Operation.equales
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                break
            case .unaryOperation(let function):
                if accumulator != nil {
                    description = String(symbol) + String(accumulator!)
                    accumulator = function(accumulator!)
                }
                break
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOpernd: accumulator!)
                    resultInPending = true
                    description = String(accumulator!)
                    description = description! + String(symbol)
                }
            case .equales:
                description = description! + String(accumulator!) + String(symbol)
                performPendingBinaryOperation()
                resultInPending = false
                break
            default:
                break
            }
        }
    }
    
     private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOpernd: Double
        
        func perform(with secondOperation: Double) -> Double {
            return function(firstOpernd, secondOperation)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var isResultInPending: Bool? {
        get {
            return resultInPending;
        }
    }
}
 
