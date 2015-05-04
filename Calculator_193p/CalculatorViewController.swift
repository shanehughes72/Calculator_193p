//
//  ViewController.swift
//  Calculator_193p
//
//  Created by Worship Arts on 4/10/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    //The colon in the declaration means “…of type…,” so the code above can be read as:
    //“Declare a variable called display that is of type Boolean.”
    
   
    
    //Neither of your MVCs in this assignment is allowed to have CalculatorBrain 
    //appear anywhere in its non-private API.
    //green arrow that goes from the controller to the model
    private var brain = CalculatorBrain()

  
    @IBOutlet weak var history: UILabel!


    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
            history.text = brain.description != "?" ? brain.description : ""
        }
    }
    
    
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if operation == "±" {
                let displayText = display.text!
                if (displayText.rangeOfString("-") != nil){
                    display.text = dropFirst(displayText)
                } else {
                    display.text = "-" + displayText
                }
                return
            }
            enter()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                //lame no lame with nil instead of 0
                displayValue = nil
            }
        }
        
        
    }

    
    @IBAction func enter() {
        
        userIsInTheMiddleOfTypingANumber = false
        //operandStack.append(displayValue)
        // println("operandStack = \(operandStack)")
        //arrays know how to turn themselves into strings
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
            //maybe an error message in the display
        }
        
        
        
    }
    
    //TheString method rangeOfString(substring:String) mightbeofgreatuseto you for the floating point part of this assignment.
    //It returns an Optional. If the passed String argument cannot be found in the receiver,
    //it returns nil (otherwise don’t worry about what it returns for now).
    
//    if let displayText = display.text {
//        let numberFormatter = NSNumberFormatter()
//        numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
//        if let displayNumber = numberFormatter.numberFromString(displayText) {
//            return displayNumber.doubleValue
//        }
//    }
    
    
    
    
    
    // if the value of this var is tied to a value somewhere else use
    //computed property ( setters and getters ) instead of = something use
    // { braces and use set and get 
    // newValue is the magic new variable in this computed property
    var displayValue: Double? {
        
        get{
        
            //if let displayText = display.text {
            //    if let displayNumber = NSNumberFormatter().numberFromString(displayText) {
            //        return displayNumber.doubleValue
            //    }
            //}
            
            // optional chaining
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue

        }
        set {
            if (newValue != nil){
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
            
            if let stack = brain.showSHack(){
                if !stack.isEmpty{
                    history.text = brain.description + " ="
                }
            }
            
            userIsInTheMiddleOfTypingANumber = false
            
        }
        
        
    }
    
    
    @IBAction func clear() {
        
        brain = CalculatorBrain()
        displayValue = 0
        history.text = " "
    }
    
    
    
    //func count<T : _CollectionType>(x: T) -> T.Index.Distance
    //Description
    //Return the number of elements in x.
    //O(1) if T.Index is RandomAccessIndexType; O(N) otherwise.
    @IBAction func backSpace() {
        
        if userIsInTheMiddleOfTypingANumber {
            let displayText = display.text!
            if count(displayText) > 1 {
                display.text = dropLast(displayText)
            } else {
                if let result = brain.popOperand()  {
                    displayValue = result
                    
                } else {
                    displayValue = nil 
                }
            }
        }
        
    }
    
    
    @IBAction func storeVariable(sender: UIButton){
        if let variable = last(sender.currentTitle!){
            if displayValue != nil{
                brain.variableValues["\(variable)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                }
                else {
                    displayValue = nil
                }
            }
        }
    }
    
    
    @IBAction func pushButton(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!){
                displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    
    
    
    
    
    //Prepare for the segue firing when the graph button gets pressed. For the “normal” iPhone view the destination of the segue is its designated destination view controller, for the split view it is the visible view controller of the second navigation view controller. If the destination is the graph view controller and the segue is the one originating from the graph button set the new title. To get the last part of the description of the current program, create an array of its parts and use only the last one:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let nc = destination as? UINavigationController {
            destination = nc.visibleViewController
        }
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "plot graph":
                    gvc.title = brain.description == "" ? "Graph" :
                        brain.description.componentsSeparatedByString(", ").last
                default:
                    break
                }
            }
        }
    }
        



}//ViewController

