//
//  ViewController.swift
//  Calculator
//
//  Created by Roberts, Benjamin on 12/11/2015.
//  Copyright © 2015 Roberts, Benjamin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypeingANumber: Bool = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypeingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypeingANumber = true
        }

    }
}

