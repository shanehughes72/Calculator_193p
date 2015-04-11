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
    
    
    

 

 





    
    var displayValue: Double{
        
        get{
            // extra credit item look at documentation of NSNumberFormatter()
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
            
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            
        }
        
        
    }




















}//ViewController

