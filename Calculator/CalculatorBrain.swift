//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Roberts, Benjamin on 16/11/2015.
//  Copyright © 2015 Roberts, Benjamin. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    // enums are for 'one thing one time, another thing another time'
    // you enumerate the different types of things you could have
    
    // printable makes the enum printable
    private enum Op: CustomStringConvertible {
        // Op is either an operation or an operand
        
        // operand is of type double
        case Operand(Double)
        // opation is a function taking double arguments and returning a double
        case UnaryOperation(String, Double -> Double)
        case BinaryFunction(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryFunction(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]() // [Op]() same as initialising array of ops: Array<Op>
    
    private var knownOps = [String:Op]() // [String:Op]() same as initialising a dictionary of string op key value pairs Dictionary<String, Op>
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryFunction("×", *))
        learnOp(Op.BinaryFunction("÷") { $1 / $0 })
        learnOp(Op.BinaryFunction("+", +))
        learnOp(Op.BinaryFunction("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
    }
    
    var program: AnyObject { // guaranteed to be a PorpertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            // cannot do let op = ops.removeLast() because ops is a read only struct.
            // structs passed by value, class' passed by reference. class' can also have inheritance, but that's irrelevant here.
            // .removeLast will mutate remainingOps, taking the last value out of it.
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand): //assigning the Double parameter to variable operand
                // we only need to return the operand here
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation): // underscore means 'don't care' (about the string)
                
                // call the function again (recursion) using the remaining ops, store the tuple (one way of returning a tuple)
                let operandEvaluation = evaluate(remainingOps)
                
                // get the operand from the tuple we just got, and return the tuple with the result of 
                // the operation on the operand, and the remaining operations.
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryFunction(_, let operation):
                // here we do the same as previously, but we go another layer deeper to 
                // get the second operand and be able to call operation on both operands.
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        // this is another way of calling a function that returns a tuple.
        let (result, remainder) = evaluate(opStack) // using _ for remainingOps because we don't care about them here
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        
        // if you can look up the operation (because operation is optional here), then push it to the opstack
        // if let is a nice way of getting a Double/String/Whatever out of an optional
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}