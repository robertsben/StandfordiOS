//
//  ViewController.swift
//  Calculator
//
//  Created by Roberts, Benjamin on 12/11/2015.
//  Copyright © 2015 Roberts, Benjamin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel! // exclamation point here means display is implicitly unwrapped
    
    var userIsInTheMiddleOfTypeingANumber = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypeingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypeingANumber = true
        }

    }
    
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        if userIsInTheMiddleOfTypeingANumber {
            enter()
        }
        
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypeingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }

    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypeingANumber = false
        }
    }
}

