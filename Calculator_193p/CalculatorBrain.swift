//
//  CalculatorBrain.swift
//  Calculator_193p
//
//  Created by Worship Arts on 4/10/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//
// variable operands 3.mvc @ 55:45


import Foundation

class CalculatorBrain
{
    
    //Printable is a protocol - dealing with the computed property ( description )
    // swift is only langugae that you can associate values withe the cases
    // no other languages have that
    
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case NullaryOperation(String, () -> Double)
        case Variable(String)
       
        
        //computed property in the enum - read only so no set, just get
        var description: String {
            get {
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation( let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                    // using .OP to show the same as .NullaryOperation
                case .NullaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
        
    }
    
    
    // gonna make it a enum instead of class and can have computed properties - not stored properties
    // the exact same thing is: 
  //private var opStack = Array<Op>()
    private var opStack = [Op]()

    
    
    
    // could make this public
    // make private stuff private first then open it up
    // as needed
    //same as:
    //private var knownOps = Dictionary<String, Op>()
      private var knownOps = [String:Op]()
    
    // old skool declaration
    var variableValues = Dictionary<String,Double>()
    
    //Implement a new read-only (get only, no set) var to CalculatorBrain 
    //to describe the contents of the brain as a String
    var description: String{
        get {
            var (result, ops) = (" ", opStack)
            do {
            var current: String?
            (current, ops ) = description(ops)
            result = result == "" ? current! : "\(current!), \(result)"
            
            } while ops.count > 0
            return result
        }
    }
    
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (String(format: "%g", operand) , remainingOps)
            case .NullaryOperation(let symbol, _):
                return (symbol, remainingOps);
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = description(remainingOps)
                if let operand = operandEvaluation.result {
                    return ("\(symbol)(\(operand))", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = description(remainingOps)
                if var operand1 = op1Evaluation.result {
                    if remainingOps.count - op1Evaluation.remainingOps.count > 2 {
                        operand1 = "(\(operand1))"
                    }
                    let op2Evaluation = description(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return ("\(operand2) \(symbol) \(operand1)", op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return (symbol, remainingOps)
            }
        }
        return ("?", ops)
    }

    
    
    
    //here is your intializer ( constructor )
    //public - want others to make calc brains
    init() {
        //dictionaries:
        // Closures {}
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
        
        
        //havent learned sqrt yet
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        //learnOp(Op.BinaryOperation("√", √))
        
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        
        knownOps["π"] = Op.NullaryOperation("π", {M_PI} )
        
        
        // figure out the knownOps version
        learnOp(Op.UnaryOperation("±", { -$0 }))
        
        
        
        
        
        
        
    }//init
    
    
    
    
    
    
    
    
    
                // all arguments have the implicit let - there
                // is a in-out thing to look up
                // can put var in front of argument if needed
                // structs passed by value - classes passed by reference
                //ops is the argument
                // is read only ummutable  passed by value array and dictionaries are structs
                //implicit let in front of ops  esult:doesnit need to be named
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {   // 3. Applying MVC @ 40mins
        if !ops.isEmpty {
            // used to make a copy ( if not a class ) so we can mutate it
            var remainingOps = ops
            let op = remainingOps.removeLast()
            // switch is how you pull out the associated values in enums
            switch op {
                // type inference. is actually Op.operand
                          // in this space  ( let operand )is what do you want to do with the info 
                          // we want to assign it to a constant called operand
            case .Operand(let operand):
                return (operand, remainingOps)
                // underbar means i dont care about that element
            case .UnaryOperation(_, let operation):
                
                //optional double is operand
                // RECURSION //
                let operandEvaluation = evaluate(remainingOps)
                 // operationEvaluation is the tuple - we want the .result
                                                   // getting the result ( see argument name in func declaration
               // if let is turning the optional? to a double
               if let operand = operandEvaluation.result {
                                                // remaining ops after we recurse
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
            case .NullaryOperation(_, let operation):
                return (operation(), remainingOps)
                
            case .Variable(let symbol):
                return (variableValues[symbol], remainingOps)

                
            }//switch
            
        
        }
        return (nil, ops)
    }
    
    
    // 3.MVC @ 54 mins
    // and 55:30
    // has to be an optional as first operation being "+"
    // would return nil { ? is optional }
    func evaluate() -> Double? {
        
        //different way ( than evaluate func does ) to return a tuple:
        // calling the above evaluate passing in the whole opStack
        // returns result ( we have remainder for variable purposes )
        // opStack is untouched is passed by value and not consumed
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
        
    }
    
    //public - want others to do this:
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
        
    }
    //public - want others to do this:
    func performOperation(symbol:String)  -> Double? {
        
        //looking up stuff in a dictionary is square brackets
        // is always returning an OPTIONAL
        
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
        
    }
    
    // .join takes array of arrays, extracts individual elements and interposes the elements of this array repeatedly between each sequence of extracted elements, returning the results as a single array
    // map = http://www.raywenderlich.com/82599/swift-functional-programming-tutorial
    func showSHack () -> String? {
        return " ".join(opStack.map{ "\($0)"})
    }
    
    
    func ClearOpStack() {
        opStack = []
    }
    
    
    func pushOperand(symbol : String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()

    }
    
    
    
    //read up on XCT
    //func testPushOperandVariable() {
    //var brain = CalculatorBrain()
    //    XCTAssertNil(brain.pushOperand("x"))
    //    XCTAssertEqual(brain.program[0] as String, "x")
    //}
    
    
    
    
    func popOperand() -> Double? {
        if !opStack.isEmpty {
            opStack.removeLast()
        }
        
        return evaluate()
    }
   
    
    
}//CalculatorBrain





