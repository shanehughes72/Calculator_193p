//
//  CalculatorBrain.swift
//  Calculator_193p
//
//  Created by Worship Arts on 4/10/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    
    //Printable is a protocol
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        
        var description: String {
            get {
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation( let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
        
    }
    
    
    
   
    private var opStack = [Op]()
    
    
    
    // could make this public
    // make private stuff private first then open it up
    // as needed
    private var knownOps = [String:Op]()
    //same as Dictionary<String, Op>()
    
    init() {
        //dictionaries:
        //knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
        //knownOps["÷"] = Op.BinaryOperation("÷") { $1 * $0 }
        //knownOps["+"] = Op.BinaryOperation("+") { $0 * $1 }
        //knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        //knownOps["√"] = Op.UnaryOperation("√", sqrt)
        
        func learnOp(op: Op) {
            
            knownOps[op.description] = op
        }
        
        
        
        // better code:
        
        
        // after learnOp in the init:
        //knownOps["×"] = Op.BinaryOperation("×", *)
        learnOp(Op.BinaryOperation("×", *))
        
        //knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        learnOp(Op.BinaryOperation("÷", /) )
        
        
        //knownOps["+"] = Op.BinaryOperation("+", +)
        learnOp(Op.BinaryOperation("+", +))
        
        
        //knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        learnOp(Op.BinaryOperation("-", -))
        
        
        
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        //learnOp(Op.BinaryOperation("√", √))
        
        
        
        
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            // switch is how you pull out the associated values in enums
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                // underbar means i dont care about that element
            case .UnaryOperation(_, let operation):
                
                //optional double is operand
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_,  let operation):
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
    
    // has to be an optional as first operation being "+"
    // would return nil { ? is optional }
    func evaluate() -> Double? {
        
        //different way ( than evaluate func does ) to return a tuple:
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
        
    }
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
        
    }
    
    func performOperation(symbol:String)  -> Double? {
        
        //looking up stuff in a dictionary is square brackets
        // is always returning an OPTIONAL
        
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}//CalculatorBrain
