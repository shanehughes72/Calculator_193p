//
//  ViewController.swift
//  Calculator_193p
//
//  Created by Worship Arts on 4/10/15.
//  Copyright (c) 2015 Shane Hughes. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    //The colon in the declaration means “…of type…,” so the code above can be read as:
    //“Declare a variable called display that is of type Boolean.”
    
    //green arrow that goes from the controller to the model
    var brain = CalculatorBrain()

  


    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                //lame
                displayValue = 0
            }
        }
        
        
    }

    
    @IBAction func enter() {
        
        userIsInTheMiddleOfTypingANumber = false
        //operandStack.append(displayValue)
        // println("operandStack = \(operandStack)")
        //arrays know how to turn themselves into strings
        if let result = brain.pushOperand(displayValue) {
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
    var displayValue: Double {
        
        get{
        
            if let displayText = display.text {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
                if let displayNumber = numberFormatter.numberFromString(displayText) {
                    return displayNumber.doubleValue
                }
            }
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
            
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            
        }
        
        
    }


}//ViewController

